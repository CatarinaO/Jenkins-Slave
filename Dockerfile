#FROM registry.access.redhat.com/ubi8/ubi
FROM docker.io/library/centos:8

LABEL maintainer="Remi José Dias <jose.dias@ctw.bmwgroup.com>"

ARG TERRAFORM_VERSION="0.12.9"
ARG TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG OPENSHIFT_INSTALLER_VERSION="4.1.18"
ARG OPENSHIFT_INSTALLER_URL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_INSTALLER_VERSION}/openshift-install-linux-${OPENSHIFT_INSTALLER_VERSION}.tar.gz"
ARG OPENSHIFT_CLIENT_VERSION="4.1.18"
ARG OPENSHIFT_CLIENT_URL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_CLIENT_VERSION}/openshift-client-linux-${OPENSHIFT_CLIENT_VERSION}.tar.gz"

RUN \
set -eux; \
dnf update -y && \
\
dnf install -y \
bind-utils \
curl \
iputils \
nc \
nmap \
python3-pip \
tcpdump \
unzip \
wget \
jq \
which \
&& \
dnf clean all

RUN \
cd /tmp; \
curl -Os ${TERRAFORM_URL} && \
unzip -d /usr/local/bin terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
\
curl -s ${OPENSHIFT_INSTALLER_URL} | tar -zxvf - -C /usr/local/bin/ && \
\
curl -s ${OPENSHIFT_CLIENT_URL} | tar -zxvf - -C /usr/local/bin/

RUN \
echo -e 'awscli\nansible==2.8.*' >> /tmp/requirements.txt && \
pip3 install --no-cache-dir -q -r /tmp/requirements.txt && \
rm -rf /tmp/requirements.txt

# Download jsonnet
RUN wget https://github.com/google/jsonnet/releases/download/v0.15.0/jsonnet-bin-v0.15.0-linux.tar.gz
# Unzip
RUN tar -xzf jsonnet-bin-v0.15.0-linux.tar.gz
# Move to local bin
RUN mv jsonnet /usr/local/bin/
# Check that it's installed
RUN jsonnet --version

RUN echo =================================================================WORK=================================================================

RUN yum install -y openssh-server git lsof java-1.8.0-openjdk-headless && yum clean all

RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd \
    && mkdir -p /var/run/sshd \
    && useradd jenkins \
    && echo jenkins:jenkins | chpasswd \
    && mkdir /home/jenkins/.ssh && \
    chmod 700 /home/jenkins/.ssh && \
    rm /run/nologin
#COPY jenkins.pub /home/jenkins/.ssh/authorized_keys
RUN chown jenkins:jenkins -R /home/jenkins/.ssh
#    chmod 600 /home/jenkins/.ssh/authorized_keys
RUN /usr/bin/ssh-keygen -A && \
    echo export JAVA_HOME="/`alternatives  --display java | grep best | cut -d "/" -f 2-6`" >> /etc/environment

# Set java environment
ENV JAVA_HOME /etc/alternatives/jre

# Standard SSH port
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

