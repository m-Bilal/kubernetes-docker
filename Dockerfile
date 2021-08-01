FROM alpine

RUN echo "Installing git"
RUN apk add --no-cache git
RUN git --version

RUN echo "installing wget"
RUN apk add --no-cache wget

# # Go version
# RUN wget https://golang.org/dl/go1.16.6.linux-amd64.tar.gz
# RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.6.linux-amd64.tar.gz
# ENV PATH="${PATH}:/usr/local/go/bin"


ARG GOLANG_VERSION=1.16
RUN echo "Installing go ver: ${GOLANG_VERSION}"
#we need the go version installed from apk to bootstrap the custom version built from source
RUN apk update && apk add go gcc bash musl-dev openssl-dev ca-certificates && update-ca-certificates
RUN wget https://dl.google.com/go/go$GOLANG_VERSION.src.tar.gz && tar -C /usr/local -xzf go$GOLANG_VERSION.src.tar.gz
RUN cd /usr/local/go/src && ./make.bash
ENV PATH=$PATH:/usr/local/go/bin
RUN rm go$GOLANG_VERSION.src.tar.gz
#we delete the apk installed version to avoid conflict
RUN apk del go
RUN go version


RUN echo "Installing rsync"
RUN apk add --no-cache rsync

RUN echo "Installing jq"
RUN apk add --no-cache jq

RUN echo "Installing Python 3"
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN python --version

RUN echo "Installing google-cloud-sdk"
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-350.0.0-linux-x86_64.tar.gz
RUN tar -xf google-cloud-sdk-350.0.0-linux-x86_64.tar.gz
RUN ./google-cloud-sdk/install.sh

RUN pip install pyyaml
ENV PATH=$GOPATH/src/k8s.io/kubernetes/third_party/etcd:${PATH}

CMD [ "bin/sh" ]