FROM ubuntu:trusty-20150218.1

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
ADD etc/nginx-stable-trusty.list /etc/apt/sources.list.d/
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C

# ------------
# Ruby repo
# ------------
ADD etc/brightbox-ruby-ng-trusty.list /etc/apt/sources.list.d/
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6

# ----------
# Upgrade OS
# ----------
RUN apt-get -y update
RUN apt-get -y upgrade

# ------------------
# Install utilities
# -------------------
RUN apt-get install --yes --no-install-recommends rsync nano findutils procps mediainfo libav-tools zip curl wget language-pack-en sudo psmisc rsyslog runit nginx
RUN ln -s /usr/bin/avconv /usr/bin/ffmpeg

# -------------
# Install runit
# -------------
RUN mkdir -p /etc/runit/1.d

CMD ["/bin/bash"]

# ------------
# Install Ruby
# ------------
RUN apt-get install --yes --no-install-recommends ruby2.1 ruby2.1-dev
RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN echo ':sources:' >> ~/.gemrc
RUN echo '- http://rubygems.org' >> ~/.gemrc
RUN gem install bundler

# ------------------------
# Install build essentials
# ------------------------
RUN apt-get install --yes --no-install-recommends build-essential libyaml-dev libreadline-dev libxml2-dev libxslt1-dev libffi-dev libssl-dev pkg-config libxml2 libxml2-dev libxslt1.1 libxslt1-dev libmysqlclient-dev freetds-dev mysql-client-core-5.6 

# ------------------------
# Install node for execjs
# ------------------------
RUN apt-get install --yes --no-install-recommends nodejs
