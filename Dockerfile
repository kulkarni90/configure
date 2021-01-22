FROM docker:19.03.5

ARG USER="sky"
ARG ID="1000"
ENV ANSIBLE_VERSION="2.9.4"
ENV ANSIBLE_LINT="4.2.0"
ENV PASSLIB_VERSION="1.7.2"
ENV BCRYPT_VERSION="3.1.7"
ENV TERRAFORM_VERSION="0.12.25"
ENV GOOGLE_SDK_VERSION="279.0.0"
ENV KUBECTL_VERSION="1.13.12"
ENV KUBECTX_VERSION="0.7.1"
ENV HELM_VERSION="3.0.3"
ENV BIN_PATH="/usr/local/bin"
ENV PATH="/google-cloud-sdk/bin:${PATH}"

COPY extra /extra

RUN apk update && apk upgrade && \
  apk add --no-cache python3-dev bash git openssh-client openssl ca-certificates tar wget unzip py3-pip && \
  pip3 install --upgrade pip && \
  /extra/ansible/ansible.sh && \
  /extra/terraform/terraform.sh && \
  /extra/gcloud/gcloud.sh && \
  /extra/kube/kubectl.sh && \
  /extra/kube/kubectx.sh && \
  /extra/helm/helm.sh && \
  rm -rf /extra

RUN addgroup -g ${ID} ${USER} \
 && adduser -D -u ${ID} -G ${USER} -s /bin/bash ${USER}

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD /bin/bash
