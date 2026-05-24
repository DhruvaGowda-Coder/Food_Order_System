# Stage 1: Build the application
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Copy project files
COPY . .

# Download servlet-api and sqlite-jdbc
RUN mkdir -p lib && \
    curl -o lib/servlet-api.jar https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar && \
    curl -o lib/sqlite-jdbc.jar https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.41.2.1/sqlite-jdbc-3.41.2.1.jar

# Compile the Java source code
RUN mkdir -p WebContent/WEB-INF/classes
RUN javac -cp "lib/servlet-api.jar" -d WebContent/WEB-INF/classes src/com/foodorder/util/*.java src/com/foodorder/model/*.java src/com/foodorder/servlet/*.java

# Copy sqlite-jdbc into WEB-INF/lib
RUN mkdir -p WebContent/WEB-INF/lib && \
    cp lib/sqlite-jdbc.jar WebContent/WEB-INF/lib/

# Stage 2: Run Tomcat
FROM tomcat:9.0-jdk17

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built application to Tomcat ROOT directory
COPY --from=builder /app/WebContent /usr/local/tomcat/webapps/ROOT

EXPOSE 8080

CMD ["catalina.sh", "run"]
