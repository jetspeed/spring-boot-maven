FROM anapsix/alpine-java:8_jdk AS build
MAINTAINER Mr "test@test.com"

RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.9/main" > /etc/apk/repositories

RUN apk update \
    && apk add --no-cache busybox tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asina/Shanghai > /etc/timezone \
    && apk del tzdata \
    && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /home/was/m2

VOLUME ["home/was/qlc_service"]

RUN wget https://repo.spring.io/release/org/springframework/boot/spring-boot-cli/2.2.1.RELEASE/spring-boot-cli-2.2.1.RELEASE-bin.tar.gz
RUN wget http://us.mirrors.quenda.co/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz

#spring boot
RUN tar -zxvf spring-boot-cli-2.2.1.RELEASE-bin.tar.gz -C /usr/local/
RUN tar -zxvf apache-maven-3.6.3-bin.tar.gz -C /usr/local/
RUN rm -rf *.gz

ENV SPRING_HOME /usr/local/spring-2.2.1.RELEASE
ENV M2_HOME /usr/local/apache-maven-3.6.3
ENV PATH $PATH:$JAVA_HOME/bin:$M2_HOME/bin:$SPRING_HOME/bin

WORKDIR /home/was/m2
ADD src src
ADD META-INF META-INF
ADD pom.xml .

RUN mvn clean package

FROM spring-boot-maven:base as prod
WORKDIR /home/was/qlc_service

#
##maven的settings.xml
#ADD settings.xml /usr/local/maven/apache-maven-3.6.1/conf
#
#ADD server.xml /usr/local/tomcat/apache-tomcat-8.5.38/conf
#ADD tomcat-users.xml /usr/local/tomcat/apache-tomcat-8.5.38/conf
#ADD setenv.sh /usr/local/tomcat/apache-tomcat-8.5.38/bin
#
#RUN cd /usr/local/webapp \
#    && mvn clean \
#        && mvn package -P prod \
#            && cp /usr/local/webapp/manager-web/target/manager-web.war /usr/local/tomcat/apache-tomcat-8.5.38/webapps
#
#EXPOSE 8080
#
#CMD ["./usr/local/tomcat/apache-tomcat-8.5.38/bin/catalina.sh","run"]
