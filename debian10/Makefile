VAGRANT_CLOUD_TOKEN?=
VAGRANT_CLOUD_OUTPUT?=
VAGRANT_CLOUD_INPUT?=


VAGRANT?=vagrant


export VAGRANT_CLOUD_TOKEN


.PHONY: create
create:
	$(VAGRANT) cloud auth login --check
	$(VAGRANT) cloud box show "$(VAGRANT_CLOUD_OUTPUT)" || \
	$(VAGRANT) cloud box create "$(VAGRANT_CLOUD_OUTPUT)"


debian10: VAGRANT_CLOUD_INPUT=debian/buster
debian10: VAGRANT_CLOUD_OUTPUT=potyarkin/debian10
debian10: create



include Makefile.packer
Makefile.packer:
	curl -o $@ -L "https://gitlab.com/sio/server_common/-/raw/master/packer/Makefile.packer"
