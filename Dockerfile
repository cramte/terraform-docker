FROM centos:7 as fetcher
ARG TERRAFORM_VERSION=0.14.7
ARG TERRAFORM_ARCHIVE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ARG TERRAGRUNT_VERSION=v0.28.7
RUN yum install -y unzip
RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ARCHIVE} \
 && unzip "${TERRAFORM_ARCHIVE}" \
 && ls -al
RUN curl -OL https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
 && chmod +x terragrunt_linux_amd64

FROM scratch
COPY --from=fetcher /terraform /
COPY --from=fetcher /terragrunt_linux_amd64 /terragrunt
COPY --from=fetcher /tmp /tmp
ENTRYPOINT ["/terraform"]
