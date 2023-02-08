FROM ubuntu:jammy
ENV DEBIAN_FRONTEND noninteractive
 
ENV pip_packages "ansible cryptography pywinrm kerberos requests_kerberos passlib msrest PyVmomi pymssql"
 
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        gcc \
        ca-certificates \
        curl \
        dnsutils \
        git \
        gnupg \
        gnupg2 \
        jq \
        krb5-user \
        krb5-config \
        libffi-dev \
        libkrb5-dev \
        libssl-dev \
        lsb-release \
        net-tools \
        openssh-client \
        python3-dev \
        python3-gssapi \
        python3-pip \
        python3-netaddr \
        python3-jmespath \
        python3-setuptools \
        python3-wheel \
        python3-pymssql \
        sshpass \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# Install Docker CE CLI
RUN curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && echo "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli

# Install Docker Compose
RUN LATEST_COMPOSE_VERSION=$(curl -sSL "https://api.github.com/repos/docker/compose/releases/latest" | grep -o -P '(?<="tag_name": ").+(?=")') \
    && curl -sSL "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose
 
RUN pip install --upgrade pip \
    && pip install $pip_packages
 
CMD    ["/bin/bash"]