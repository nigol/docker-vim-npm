FROM phusion/baseimage:0.9.22                                                                      
MAINTAINER Martin Polak

ENV HOME /root

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen cs_CZ.UTF-8
ENV LANG cs_CZ.UTF-8

RUN (apt-get update && \
     DEBIAN_FRONTEND=noninteractive \
     apt-get install -y build-essential software-properties-common \
                        zlib1g-dev libssl-dev libreadline-dev libyaml-dev \
                        libxml2-dev libxslt-dev sqlite3 libsqlite3-dev \
                        vim git byobu wget curl unzip tree exuberant-ctags \
                        build-essential cmake python python-dev gdb)

RUN (curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
    apt-get install -y nodejs)

RUN (apt-get install -y npm)

RUN (apt-get install vim)

# Add a non-root user
RUN (useradd -m -d /home/docker -s /bin/bash docker && \
     echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers)

USER docker
ENV HOME /home/docker
WORKDIR /home/docker

RUN (git config --global user.email "nigol@nigol.cz" && \
  git config --global user.name "Martin Polak")
  
# Vim configuration
RUN (mkdir /home/docker/.vim && mkdir /home/docker/.vim/bundle && \
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    git clone https://github.com/nigol/vimrc && \
    cp vimrc/vimrc .vimrc && \
    cd /home/docker/.vim/bundle && \
    git clone https://github.com/tpope/vim-fugitive.git && \
    git clone https://github.com/airblade/vim-gitgutter && \
    git clone https://github.com/ctrlpvim/ctrlp.vim.git)

# Prepare SSH key file
RUN (mkdir /home/docker/.ssh && \
    touch /home/docker/.ssh/id_rsa && \
    chmod 600 /home/docker/.ssh/id_rsa)

USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN (npm install -g create-react-app)

CMD [“/bin/sh”]