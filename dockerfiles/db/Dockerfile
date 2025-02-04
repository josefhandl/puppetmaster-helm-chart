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
	bind9-utils nmap openssl dnsutils postgresql \
# Install `sponge` and `envsubst`
	moreutils gettext \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && wget https://apt.puppet.com/puppet8-release-jammy.deb \
    && dpkg -i /tmp/puppet8-release-jammy.deb \
    && apt update \
    && apt install -y puppetdb \
    && rm /tmp/puppet8-release-jammy.deb

#RUN chown -R puppet:puppet /etc/puppetlabs \
#    /var/log/puppetlabs \
#    /opt/puppetlabs

ENV PATH="/opt/puppetlabs/bin:${PATH}"

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

COPY jetty.ini /etc/puppetlabs/puppetdb/conf.d/
COPY database.ini /etc/puppetlabs/puppetdb/conf.d/

#USER puppet

ENTRYPOINT ["/docker-entrypoint.sh"]
