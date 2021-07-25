FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt upgrade -y
RUN apt install -y python3 python3-pip wget vim git
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep UBUNTU_CODENAME /etc/os-release | sed 's/.*=//')-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt update
RUN apt upgrade -y
RUN apt install -yq postgresql-client-13 python3-psycopg2 dnsutils
RUN pip3 install ansible boto3 yahoo-historical
RUN echo 'source <(curl -s https://raw.githubusercontent.com/starcry/general/master/bashrc) >> /root/.bashrc'
