FROM node:12.4.0
LABEL maintainer="nandor.stanko@gmail.com"

EXPOSE 4200 7020 7357
WORKDIR /ember-app

CMD ["ember", "server"]

RUN \ 
	apt-get update -y &&\
	apt-get install -y python-dev

RUN \
	cd /opt &&\
  git clone https://github.com/facebook/watchman.git &&\
	cd watchman &&\
	git checkout v4.9.0 &&\
	./autogen.sh &&\
	./configure &&\
	make &&\
	make install

RUN \
    apt-get update &&\
    apt-get install -y \
        apt-transport-https \
        gnupg \
        --no-install-recommends &&\
	curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - &&\
	echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list &&\
	apt-get update &&\
	apt-get install -y \
	    google-chrome-stable \
	    --no-install-recommends

# tweak chrome to run with --no-sandbox option
RUN \
	sed -i 's/"$@"/--no-sandbox "$@"/g' /opt/google/chrome/google-chrome

# set container bash prompt color to blue in order to 
# differentiate container terminal sessions from host 
# terminal sessions
RUN \
	echo 'PS1="\[\\e[0;94m\]${debian_chroot:+($debian_chroot)}\\u@\\h:\\w\\\\$\[\\e[m\] "' >> ~/.bashrc

RUN npm install -g yarn

RUN yarn global add ember-cli@3.13.1