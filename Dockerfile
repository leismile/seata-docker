# https://hub.docker.com/_/maven
FROM maven:3.5.4-jdk-8

# set label
LABEL maintainer="seata <29130962@qq.com>"

# set environment
ENV SEATA_USER="seata" \
    TIME_ZONE="Asia/Shanghai" 

ARG SEATA_VERSION=0.5.1

WORKDIR /$BASE_DIR

RUN set -x \
    && yum update -y \
    && yum install -y wget iputils nc vim libcurl git \
    && git clone https://github.com/seata/seata.git \
    && cd /$BASE_DIR/seata \
    && git checkout v0.5.1 \
    && mvn clean package -Dmaven.test.skip=true\
    && mkdir /opt/seata \
    && cp -R /$BASE_DIR/seata/distribution/ /opt/seata/ \
    && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo '$TIME_ZONE' > /etc/timezone \
    && yum clean all

# 设置额外参数
ENV EXTRA_JVM_ARGUMENTS="-XX:MaxDirectMemorySize=1024M"

ENTRYPOINT ["sh","/opt/seata/bin/seata-server.sh"]
EXPOSE 8091
