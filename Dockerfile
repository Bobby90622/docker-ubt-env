FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive

# install ubuntu basic package
RUN apt-get update &&\
apt-get install --assume-yes apt-utils &&\
apt-get install -y zsh &&\
apt-get install -y wget &&\
apt-get install -y curl &&\
apt-get install -y libicu55 &&\
apt-get install -y libuv1 &&\
apt-get install -y build-essential &&\
apt-get install -y libtool &&\
apt-get install -y libpcre3 &&\
apt-get install -y libpcre3-dev &&\
apt-get install -y libssl-dev &&\
apt-get install -y zlib1g-dev &&\
apt-get install -y zip &&\
apt-get install -y unzip &&\
apt-get install -y daemon &&\
apt-get install -y git &&\
apt-get install -y openssh-server &&\
apt-get install -y openssl &&\
apt-get install -y vim &&\
apt-get install -y expect &&\
apt-get install -y sysvinit-utils &&\
apt-get install -y systemd &&\
apt-get install -y nginx

# install node relative package
RUN mkdir /node &&\
wget -P /node https://nodejs.org/dist/v8.13.0/node-v8.13.0-linux-x64.tar.xz &&\
tar -xvf /node/node-v8.13.0-linux-x64.tar.xz -C /node &&\
ln -s /node/node-v8.13.0-linux-x64/bin/node /usr/local/bin/node &&\
ln -s /node/node-v8.13.0-linux-x64/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm &&\
npm install cnpm -g --registry=https://registry.npm.taobao.org &&\
ln -s /node/node-v8.13.0-linux-x64/bin/cnpm /usr/local/bin/cnpm &&\
cnpm install nrm -g &&\
ln -s /node/node-v8.13.0-linux-x64/bin/nrm /usr/local/bin/nrm &&\
nrm add xnpm http://xnpm.ximalaya.com/ &&\
cnpm install n -g &&\
ln -s /node/node-v8.13.0-linux-x64/bin/n /usr/local/bin/n &&\
cnpm install yarn -g &&\
ln -s /node/node-v8.13.0-linux-x64/bin/yarn /usr/local/bin/yarn &&\
cnpm install pm2 -g &&\
ln -s /node/node-v8.13.0-linux-x64/bin/pm2 /usr/local/bin/pm2 &&\
cd / &&\
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&\
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &&\
chsh -s /bin/zsh &&\
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/' /root/.zshrc &&\
sed -i '$a plugins=(git incr)' /root/.zshrc &&\
mkdir /root/.oh-my-zsh/plugins/incr &&\
wget -P /root/.oh-my-zsh/plugins/incr http://mimosa-pudica.net/src/incr-0.2.zsh &&\
mkdir /v2ray && cd /v2ray && wget https://install.direct/go.sh &&\
zsh /v2ray/go.sh

# deploy ssh server
RUN echo 'root:screencast' | chpasswd &&\
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&\
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22

CMD ["zsh"]
