FROM adoptopenjdk/openjdk10:x86_64-ubuntu-jdk-10.0.2.13-slim

#ARG module
#ARG port
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

WORKDIR /
RUN chmod +x ./gradlew
RUN ./gradlew clean :build -x test
RUN pwd

RUN cp /build/libs/yudk.war app.war

#ARG profiles
#ARG javaXmx
#ARG javaOpts
#ENV env_profiles=$profiles
#ENV JAVA_OPTS=$javaOpts
#ENV java_xmx=$javaXmx
ENV TZ=Asia/Seoul

# TimeZone 변경
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

EXPOSE 8080
ENTRYPOINT java -Xmx1024m -Dcom.sun.management.jmxremote -Djava.net.preferIPv4Stack=true -Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dspring.profiles.active=local -Djava.security.egd=file:///dev/urandom -jar app.war
