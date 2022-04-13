# Create a secure apps by using Spring Boot and JKS file in OpenShift 4

The goal is creating a spring boot with an https endpoint, coming from a JKS file.

## How To
Generate a JKS file, dont forget to set the password.
```
$ keytool -genkey -alias app-key -keyalg RSA -keystore app.jks
```

For this sample, im filling this variables
```
C=ID; ST=Jakarta; L=Jakarta; O=Red Hat; OU=Open Innovation Labs; CN=Red Hat
```

Upload the JKS file, its password, and its location to OpenShift secret.
```
$ oc create secret generic spring-boot-jks-file --from-file app.jks

$ oc create secret generic spring-boot-secrets --from-literal=JKS_PASSWORD=password --from-literal=JKS_LOCATION=/tmp/jks/app.jks
``` 

Deploy the Java app
```
$ oc new-build --strategy docker --binary --docker-image openjdk:11.0.7-jre-slim-buster --name spring-boot-jks

$ oc start-build spring-boot-jks --from-dir . --follow

$ oc new-app --name=spring-boot-jks --image-stream=test-project/spring-boot-jks:latest -n test-project
```

Assign JKS and other properties, from a Secret configuration
```
$ oc set volume dc/spring-boot-jks --add --name=spring-boot-jks-mnt \
    --secret-name=spring-boot-jks-file --mount-path=/tmp/jks/

$ oc set env dc/spring-boot-jks --from=secret/spring-boot-secrets
```

Expose a passthrough Route endpoint
```
$ oc create route passthrough  --service spring-boot-jks --port=8443
``` 

Run curl to apps's endpoint to see our application's ssl configuration. 
```
curl -kv https://<apps-ip>

* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* ALPN, server did not agree to a protocol
* Server certificate:
*  subject: C=ID; ST=Jakarta; L=Jakarta; O=Red Hat; OU=Open Innovation Labs; CN=Red Hat
*  start date: Apr 11 12:27:14 2022 GMT
*  expire date: Jul 10 12:27:14 2022 GMT
*  issuer: C=ID; ST=Jakarta; L=Jakarta; O=Red Hat; OU=Open Innovation Labs; CN=Red Hat
*  SSL certificate verify result: self signed certificate (18), continuing anyway.

```

## Blog Post
Write-ups for this can be seen here,
```
https://edwin.baculsoft.com/2022/04/deploy-a-spring-boot-app-with-https-by-using-jks-file-into-openshift-4/
```
