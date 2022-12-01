FROM alpine
MAINTAINER Yogesh Linganna <yogesh.linganna@gmail.com>

RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.1.8/terraform_1.1.8_linux_amd64.zip && unzip /tmp/terraform.zip -d /

RUN apk add --no-cache ca-certificates curl

USER nobody

ENTRYPOINT [ "/terraform" ]


