
export REPO_NAME=qcar-repo
export GIT_REPO=https://github.com/Dylar/${REPO_NAME}.git

export SERVICE_NAME=main_service
export SERVICE_VERSION=0.0.12
export JAR_PATH=/build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar

export PROJECT_ID=qcar-backend
export DOCKER_IMAGE=dylar/${PROJECT_ID}:${SERVICE_VERSION}

#show all running images
kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' |sort

#on update
increase version + change deployment.yaml
gradle build (in service folder)
docker build --build-arg JAR_FILE=${JAR_PATH} -t ${DOCKER_IMAGE} .
docker push ${DOCKER_IMAGE}
kubectl apply -f deployment.yaml

#secrets
(https://medium.com/google-cloud/kubernetes-configmaps-and-secrets-with-firebase-426e5f4c8a36)
echo -n 'SuperSecretShit' | base64
upload secret
kubectl apply -f ./secret.yaml