Create jar + run local:
    ./gradlew build && java -jar build/libs/qcar_main_service-0.0.1.jar

Docker:
<!--     docker build -t kotlin .; docker run -p 4000:8080 kotlin -->
<!--     docker build -t kotlin .; docker run -p 4000:8080 -->
    Build: ./gradlew assemble docker
    Run: ./gradlew assemble docker dockerRun
    Show: docker ps
    Stop: docker stop -t <Timeout> <Container-Id>
<!--     Stop: docker stop -t 60 9b12abf55933 -->
    Stop: ./gradlew dockerStop
    Push: docker push dylar/qcar-backend:tagname
<!--     ./gradlew docker dockerPush -->