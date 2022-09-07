#run in service_name folder -> sh ../scripts/run.sh

SERVICE_NAME=$(./gradlew -q getName)
SERVICE_VERSION=$(./gradlew -q getVersion)
JAR_PATH=build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar

./gradlew build --warning-mode all &&
java -jar ${JAR_PATH}

