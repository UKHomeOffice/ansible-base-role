FROM quay.io/ukhomeofficedigital/ansible:v0.0.10

RUN mkdir -p /etc/ansible/roles /etc/ansible/plays
COPY roles/* /etc/ansible/roles/
COPY plays/* /etc/ansible/plays/
COPY requirements.yml /tmp/requirements.yml

RUN ansible-galaxy install -vv -r /tmp/requirements.yml
