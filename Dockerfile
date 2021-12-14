FROM openjdk:8u131-jre

WORKDIR /app

COPY target/positionsimulator-0.0.1-SNAPSHOT.jar .

CMD ["java" , "-jar" , "positionsimulator-0.0.1-SNAPSHOT.jar" ]