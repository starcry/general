apt update
apt upgrade -y
apt install -y python3 python3-pip wget vim git curl zip
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep UBUNTU_CODENAME /etc/os-release | sed 's/.*=//')-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt update
apt upgrade -y
apt install -yq postgresql-client-13 python3-psycopg2 dnsutils
pip3 install ansible boto3 yahoo-historical
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install
echo 'source <(curl -s https://raw.githubusercontent.com/starcry/general/master/bashrc)' >> /root/.bashrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

wget https://raw.githubusercontent.com/starcry/general/master/vimrc -O /root/.vimrc && \
  vim -c 'PlugInstall' -c 'qa!' && \
  /bin/bash
