export PROJECT_ID=qcar-backend
export REPO_NAME=qcar-repo
export GIT_REPO=https://github.com/Dylar/${REPO_NAME}.git
export REGION=europe-west1
export ZONE=europe-west1-b
export SERVICE_NAME=main_service
export SERVICE_DEPLOYMENT=main-service
export SERVICE_VERSION=0.0.12
export JAR_PATH=/build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar
export DOCKER_REPO=${PROJECT_ID}-repo

export DOCKER_IMAGE=${PROJECT_ID}/${SERVICE_NAME}:${SERVICE_VERSION}
export DOCKER_PREFIX=${REGION}-docker.pkg.dev
export DOCKER_PATH=${DOCKER_PREFIX}/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}
export DOCKER_IMAGE_NAME=${DOCKER_PATH}
export DOCKER_IMAGE=${DOCKER_IMAGE_NAME}:${SERVICE_VERSION}

#show all running images
kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' |sort

#on update
increase version + change deployment.yaml
git pull origin master
gradle build (in service folder)
docker build --build-arg JAR_FILE=${JAR_PATH} -t ${DOCKER_IMAGE} .
docker push ${DOCKER_IMAGE}
kubectl apply -f deployment.yaml

#on fresh start
(https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app)
git clone ${GIT_REPO}
cd ${REPO_NAME}
sh scripts/update-gradle-cloud-shell.sh

gcloud artifacts repositories create ${DOCKER_REPO}\
    --repository-format=docker \
    --location=${REGION} \
    --description=“Qcar backend docker repository”

#secrets
(https://medium.com/google-cloud/kubernetes-configmaps-and-secrets-with-firebase-426e5f4c8a36)
echo -n 'SuperSecretShit' | base64
upload secret
kubectl apply -f ./secret.yaml

#docker shit - do this in the service folder
gradle build
docker build --build-arg JAR_FILE=${JAR_PATH} -t ${DOCKER_IMAGE} .
docker images
gcloud auth configure-docker ${REGION}-docker.pkg.dev
docker push ${DOCKER_IMAGE}

#create cluster
gcloud config set compute/zone ${ZONE}
gcloud config set compute/region ${REGION}
gcloud container clusters create ${PROJECT_ID}-cluster
kubectl get nodes

#deploy
gcloud container clusters get-credentials ${PROJECT_ID}-cluster --zone ${ZONE}
kubectl create deployment ${SERVICE_DEPLOYMENT} --image=${DOCKER_IMAGE}
kubectl scale deployment ${SERVICE_DEPLOYMENT} --replicas=3
kubectl autoscale deployment ${SERVICE_DEPLOYMENT} --cpu-percent=80 --min=1 --max=5
kubectl get pods
kubectl run ${SERVICE_DEPLOYMENT} --image=${DOCKER_IMAGE} --port=2203
kubectl get deployments

#expose
kubectl expose deployment ${SERVICE_DEPLOYMENT} --name=${SERVICE_DEPLOYMENT} --type=LoadBalancer --port 2203 --target-port 2203
kubectl get service

#update
kubectl set image deployment/${SERVICE_DEPLOYMENT} ${SERVICE_NAME}=${DOCKER_IMAGE}
watch kubectl get pods

#delete service
kubectl delete service ${SERVICE_DEPLOYMENT}

#delete cluster
gcloud container clusters delete ${PROJECT_ID}-cluster --zone ${ZONE}
#delete docker image gcloud artifacts docker images delete \
 ${REGION}-docker.pkg.dev/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}:${SERVICE_VERSION} \
 --delete-tags --quiet