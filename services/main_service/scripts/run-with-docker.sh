#run in service folder - sh scripts/run-with-docker.sh

#SERVICE_VERSION must be the same as in build.gradle
SERVICE_VERSION="${1:-0.0.11}"
SERVICE_NAME="$(basename $(pwd))"
PORT=8088
JAR_PATH="build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar"
CREDENTIALS_JSON="qcar-firebase-adminsdk.json"
CREDENTIALS_PATH="src/main/resources/"
CREDENTIALS=$CREDENTIALS_PATH$CREDENTIALS_JSON

./gradlew build &&
docker build \
--build-arg JAR_FILE="$JAR_PATH" \
--build-arg CREDENTIALS_FILE="$CREDENTIALS" \
-t "$SERVICE_NAME" .

IMAGE_ID=$(docker images --filter="reference=$SERVICE_NAME" --quiet)
#docker run -p "$PORT":"$PORT" "$IMAGE_ID" &&
#docker run -d -p ${PORT}:${PORT} "IMAGE_ID" --host 0.0.0.0 &&
#docker ps

docker run \
-p 9090:${PORT} \
-e PORT=${PORT} \
-e K_SERVICE=dev \
-e K_CONFIGURATION=dev \
-e K_REVISION=dev-00001 \
-e GOOGLE_APPLICATION_CREDENTIALS="credentials.json" \
-v $GOOGLE_APPLICATION_CREDENTIALS:"credentials.json":ro \
"$IMAGE_ID"