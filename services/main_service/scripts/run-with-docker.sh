SERVICE_NAME="${1:-main_service}"
SERVICE_VERSION="${2:-0.0.1}"
JAR_PATH="build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar"

docker build --build-arg JAR_FILE="$JAR_PATH" -t "${SERVICE_NAME}" ./services/"${SERVICE_NAME}" &&
OUTPUT=$(docker images --filter="reference=${SERVICE_NAME}" --quiet) &&
docker run -d -p 80:80 "$OUTPUT" --host 0.0.0.0 &&
docker ps