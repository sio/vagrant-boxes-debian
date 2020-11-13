DOCKER?=docker
DOCKER_REGISTRY?=ghcr.io
DOCKER_REGISTRY_PASSWD?=
DOCKER_USER?=sio
DOCKER_REPO?=sio/vagrant-boxes-debian


DOCKERFILES=$(wildcard *.Dockerfile)
DOCKER_TAGS=$(patsubst %.Dockerfile,%,$(DOCKERFILES))
export DOCKER_REGISTRY_PASSWD


.PHONY: $(DOCKER_TAGS)
$(DOCKER_TAGS):
	echo $$DOCKER_REGISTRY_PASSWD | $(DOCKER) login -u $(DOCKER_USER) --password-stdin $(DOCKER_REGISTRY)
	$(DOCKER) build --pull --tag "$(DOCKER_REPO):$@" - < "$@.Dockerfile"
	$(DOCKER) push "$(DOCKER_REPO):$@"
