def appName = 'datahub-hasura-chm'
def namespace = "customer-hub"

pipeline {
  agent any
  environment {
    DOCKER_IMAGE = "image-repo.bri.co.id/edm/datahub/base/hasura/graphql-engine"
    DOCKER_TAG = "latest"
    TAG = "${env.GIT_COMMIT.take(8)}"
    PROJECT_NAME = "${appName}"
    NAMESPACE = "${namespace}"
  }
  
  stages {

    stage('Build Development') {
      environment {
        DOCKER_REGISTRY_URL = 'docker-registry.bigdata.bri.co.id:5000'
        DOCKER_REPO_URL = 'image-repo.bri.co.id'
        HTTP_PROXY='http://172.18.104.224:1707'
        HTTPS_PROXY='http://172.18.104.224:1707'
        NO_PROXY='172.17.0.1,172.17.0.8,k8s-load-balancer-master'
        DOCKER_CREDENTIALS = credentials('docker_registry')
        DOCKER_REPO_CREDENTIALS = credentials('image_repo_bri')
      }
      when {
        branch 'development'
      }
      steps {
        sh 'docker login ${DOCKER_REGISTRY_URL} -u $DOCKER_CREDENTIALS_USR -p ${DOCKER_CREDENTIALS_PSW}'
        sh 'docker build -t ${DOCKER_REGISTRY_URL}/${PROJECT_NAME}:${TAG} .'

        sh 'docker push ${DOCKER_REGISTRY_URL}/${PROJECT_NAME}:${TAG}'

        sh 'docker rmi ${DOCKER_REGISTRY_URL}/${PROJECT_NAME}:${TAG}'
      }
    }

    stage('Deploy Development') {
      environment {
        DOCKER_REGISTRY_URL = 'docker-registry.bigdata.bri.co.id:5000'
        HTTP_PROXY='http://10.40.1.186:80'
        HTTPS_PROXY='http://10.40.1.186:443'
        NO_PROXY='172.17.0.1,172.17.0.8,k8s-load-balancer-master'
      }
      when {
        branch 'development'
      }
      steps {
        sh """
              helm upgrade ${PROJECT_NAME} ./helm/${PROJECT_NAME} \
                --set-string image.repository=${DOCKER_REGISTRY_URL}/${PROJECT_NAME},image.tag=${TAG} \
                -f helm/${PROJECT_NAME}/values.development.yaml --debug --install --namespace ${NAMESPACE}
            """
      }
    }
    stage('Build Staging') {
      environment {
        DOCKER_REGISTRY_URL = 'calico.bigdata.bri.co.id:5000'
        HTTP_PROXY='http://172.18.104.20:1707'
        HTTPS_PROXY='http://172.18.104.20:1707'
        NO_PROXY='172.18.54.179,172.17.0.1,172.17.0.8,k8s-master-01-prod,k8s-*,10.40.210.*,172.18.*,k8s-master-vrrp-stg,gti-edm-prd-k8s-vrrp'
        DOCKER_CREDENTIALS = credentials('docker-registry-admin')
      }
      when {
        branch 'staging'
      }
      steps {
        sh 'docker login ${DOCKER_REGISTRY_URL} -u $DOCKER_CREDENTIALS_USR -p ${DOCKER_CREDENTIALS_PSW}'
        sh 'docker build -t ${DOCKER_REGISTRY_URL}/${PROJECT_NAME}:${TAG} .'

        sh 'docker push ${DOCKER_REGISTRY_URL}/${PROJECT_NAME}:${TAG}'

        sh 'docker rmi ${DOCKER_REGISTRY_URL}/${PROJECT_NAME}:${TAG}'
      }
    }

    stage('Deploy Staging') {
      environment {
        DOCKER_REGISTRY_URL = 'calico.bigdata.bri.co.id:5000'
        HTTP_PROXY='http://172.18.104.20:1707'
        HTTPS_PROXY='http://172.18.104.20:1707'
        NO_PROXY='172.18.54.179,172.17.0.1,172.17.0.8,k8s-master-01-prod,k8s-*,10.40.210.*,172.18.*,k8s-master-vrrp-stg,gti-edm-prd-k8s-vrrp'
      }
      when {
        branch 'staging'
      }
      steps {
        sh """
              helm upgrade ${PROJECT_NAME} ./helm/${PROJECT_NAME} \
                --set-string image.repository=${DOCKER_REGISTRY_URL}/${PROJECT_NAME},image.tag=${TAG} \
                -f helm/${PROJECT_NAME}/values.staging.yaml --debug --install --namespace ${NAMESPACE}
            """
      }
    }
    stage('Build Production') {
      environment {
        DOCKER_REGISTRY_URL = 'calico.bigdata.bri.co.id:5000'
        HTTP_PROXY='http://172.18.104.20:1707'
        HTTPS_PROXY='http://172.18.104.20:1707'
        NO_PROXY='172.18.54.179,172.17.0.1,172.17.0.8,k8s-master-01-prod,k8s-*,10.40.210.*,172.18.*,k8s-master-vrrp,gti-edm-prd-k8s-vrrp'
        DOCKER_CREDENTIALS = credentials('docker-registry-admin')
      }
      when {
        branch 'master'
      }
      steps {
        sh 'docker login ${DOCKER_REGISTRY_URL} -u $DOCKER_CREDENTIALS_USR -p ${DOCKER_CREDENTIALS_PSW}'
        sh 'docker build -t ${DOCKER_REGISTRY_URL}/${PROJECT_NAME}:${TAG} .'

        sh 'docker push ${DOCKER_REGISTRY_URL}/${PROJECT_NAME}:${TAG}'

        sh 'docker rmi ${DOCKER_REGISTRY_URL}/${PROJECT_NAME}:${TAG}'
      }
    }

    stage('Deploy Production') {
      environment {
        DOCKER_REGISTRY_URL = 'calico.bigdata.bri.co.id:5000'
        HTTP_PROXY='http://172.18.104.20:1707'
        HTTPS_PROXY='http://172.18.104.20:1707'
        NO_PROXY='172.18.54.179,172.17.0.1,172.17.0.8,k8s-master-01-prod,k8s-*,10.40.210.*,172.18.*,k8s-master-vrrp,gti-edm-prd-k8s-vrrp'
      }
      when {
        branch 'master'
      }
      steps {
        sh """
              helm upgrade ${PROJECT_NAME} ./helm/${PROJECT_NAME} \
                --set-string image.repository=${DOCKER_REGISTRY_URL}/${PROJECT_NAME},image.tag=${TAG} \
                -f helm/${PROJECT_NAME}/values.production.yaml --debug --install --namespace ${NAMESPACE}
            """
      }
    }
  }
}
