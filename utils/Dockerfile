FROM ubuntu:24.04

ARG TERRAFORM_DEFAULT_VERSION="1.14.3"
ARG SOPS_VERSION="3.8.1"
ARG HELMFILE_VERSION="0.165.0"

ENV HELM_DIFF_USE_UPGRADE_DRY_RUN="true"

WORKDIR /app

RUN apt update \
 && apt install -y curl git gpg jq lsb-release python3 python3-pip python3-venv sudo unzip vim wget

# Terraform version manager inspired by rbenv
# https://github.com/tfutils/tfenv
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ${HOME}/.tfenv \
 && echo 'export PATH="${HOME}/.tfenv/bin:$PATH"' >> ${HOME}/.bashrc \
 && ${HOME}/.tfenv/bin/tfenv install ${TERRAFORM_DEFAULT_VERSION}

# Just utility
# https://github.com/casey/just
RUN wget -qO - 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1> /dev/null \
 && echo "deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list \
 && apt update \
 && apt install -y just

# SOPS
# https://github.com/getsops
RUN curl -LO https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 \
 && mv sops-v${SOPS_VERSION}.linux.amd64 /usr/local/bin/sops \
 && chmod +x /usr/local/bin/sops

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
 && unzip awscliv2.zip \
 && ./aws/install \
 && rm awscliv2.zip

# AWS session manager plugin
RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" -o "session-manager-plugin.deb" \
 && dpkg -i session-manager-plugin.deb \
 && rm session-manager-plugin.deb

# Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" \
 && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
 && echo 'alias k=/usr/local/bin/kubectl' >> ${HOME}/.bashrc

# Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
 && helm plugin install https://github.com/databus23/helm-diff --version v3.12.5 \
 && helm plugin install https://github.com/jkroepke/helm-secrets

# Helmfile
RUN curl -LO https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_arm64.tar.gz \
 && tar -xf helmfile_${HELMFILE_VERSION}_linux_arm64.tar.gz \
 && mv helmfile /usr/local/bin/helmfile \
 && rm helmfile_${HELMFILE_VERSION}_linux_arm64.tar.gz

 # Docker
RUN apt update \
 && apt install ca-certificates curl \
 && install -m 0755 -d /etc/apt/keyrings \
 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
 && chmod a+r /etc/apt/keyrings/docker.asc \
 && echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null \
 && apt update \
 && apt install -y docker-ce-cli

# Yandex Cloud CLI
RUN curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

# UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
 && echo 'export PATH="${HOME}/.local/bin:${PATH}"' >> ${HOME}/.bashrc

# Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash \
 && mv kustomize /usr/local/bin/kustomize

# TF summarize
RUN curl -sSOL https://github.com/dineshba/tf-summarize/releases/download/v0.3.14/tf-summarize_0.3.14_linux_arm64.deb \
 && dpkg -i tf-summarize_0.3.14_linux_arm64.deb \
 && rm -rf tf-summarize_0.3.14_linux_arm64.deb

COPY .terraformrc /root/.terraformrc
COPY justfile terraform.just /
