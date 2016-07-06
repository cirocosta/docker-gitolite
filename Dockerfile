# Gitolite server
# Forked from Beta CZ repository @ https://github.com/hlj/docker-gitolite
# Previously: MAINTAINER Beta CZ <hlj8080@gmail.com>

FROM ubuntu
MAINTAINER Ciro S. Costa <ciro.costa@liferay.com>

RUN set -x  && \
    apt-get update                                              &&  \
    apt-get install -y git perl openssh-server                  &&  \
    useradd git -m                                              &&  \

    su - git -c 'git clone git://github.com/sitaramc/gitolite'  &&  \
    su - git -c 'mkdir -p $HOME/bin                             &&  \
    gitolite/install -to $HOME/bin'

RUN set -x && \
# setup with built-in ssh key
    ssh-keygen -f admin -t rsa -N ''                                          &&  \
    su - git -c '$HOME/bin/gitolite setup -pk /admin.pub'                     &&  \
    sed  -i 's/AcceptEnv/# \0/' /etc/ssh/sshd_config                          &&  \

# fix fatal: protocol error: bad line length character: Welc
    sed -i 's/session\s\+required\s\+pam_loginuid.so/# \0/' /etc/pam.d/sshd   &&  \
    mkdir /var/run/sshd                  

ADD start.sh /start.sh
RUN chmod a+x /start.sh

EXPOSE 22
CMD [ "/start.sh" ]
