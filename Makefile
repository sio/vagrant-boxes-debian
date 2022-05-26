VAGRANT_CLOUD_TOKEN?=
export VAGRANT_CLOUD_TOKEN
VAGRANT_CLOUD_OUTPUT?=potyarkin/debian$(DEBIAN_RELEASE)


VAGRANT?=vagrant
PY?=python3


include Makefile.packer
Makefile.packer:
	curl -o $@ -L "https://gitlab.com/sio/server_common/-/raw/master/packer/Makefile.packer"


DEBIAN_CODENAME=$(firstword $(subst /, ,$(DEBIAN)))
DEBIAN_RELEASE=$(lastword $(subst /, ,$(DEBIAN)))
PACKER_FLAGS+=\
  -var output_box="$(VAGRANT_CLOUD_OUTPUT)"\
  -var debian_codename="$(DEBIAN_CODENAME)"\
  -var debian_release="$(DEBIAN_RELEASE)"


PACKER_ARTIFACTS+=output


ifdef DEBUG
export PACKER_LOG=1
export LIBGUESTFS_DEBUG=1
#export LIBGUESTFS_TRACE=1
endif


.PHONY: create
create:
	$(VAGRANT) cloud auth login --check
	$(VAGRANT) cloud box show "$(VAGRANT_CLOUD_OUTPUT)" || \
	$(VAGRANT) cloud box create "$(VAGRANT_CLOUD_OUTPUT)"


.PHONY: prune
prune: build
	$(PY) vagrant_cloud_prune.py $(VAGRANT_CLOUD_OUTPUT) 10


debian10: DEBIAN=buster/10
debian10: create build prune


debian11: DEBIAN=bullseye/11
debian11: create build prune


debian12: DEBIAN=bookworm/12
debian12: create build prune
