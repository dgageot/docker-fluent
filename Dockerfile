FROM dgageot/maven

WORKDIR /app

ADD . /app

RUN mvn verify dependency:copy-dependencies -DskipTests && rm -Rf /app && mkdir /app