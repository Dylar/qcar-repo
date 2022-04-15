SERVICE_NAME="${1:-qcar_main_service}"
SERVICE_VERSION="${2:-0.0.1}"
JAR_PATH="build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar"

docker build --build-arg JAR_FILE="$JAR_PATH" -t qcar_main_service ./services/main_service &&
OUTPUT=$(docker images --filter="reference=qcar_main_service" --quiet) &&
docker run -d -p 80:80 "$OUTPUT"
