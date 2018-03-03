FROM ruby:2.5-slim-stretch

# Run as root
USER root

# Create Distelli user
RUN useradd -ms /bin/bash distelli

# Set /home/distelli as the working directory
WORKDIR /home/distelli

# Install patches and prerequisites.
# Note. You don't need git or mercurial.
RUN apt-get update -y \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends apt-transport-https build-essential ca-certificates checkinstall cmake curl dirmngr git gnupg2 libssl-dev pkg-config ruby-dev wget \
  && apt-get install -y --no-install-recommends openssh-client openssh-server sudo \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Update the .ssh/known_hosts file:
RUN ssh-keyscan -H github.com bitbucket.org >> /etc/ssh/ssh_known_hosts

# Install Distelli CLI to coordinate the build in the container
RUN curl -sSL https://www.distelli.com/download/client | sh

# Install gosu
ENV GOSU_VERSION 1.9
RUN curl -o /bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.9/gosu-$(dpkg --print-architecture)" \
  && chmod +x /bin/gosu

