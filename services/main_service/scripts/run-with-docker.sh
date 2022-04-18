#run in service folder - sh scripts/run-with-docker.sh

SERVICE_VERSION="${1:-0.0.1}"
SERVICE_NAME="$(basename $(pwd))"
PORT=8088
JAR_PATH="build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar"

#SERVICE_VERSION must be the same as in build.gradle
./gradlew build &&
docker build --build-arg JAR_FILE="$JAR_PATH" -t "$SERVICE_NAME" . &&
CONTAINER_ID=$(docker images --filter="reference=$SERVICE_NAME" --quiet) &&
docker run -p "$PORT":"$PORT" "$CONTAINER_ID" &&
#docker run -d -p ${PORT}:${PORT} "$CONTAINER_ID" --host 0.0.0.0 &&
docker ps