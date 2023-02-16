FROM registry.suse.com/bci/golang:1.19

RUN zypper up -y && \
    zypper in -y -f git libgpgme-devel device-mapper-devel libbtrfs-devel \
        glib2-devel wget gzip tar && \
    zypper clean

# Download skopeo source code
ARG SKOPEO_VERSION
RUN mkdir -p $GOPATH/src/github.com/containers && \
    wget https://github.com/containers/skopeo/archive/refs/tags/${SKOPEO_VERSION}.tar.gz -O \
        $GOPATH/src/github.com/containers/${SKOPEO_VERSION}.tar.gz
# Decompress source code
RUN cd $GOPATH/src/github.com/containers/ && \
    tar -zxvf ${SKOPEO_VERSION}.tar.gz && \
        rm *.tar.gz && mv skopeo* skopeo
# Build skopeo binary and install
RUN cd $GOPATH/src/github.com/containers/skopeo && \
        DISABLE_DOCS=1 make bin/skopeo && \
        DISABLE_DOCS=1 make install
# Clean resources
RUN rm -r $GOPATH/src/github.com && \
    zypper rm -y libgpgme-devel device-mapper-devel libbtrfs-devel \
        glib2-devel wget gzip tar && \
    zypper clean

ENTRYPOINT ["skopeo"]
