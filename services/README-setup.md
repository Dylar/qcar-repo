

gcloud artifacts repositories create qcar-backend-repo\
    --repository-format=docker \
    --location=europe-west1 \
    --description=“Qcar backend docker repository”


-----------

export PROJECT_ID=qcar-backend
export REPO_NAME=qcar-repo
export GIT_REPO=https://github.com/Dylar/${REPO_NAME}.git
export DOCKER_REPO=${PROJECT_ID}-repo
export REGION=europe-west1
export ZONE=europe-west1-b
export SERVICE_NAME=main_service
export SERVICE_VERSION=0.0.1
export JAR_PATH=build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar

git clone ${GIT_REPO}
cd ${GIT_REPO}

#docker shit
docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}:${SERVICE_VERSION} .
docker build --build-arg JAR_FILE=${JAR_PATH} -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}:${SERVICE_VERSION} ./services/${SERVICE_NAME}

docker images
gcloud auth configure-docker ${REGION}-docker.pkg.dev
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}:${SERVICE_VERSION}

#create cluster
gcloud config set compute/zone ${ZONE}
gcloud config set compute/region ${REGION}
gcloud container clusters create ${PROJECT_ID}-cluster
kubectl get nodes

#deploy
gcloud container clusters get-credentials ${PROJECT_ID}-cluster --zone ${ZONE}
kubectl create deployment ${SERVICE_NAME} --image=${REGION}-docker.pkg.dev/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}:${SERVICE_VERSION}
kubectl scale deployment ${SERVICE_NAME} --replicas=3
kubectl autoscale deployment ${SERVICE_NAME} --cpu-percent=80 --min=1 --max=5
kubectl get pods

#expose
kubectl expose deployment ${PROJECT_ID} --name=${SERVICE_NAME} --type=LoadBalancer --port 80 --target-port 8080
kubectl get service

#update
kubectl set image deployment/${SERVICE_NAME} ${SERVICE_NAME}=${REGION}-docker.pkg.dev/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}:${SERVICE_VERSION}-2
watch kubectl get pods

#delete service
kubectl delete service ${SERVICE_NAME}

#delete cluster
gcloud container clusters delete ${PROJECT_ID}-cluster --zone ${ZONE}
#delete docker image gcloud artifacts docker images delete \
 ${REGION}-docker.pkg.dev/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}:${SERVICE_VERSION} \
 --delete-tags --quiet