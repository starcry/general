FROM ubuntu
#FROM tensorflow/tensorflow

ENV DEBIAN_FRONTEND=noninteractive

RUN yes | unminimize
RUN apt update
RUN apt upgrade -y
RUN apt install -y python3 python3-pip wget vim git curl zip
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep UBUNTU_CODENAME /etc/os-release | sed 's/.*=//')-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt update
RUN apt upgrade -y
RUN apt install -yq postgresql-client-13 python3-psycopg2 dnsutils
RUN pip3 install ansible boto3 yahoo-historical
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
RUN unzip /tmp/awscliv2.zip -d /tmp
RUN /tmp/aws/install
RUN echo 'source <(curl -s https://raw.githubusercontent.com/starcry/general/master/bashrc)' >> /root/.bashrc
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#COPY setup.sh /root/setup.sh

CMD wget https://raw.githubusercontent.com/starcry/general/master/vimrc -O /root/.vimrc && \
  vim -c 'PlugInstall' -c 'qa!' && \
  /bin/bash

