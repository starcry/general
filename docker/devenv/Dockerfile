FROM ubuntu

RUN apt update
RUN apt upgrade -y
RUN apt install -y python3 python3-pip wget
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep UBUNTU_CODENAME /etc/os-release | sed 's/.*=//')-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt update
RUN apt upgrade -y
RUN apt install -y postgresql-client-13
RUN pip3 install ansible boto3
