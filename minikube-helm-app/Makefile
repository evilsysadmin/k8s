REGISTRY ?= $(shell minikube ip):5000
DOCKER_IMAGE = $(REGISTRY)/test
VERSION ?= latest
NAMESPACE = test
BROWSER = google-chrome

.PHONY: default minikube build deploy tests

default:
	echo "Set one action"

minikube:
	minikube delete
	minikube start --insecure-registry "192.168.99.0/24" --vm-driver=virtualbox
	minikube addons enable registry
	kubectl create ns test

delete:
	minikube delete

build:
	echo version=$(VERSION)
	docker build --tag $(DOCKER_IMAGE) .
	docker push $(DOCKER_IMAGE)
ifneq ($(VERSION), latest)
	docker build --tag $(DOCKER_IMAGE):$(VERSION) .
	docker push $(DOCKER_IMAGE):$(VERSION)
endif
	curl $(REGISTRY)/v2/_catalog
	curl $(REGISTRY)/v2/test/tags/list

deploy:
	helm upgrade test helm/test --namespace ${NAMESPACE} --create-namespace -i
	minikube service list | grep test | awk {'print $8'}
	#echo ${SERVICE_URL}
	# $(BROWSER) $(SERVICE_URL)




docker:
	docker-compose up --build -d
