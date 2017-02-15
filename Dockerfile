ARG ANSIBLE_IMAGE
ENV ANSIBLE_IMAGE ${ANSIBLE_IMAGE}

FROM quay.io/ukhomeofficedigital/ansible:${ANSIBLE_IMAGE}

RUN mkdir -p /etc/ansible/roles /etc/ansible/plays
COPY roles/* /etc/ansible/roles/
COPY plays/* /etc/ansible/plays/
COPY requirements.yml /tmp/requirements.yml

RUN ansible-galaxy install -vv -r /tmp/requirements.yml

ARG DRONE_REPO_LINK
ARG DRONE_REPO_SCM
ARG DRONE_COMMIT_REF
ARG DRONE_COMMIT_SHA
ARG DRONE_BUILD_CREATED
ARG DRONE_BUILD_NUMBER

ENV DRONE_REPO_LINK ${DRONE_REPO_LINK}
ENV DRONE_REPO_SCM ${DRONE_REPO_SCM}
ENV DRONE_COMMIT_REF ${DRONE_COMMIT_REF}
ENV DRONE_COMMIT_SHA ${DRONE_COMMIT_SHA}
ENV DRONE_BUILD_CREATED ${DRONE_BUILD_CREATED}
ENV DRONE_BUILD_NUMBER ${DRONE_BUILD_NUMBER}

# Create build identification
RUN mkdir -p /etc/build \
    && \
    echo "container: ansible-${DRONE_COMMIT_SHA}\nBuild Date: ${DRONE_BUILD_CREATED}\nBuild Number: ${DRONE_BUILD_NUMBER}\nRepo Src: ${DRONE_REPO_SCM}" > /etc/build/ansible


# Container Labels

LABEL \
  org.label-schema.name="Ansible Base Container" \
  org.label-schema.description="Container with Ansible build and deploy tools including Base Plays" \
  org.label-schema.vendor="ukhomeofficedigital" \
  org.label-schema.url="${DRONE_REPO_LINK}" \
  org.label-schema.usage="${DRONE_REPO_LINK}/README.md" \
  org.label-schema.vcs-url="${DRONE_REPO_SCM}" \
  org.label-schema.vcs-ref="${DRONE_COMMIT_REF}" \
  org.label-schema.build-date="${DRONE_BUILD_CREATED}" \
  org.label-schema.version="${DRONE_BUILD_NUMBER}" \
  org.label-schema.license="MIT" \
  org.label-schema.docker.schema-version="1.0" \
  org.label-schema.docker.cmd="docker run -it -rm --name quay.io/ukhomeofficedigital/ansible-base:latest -v environment:/etc/ansible/environment -v plays:/etc/ansible/plays -v roles:/etc/ansible/roles -v requirements.yml:/tmp/requirements.yml ansible ansible-playbook -i environment/xxx/hostfile play.yml -vv"
