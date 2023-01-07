#run in service_name folder -> sh ../scripts/deploy.sh

sh ../scripts/increaseVersion.sh

SERVICE_NAME=$(./gradlew -q getName)
SERVICE_VERSION=$(./gradlew -q getVersion)
JAR_PATH="/build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar"
DOCKER_IMAGE="dylar/qcar-${SERVICE_NAME}:${SERVICE_VERSION}"

./gradlew build &&
docker build --build-arg JAR_FILE=${JAR_PATH} -t ${DOCKER_IMAGE} . &&
docker push ${DOCKER_IMAGE} &&
kubectl set image deployment/"${SERVICE_NAME}" "${SERVICE_NAME}"="${DOCKER_IMAGE}"

