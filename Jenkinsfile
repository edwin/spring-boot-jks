node('maven') {
    def tag;

    stage ('pull code') {
        sh "git clone https://github.com/edwin/spring-boot-jks source "
    }
    stage ('mvn build') {
        dir("source") {
            tag = sh(returnStdout: true, script: "git rev-parse --short=8 HEAD").trim();

            sh "mkdir -p build-folder/target"
            sh "mkdir properties-folder"
            sh "mvn -B clean package -Dmaven.repo.local=/tmp/source/m2 "

            sh "cp Dockerfile build-folder/Dockerfile"
            sh "cp target/*.jar build-folder/target/app.jar"
        }
    }
    stage ('build and push') {
        dir("source") {
            sh "cat build-folder/Dockerfile | oc new-build -D - --name spring-boot-jks || true"
            sh "oc start-build spring-boot-jks --from-dir=build-folder/. --follow --wait "
            sh "oc tag cicd/spring-boot-jks:latest labs-dev/spring-boot-jks:${tag} "
            sh "oc tag cicd/spring-boot-jks:latest labs-dev/spring-boot-jks:latest "
        }
    }
    stage ('create secrets') {
        dir("source") {
            sh "oc create secret generic spring-boot-jks-file --from-file app.jks  -n labs-dev || true"
            sh "oc create secret generic spring-boot-secrets --from-literal=JKS_PASSWORD=password --from-literal=JKS_LOCATION=/tmp/jks/app.jks  -n labs-dev || true"
        }
    }
    stage ('deploy and attach secrets') {
        dir("source") {
            sh "oc new-app --image-stream=labs-dev/spring-boot-jks:latest \
                --name spring-boot-jks  -n labs-dev --as-deployment-config || true "
            sh "oc set volume dc/spring-boot-jks --add --name=spring-boot-jks-mnt --secret-name=spring-boot-jks-file --mount-path=/tmp/jks/  -n labs-dev || true "
            sh "oc set env dc/spring-boot-jks --from=secret/spring-boot-secrets -n labs-dev || true "
        }
    }
    stage ('expose API') {
        dir("source") {
            sh "oc create route passthrough  --service spring-boot-jks --port=8443 -n labs-dev || true "
        }
    }
}