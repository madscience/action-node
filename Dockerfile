FROM node:12.18-buster

# make Apt non-interactive
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci \
  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci

ENV DEBIAN_FRONTEND=noninteractive

# Install some system utilities
# note: man directory is missing in some base images
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN apt-get update \
  && mkdir -p /usr/share/man/man1 \
  && apt-get install -y \
    git mercurial xvfb apt \
    locales sudo openssh-client ca-certificates tar gzip parallel \
    net-tools netcat unzip zip bzip2 gnupg curl wget make

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Use unicode
RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8

# Install sentry-cli
RUN sudo npm install -g @sentry/cli --unsafe-perm

# Install dotenv-cli
RUN sudo npm install -g dotenv-cli --unsafe-perm

# Install Python PIP
RUN sudo apt-get update && sudo apt-get install -y python3-pip

# Install cfn-lint
RUN pip3 install cfn-lint

# Install tf-helper
RUN curl -SL https://github.com/hashicorp-community/tf-helper/archive/0.2.8.tar.gz | tar -xzC ~/ \
    && sudo ln -s ~/tf-helper-0.2.8/tfh/bin/tfh /usr/bin/tfh

# Install aws-cli
RUN pip3 install awscli

# Install Colordiff
RUN sudo apt-get update && sudo apt-get install -y colordiff

CMD ["/bin/sh"]
