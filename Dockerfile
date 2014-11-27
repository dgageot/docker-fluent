FROM dgageot/maven

# Set run environment
#
ENV PROD_MODE true
ENV MEMORY 4
EXPOSE 8080
CMD java -DPROD_MODE=${PROD_MODE} -Xmx${MEMORY}G -jar target/web.jar
WORKDIR /app

# Warmup maven cache
#
ADD . /app
RUN mvn -Pprecompile verify dependency:copy-dependencies dependency:go-offline -DskipTests \
  && mvn exec:java -Dexec.mainClass=net.codestory.http.misc.PreCompile -Dexec.cleanupDaemonThreads=false \
	&& rm -Rf /app \
	&& mkdir /app

# Build the app
# (This command being last, a change in the code triggers a
# minimal rebuild)
#
ONBUILD ADD . /app
ONBUILD RUN mvn verify dependency:copy-dependencies -Dmaven.test.skip=true -DincludeScope=compile

# Precompile coffee, less, md... files
#
ONBUILD RUN mvn exec:java -Dexec.mainClass=net.codestory.http.misc.PreCompile -Dexec.cleanupDaemonThreads=false