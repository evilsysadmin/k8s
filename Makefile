REGISTRY ?= $(shell minikube ip):5000
DOCKER_IMAGE = $(REGISTRY)/test
VERSION ?= latest
NAMESPACE = test

.PHONY: default minikube build deploy tests

default:
	echo "Set one action"

minikube:
	minikube delete
	minikube start --insecure-registry "192.168.99.0/24" --vm-driver=virtualbox
	minikube addons enable registry
	kubectl get nodes

delete-all:
	minikube delete
	docker-compose stop
	docker-compose rm -f

build:
	echo version=$(VERSION)
	docker build --tag $(DOCKER_IMAGE) .
	docker push $(DOCKER_IMAGE)
ifneq ($(VERSION), latest)
	docker build --tag $(DOCKER_IMAGE):$(VERSION) .
	docker push $(DOCKER_IMAGE):$(VERSION)
endif
	curl $(REGISTRY)/v2/_catalog
	curl $(REGISTRY)/v2/api-users/tags/list

deploy:
	NAMESPACE=$(NAMESPACE) envsubst < k8s/ns.yml | kubectl apply -f -
	#kubectl -n $(NAMESPACE) apply -f k8s/db.yml
	#kubectl wait --for condition=ready --timeout 60s -n $(NAMESPACE) -l app=mysql pod
	DOCKER_IMAGE=$(DOCKER_IMAGE) envsubst < k8s/api.yml | kubectl -n $(NAMESPACE) apply -f - --context minikube
	#kubectl wait --context minikube --for condition=ready --timeout 60s -n $(NAMESPACE) -l app=api-users pod
	#kubectl -n $(NAMESPACE) get pods
	helm 

tests:
	docker-compose up --build -d
	tox
	docker-compose stop
	docker-compose rm -f

docker:
	docker-compose up --build -d
