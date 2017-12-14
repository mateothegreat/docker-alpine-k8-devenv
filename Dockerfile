#
# https://github.com/mateothegreat/docker-alpine-k8-devenv
# https://hub.docker.com/r/appsoa/docker-alpine-k8-devenv
#
FROM    alpine:3.6 AS base
LABEL   AUTHOR "Matthew Davis <matthew@appsoa.io>"

ENV     WORKSPACE_BIN   /workspace/bin
ENV     WORKSPACE_HOME  /workspace
ENV     WORKSPACE_USER  user
ENV     WORKSPACE_GROUP user

ENV     KUBECTL_VERSION 1.8.0
ENV     HELM_VERSION 2.7.2
ENV     DEIS_VERSION 2.18.0
ENV     DRAFT_VERSION 0.9.0

RUN mkdir -p ${WORKSPACE_BIN} && mkdir ${WORKSPACE_BIN}/.completion && \
    addgroup -S ${WORKSPACE_GROUP} && \
    adduser -u 1000 -h ${WORKSPACE_HOME} -s /bin/bash -D -S -g ${WORKSPACE_USER} ${WORKSPACE_USER} && \
    chown -R user.user ${WORKSPACE_HOME}

WORKDIR ${WORKSPACE_HOME}

RUN apk --no-cache add          \
    bash bash-completion        \
    curl

FROM base AS base-deps

USER user

COPY .bashrc /${WORKSPACE_HOME}/.bashrc

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl ${WORKSPACE_BIN}/kubectl && \
    ${WORKSPACE_BIN}/kubectl completion bash > ${WORKSPACE_BIN}/.completion/kubectl

FROM base-deps AS base-bins

RUN curl https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar xvz && \
    mv linux-amd64/helm ${WORKSPACE_BIN} && \
    rm -rf linux-amd64 && \
    curl https://azuredraft.blob.core.windows.net/draft/draft-v0.9.0-linux-amd64.tar.gz | tar xvz && \
    mv linux-amd64/draft ${WORKSPACE_BIN} && \
    rm -rf linux-amd64 && \
    curl -sSL http://deis.io/deis-cli/install-v2.sh | bash && \
    mv deis ${WORKSPACE_BIN}

VOLUME [ "${WORKSPACE_HOME}/.kube" ]