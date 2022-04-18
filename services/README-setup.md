


-----------

export PROJECT_ID=qcar-backend
export REPO_NAME=qcar-repo
export GIT_REPO=https://github.com/Dylar/${REPO_NAME}.git
export DOCKER_REPO=${PROJECT_ID}-repo
export REGION=europe-west1
export ZONE=europe-west1-b
export SERVICE_NAME=main_service
export SERVICE_DEPLOYMENT=main-service
export SERVICE_VERSION=0.0.1
export JAR_PATH=/build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar
export DOCKER_IMAGE=${REGION}-docker.pkg.dev/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}:${SERVICE_VERSION}

git clone ${GIT_REPO}
cd ${REPO_NAME}
sh scripts/update-gradle-cloud-shell.sh

gcloud artifacts repositories create ${DOCKER_REPO}\
    --repository-format=docker \
    --location=${REGION} \
    --description=“Qcar backend docker repository”

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
kubectl run ${SERVICE_DEPLOYMENT} --image=${DOCKER_IMAGE} --port=8080
kubectl get deployments

#expose
kubectl expose deployment ${SERVICE_DEPLOYMENT} --name=${SERVICE_DEPLOYMENT} --type=LoadBalancer --port 8080 --target-port 8080
kubectl get service

#update
kubectl set image deployment/${SERVICE_NAME} ${SERVICE_NAME}=${DOCKER_IMAGE}-2
watch kubectl get pods

#delete service
kubectl delete service ${SERVICE_DEPLOYMENT}

#delete cluster
gcloud container clusters delete ${PROJECT_ID}-cluster --zone ${ZONE}
#delete docker image gcloud artifacts docker images delete \
 ${REGION}-docker.pkg.dev/${PROJECT_ID}/${DOCKER_REPO}/${SERVICE_NAME}:${SERVICE_VERSION} \
 --delete-tags --quiet