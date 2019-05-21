FROM alpine:3.7
LABEL maintainer michael.frick@ericsson.com
USER root
ARG SSH_KEY_PATH
RUN echo ${SSH_KEY_PATH}

RUN apk update && apk upgrade && \
    apk add --no-cache curl bash git openssh postgresql-client

RUN /bin/mkdir -p /seed

COPY ./gerrit-postgres-config/projects/ /seed/projects

RUN /bin/mkdir -p /root/.ssh
COPY ./gerrit-postgres-config/ssh-admin-key/id_rsa.pub ${SSH_KEY_PATH}.pub
COPY ./gerrit-postgres-config/ssh-admin-key/id_rsa ${SSH_KEY_PATH}
RUN chmod 600 ${SSH_KEY_PATH}

COPY ./scripts/health-check.sh /seed/health-check.sh
COPY ./gerrit-postgres-config/postgres.sh /seed/postgres.sh
COPY ./gerrit-postgres-config/setup.sh /seed/setup.sh
COPY ./gerrit-postgres-config/setupGerrit.sh /seed/setupGerrit.sh
COPY ./gerrit-postgres-config/groups /seed/groups
COPY ./gerrit-postgres-config/demoProject.json /seed/demoProject.json
COPY ./gerrit-postgres-config/importDemoProjects.sh /seed/importDemoProjects.sh

ADD ./gerrit-postgres-config/entrypoint.sh /seed/entrypoint.sh

CMD /bin/bash -c "cd /seed && ./entrypoint.sh"

