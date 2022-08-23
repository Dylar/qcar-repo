#run in service_name folder -> sh ../scripts/run.sh

SERVICE_VERSION="${1:-0.0.13}"
SERVICE_NAME="$(basename $(pwd))"

#SERVICE_VERSION must be the same as in build.gradle
./gradlew build &&
java -jar build/libs/"$SERVICE_NAME"-"$SERVICE_VERSION".jar
