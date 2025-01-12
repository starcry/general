FROM debian
#FROM tensorflow/tensorflow

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt upgrade -y
RUN apt install -y python3 python3-pip wget vim git curl zip python3-venv
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep UBUNTU_CODENAME /etc/os-release | sed 's/.*=//')-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
#RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
#RUN apt update
RUN apt upgrade -y
#RUN apt install -yq postgresql-client-13 python3-psycopg2 dnsutils
RUN apt install -yq python3-psycopg2 dnsutils ansible
#RUN pip3 install ansible boto3 yahoo-historical
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
RUN unzip /tmp/awscliv2.zip -d /tmp
RUN /tmp/aws/install
RUN echo 'source <(curl -s https://raw.githubusercontent.com/starcry/general/master/bashrc)' >> /root/.bashrc
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN python3 -m venv /root/venv

#COPY setup.sh /root/setup.sh

CMD wget https://raw.githubusercontent.com/starcry/general/master/vimrc -O /root/.vimrc && \
  vim +PluginInstall +qall && \
  echo " run this to activate the python virtual environment 'source $HOME/venv/bin/activate'" && \
  /bin/bash

