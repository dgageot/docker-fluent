FROM dgageot/maven

WORKDIR /app

ADD . /app

# Warmup maven cache
#
RUN mvn -Pprecompile verify dependency:copy-dependencies dependency:go-offline -DskipTests \
  && mvn exec:java -Dexec.mainClass=net.codestory.http.misc.PreCompile -Dexec.cleanupDaemonThreads=false \
	&& rm -Rf /app \
	&& mkdir /app

# Set run environment
#
ENV PROD_MODE true
ENV MEMORY 4
EXPOSE 8080
CMD java -DPROD_MODE=${PROD_MODE} -Xmx${MEMORY}G -jar target/web.jar

# Add all sources from docker context
#
ONBUILD ADD . /app

# Build the app
# (This command being last, a change in the code triggers a
# minimal rebuild)
#
ONBUILD RUN mvn verify dependency:copy-dependencies -Dmaven.test.skip=true -DincludeScope=compile \
	&& mvn exec:java -Dexec.mainClass=net.codestory.http.misc.PreCompile -Dexec.cleanupDaemonThreads=false