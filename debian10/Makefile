VAGRANT_CLOUD_TOKEN?=
VAGRANT_CLOUD_OUTPUT?=
VAGRANT_CLOUD_INPUT?=


VAGRANT?=vagrant


.PHONY: login
login: export VAGRANT_CLOUD_TOKEN
	$(VAGRANT) cloud auth login --token "$$VAGRANT_CLOUD_TOKEN"


.PHONY: create
create: login
	$(VAGRANT) cloud login --check
	$(VAGRANT) cloud box create "$(VAGRANT_CLOUD_OUTPUT)"


build: export VAGRANT_CLOUD_TOKEN


include Makefile.packer
Makefile.packer:
	curl -o $@ -L "https://gitlab.com/sio/server_common/-/raw/master/packer/Makefile.packer"
