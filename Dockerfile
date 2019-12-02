FROM node:10.13.0-slim AS build

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN apt-get -y update && \
	apt-get -y install git python make gcc g++ apt-transport-https bzip2 && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt-get -y update && \
	apt-get -y install yarn
RUN git clone https://github.com/matrix-hacks/matrix-puppet-signal.git
RUN cd /matrix-puppet-signal && \
    git pull && \
    git checkout fcdfb33bb590625033920a57c5aef7fd3fda57bd && \
    npm --unsafe-perm install && \
    npm install electron && \
    cd node_modules/signal-desktop && \
    yarn && \
    yarn grunt && \
    rm -r node_modules && \
    ln -s /matrix-puppet-signal/node_modules .

FROM node:10.13.0-slim
COPY --from=build /matrix-puppet-signal /matrix-puppet-signal

RUN mkdir /conf /data && \
    ln -s /conf/config.json /matrix-puppet-signal/config.json && \
    ln -s /conf/signal-registration.yaml /matrix-puppet-signal/signal-registration.yaml && \
    ln -s /data/D_signal.sqlite /matrix-puppet-signal/D_signal.sqlite && \
    ln -s /data/__sysdb__.sqlite /matrix-puppet-signal/__sysdb__.sqlite && \
    ln -s /data /matrix-puppet-signal/data

ADD entry.sh /

ENTRYPOINT ["/bin/sh", "/entry.sh"]
