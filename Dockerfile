FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN ./mvnw -B -ntp dependency:go-offline
COPY src/ src/
RUN ./mvnw -B -ntp package -DskipTests

# image final

FROM eclipse-temurin:17-jre
RUN apt-get update \
 && apt-get install -y --no-install-recommends --only-upgrade apt libapt-pkg7.0 \
 && rm -rf /var/lib/apt/lists/*
RUN groupadd --system petclinic && useradd --system --gid petclinic petclinic
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
USER petclinic
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]


