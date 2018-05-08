.PHONY: deploy-operator clean provision-redis

DIST_ROOT=dist
KUBE_INSTALL := $(shell command -v kubectl 2> /dev/null)
HELM_INSTALL := $(shell command -v helm 2> /dev/null)

SUB_CHARTS := $(shell ls helm/redisoperator)

all: package

check:
ifndef KUBE_INSTALL 
    $(error "kubectl is not available please install from https://kubernetes.io/")
endif
ifndef HELM_INSTALL
    $(error "helm is not available please install from https://github.com/kubernetes/helm")
endif

.init:
	helm init --client-only
	touch $@

clean:
	helm delete redisfailover --purge
	kubectl delete crd redisfailovers.storage.spotahome.com

deploy-operator: check
	helm install --name redisfailover helm/redisoperator

provision-redis:
	kubectl create -f ./redisfailover.yaml
