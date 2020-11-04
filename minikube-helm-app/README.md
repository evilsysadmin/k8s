# Simple app , deployed in minikube using helm

This is a skeleton setup , demonstrating how to use minikube as local kube cluster, using it as docker registry,
and deploying a simple nginx+fpm app.

The containers part of the helm chart (nginx and fpm ) , run with user nobody (securityContext option). This minimizes privilege granting on containers , and reduces attack surface. Pretty much containers are read only , except for logs.

This setup is stateless per design , but stateful can be easily added , as a poc with backend database/s of any type , depending on app needs. As per best practices, on real scenario kube should be stateless per design . All data storage should be allocated outside the cluster (RDS, elasticache ,whatever).

Assumptions and stuff:

- enable insecure local registry
  add this to /etc/docker/daemon.json

  { "insecure-registries":["192.168.99.0/24"] }


- start the minikube cluster with make minikube. Take note of minikube's ip with minikube ip.
- modify this ip in helm/test/values.yaml

  image:
    phpfpm:
      repository: 192.168.99.116:5000/test

- build the basic fpm dockerfile with make build. This will build locally the image ,copying the contents of src folder to    
  it, and push it to minikube registry.
- deploy the app with make deploy. This will create the helm chart, and deploy to minikube.
- you can use https://github.com/derailed/k9s to watch kube cluster activity. This assumes correct kube context (in this    
  case minikube is used.)

- once deployed, makefile will give you the load balancer ip , something similar to

| test        | test       | http/80      | http://192.168.99.116:32613 |

Just curl or browse to that url , and done.
