# web-sample

## Description
This is a very simple project mostly to show how to deploy an application.<br>
It's a good project to use with gitops where you can make easy changes and test the GitOps sync mechanism <br>

## Steps
1. View the webcolor Containerfile use to build the webcolor image
```bash
FROM registry.access.redhat.com/ubi9/httpd-24

# Add application sources
ADD app-src/index.html /var/www/html/index.html

# The run script uses standard ways to run the application
CMD run-httpd

```
Note: For disconnected env.  Change the httpd-24 image to refer to the private Registry<br>

2. Create the custom image
From the folder "build-image" which contains the "ContainerFile" file<br>
```bash
$ # move to the folder to build the image
$ cd build-image
$ # Create the image
$ podman build -t quay.io/ebeaudoi/httpd-24/webcolor.latest .
$ # Push the image to the registry
$ podman push quay.io/ebeaudoi/httpd-24/webcolor.latest
```
Note: You can change the image text color buy modifying the index.html file<br>

3. Update the deployment
Update the applicaion deployment to use the new custom image<br>
```bash
$ # Edit kustomize file
$ vim application/latest/kustomization.yaml
```
```yaml
  apiVersion: kustomize.config.k8s.io/v1beta1
  kind: Kustomization
  
  namespace: web-space
  
  resources:
    - ../../base
  
  patches:
  - target:
      kind: Deployment
      name: .*
    patch: |-
      - op: replace
        path: /spec/template/spec/containers/0/image
        value: ebdn.quay.com:8443/images/http-custom:latest
                                                                     
```

4. Deploy the application
You can use kustomize to deploy the application<br>
```bash
oc apply -f application/latest/
```

