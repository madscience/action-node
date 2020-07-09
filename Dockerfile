FROM node:12.18-buster

# Install some system utilities
# note: man directory is missing in some base images
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN apt-get update \
  && mkdir -p /usr/share/man/man1 \
  && apt-get install -y \
    git apt locales sudo curl python3-pip colordiff

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Use unicode
RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8

# Install sentry-cli
RUN sudo npm install -g @sentry/cli --unsafe-perm

# Install dotenv-cli
RUN sudo npm install -g dotenv-cli --unsafe-perm

# Install cfn-lint
RUN pip3 install cfn-lint

# Install tf-helper
RUN curl -SL https://github.com/hashicorp-community/tf-helper/archive/0.2.8.tar.gz | tar -xzC ~/ \
    && sudo ln -s ~/tf-helper-0.2.8/tfh/bin/tfh /usr/bin/tfh

# Install aws-cli
RUN pip3 install awscli

CMD ["/bin/sh"]
