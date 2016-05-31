FROM ubuntu:xenial

MAINTAINER Gavin Stark "gstark@realdigitalmedia.com"

# --------------------------------------------------------
# Disable apt-cache as we won't need to reinstall anything
# --------------------------------------------------------
ADD etc/apt-no-cache /etc/apt/apt.conf.d/02nocache

# --------------------------------------------------------
# Setup dpkg exclusions/configuration
# --------------------------------------------------------
ADD etc/dpkg.cfg /etc/dpkg/dpkg.cfg.d/01_neocast

# --------------------------------------------------------
# Set debconf to non-interactive mode
# --------------------------------------------------------
RUN echo "debconf debconf/frontend select noninteractive" | debconf-set-selections

# ------------
# nginx repo
# ------------
ADD etc/nginx-mainline.list /etc/apt/sources.list.d/
ADD etc/nginx_signing.key /tmp/
RUN apt-key add /tmp/nginx_signing.key

# ----------
# Upgrade OS
# ----------
RUN apt-get -y update && \
    apt-get -y upgrade && \
    # ------------------
    # Install utilities
    # -------------------
    apt-get install --yes --no-install-recommends rsync nano findutils procps mediainfo ffmpeg zip curl wget language-pack-en sudo psmisc rsyslog runit nginx \
    # ------------------------
    # Install Ruby
    # ------------------------
    ruby ruby-dev \
    # ------------------------
    # Install build essentials
    # ------------------------
    build-essential libyaml-dev libreadline-dev libxml2-dev libxslt1-dev libffi-dev libssl-dev pkg-config libxml2 libxml2-dev libxslt1.1 libxslt1-dev libmysqlclient-dev freetds-dev mysql-client-core-5.7 \
    # ------------------------
    # Install node for execjs
    # ------------------------
    nodejs \
    # ------------------------
    # Install ca-certificates
    # ------------------------
    ca-certificates \
    # ------------------------
    # Install vim
    # ------------------------
    vim

# ---------------
# Configure runit
# ---------------
RUN mkdir -p /etc/runit/1.d

# --------------
# Configure Ruby
# --------------
RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN echo ':sources:' >> ~/.gemrc
RUN echo '- http://rubygems.org' >> ~/.gemrc
RUN gem install bundler

CMD ["/bin/bash"]
