FROM potyarkin/molecule:host-kvm

RUN apt-get -y install --no-install-recommends \
        gnupg2 \
        libguestfs-tools \
        lsb-release \
        python3-yaml \
        software-properties-common \
        && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get -y install \
        packer \
        && \
    apt-get clean
