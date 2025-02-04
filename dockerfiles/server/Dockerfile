FROM ubuntu:22.04

ENV USER=puppetuser
ENV USER_HOME=/home/${USER}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Prague

RUN groupadd --gid 1000 ${USER} \
    && useradd --uid 1000 --create-home --home-dir ${USER_HOME} -s /bin/bash -g ${USER} ${USER} \
    && chown -R ${USER}:${USER} ${USER_HOME}

RUN apt update && apt install -y --no-install-recommends \
	wget \
	curl \
	ca-certificates \
# Install debug tools
	dnsutils bind9-utils nmap openssl \
# Install `sponge` and `envsubst`
	moreutils gettext \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && wget https://apt.puppet.com/puppet8-release-jammy.deb \
    && dpkg -i /tmp/puppet8-release-jammy.deb \
    && apt update \
    && apt install -y puppetserver \
    && rm /tmp/puppet8-release-jammy.deb

COPY production /etc/puppetlabs/code/environments/production

RUN chown -R puppet:puppet /etc/puppetlabs \
    /var/log/puppetlabs \
    /opt/puppetlabs

RUN mkdir -p /opt/puppet-scripts/bin/
COPY puppet-cert-saver.sh /opt/puppet-scripts/bin/puppet-cert-saver
RUN chown -R puppet:puppet /opt/puppet-scripts

ENV PATH="/opt/puppetlabs/bin:/opt/puppet-scripts/bin:${PATH}"

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
	&& install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

COPY puppet.conf /etc/puppetlabs/puppet/
COPY puppetdb.conf /etc/puppetlabs/puppet/

USER puppet

ENTRYPOINT ["/docker-entrypoint.sh"]
