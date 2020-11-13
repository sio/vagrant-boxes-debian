VAGRANT_CLOUD_TOKEN?=
VAGRANT_CLOUD_OUTPUT?=
VAGRANT_CLOUD_INPUT?=


VAGRANT?=vagrant


export VAGRANT_CLOUD_TOKEN
PACKER_FLAGS+=-var input_box="$(VAGRANT_CLOUD_INPUT)" -var output_box="$(VAGRANT_CLOUD_OUTPUT)"


ifdef DEBUG
export PACKER_LOG=1
export LIBGUESTFS_DEBUG=1
export LIBGUESTFS_TRACE=1
endif


.PHONY: create
create:
	$(VAGRANT) cloud auth login --check
	$(VAGRANT) cloud box show "$(VAGRANT_CLOUD_OUTPUT)" || \
	$(VAGRANT) cloud box create "$(VAGRANT_CLOUD_OUTPUT)"


debian10: VAGRANT_CLOUD_INPUT=debian/buster64
debian10: VAGRANT_CLOUD_OUTPUT=potyarkin/debian10
debian10: create build


debian11: VAGRANT_CLOUD_INPUT=debian/testing64
debian11: VAGRANT_CLOUD_OUTPUT=potyarkin/debian11
debian11: create build


include Makefile.packer
Makefile.packer:
	curl -o $@ -L "https://gitlab.com/sio/server_common/-/raw/master/packer/Makefile.packer"
