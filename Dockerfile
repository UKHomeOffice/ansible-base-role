FROM quay.io/ukhomeofficedigital/terraform-data-platform:TERRAFORM_IMAGE

RUN mkdir -p /etc/ansible/roles /etc/ansible/plays
COPY roles/ /etc/ansible/roles/
COPY plays/ /etc/ansible/plays/
COPY requirements.yml /tmp/

RUN ansible-galaxy install -vv -r /tmp/requirements.yml

ARG DRONE_REPO_LINK
ARG DRONE_REMOTE_URL
ARG DRONE_COMMIT_REF
ARG DRONE_COMMIT_SHA
ARG DRONE_BUILD_CREATED
ARG DRONE_BUILD_NUMBER

# Create build identification
RUN mkdir -p /etc/build \
    && \
    echo "---"  > /etc/build/ansible-base \
    && \
    echo "container: ansible-base-${DRONE_COMMIT_SHA}" >> /etc/build/ansible-base \
    && \
    echo "Build_Date: ${DRONE_BUILD_CREATED}" >> /etc/build/ansible-base \
    && \
    echo "Build_Number: ${DRONE_BUILD_NUMBER}" >> /etc/build/ansible-base \
    && \
    echo "Repo_Src: ${DRONE_REMOTE_URL}" >> /etc/build/ansible-base


# Container Labels

LABEL \
  org.label-schema.name="Ansible Base Container" \
  org.label-schema.description="Container with Ansible build and deploy tools including Base Plays" \
  org.label-schema.vendor="ukhomeofficedigital" \
  org.label-schema.url="${DRONE_REPO_LINK}" \
  org.label-schema.usage="${DRONE_REPO_LINK}/README.md" \
  org.label-schema.vcs-url="${DRONE_REMOTE_URL}" \
  org.label-schema.vcs-ref="${DRONE_COMMIT_REF}" \
  org.label-schema.build-date="${DRONE_BUILD_CREATED}" \
  org.label-schema.version="${DRONE_BUILD_NUMBER}" \
  org.label-schema.license="MIT" \
  org.label-schema.docker.schema-version="1.0" \
  org.label-schema.docker.cmd="docker run -it -rm --name quay.io/ukhomeofficedigital/ansible-base:latest -v environment:/etc/ansible/environment -v plays:/etc/ansible/plays -v roles:/etc/ansible/roles -v requirements.yml:/tmp/requirements.yml ansible-base ansible-playbook -i environment/xxx/hostfile play.yml -vv"
