FROM node:14.1.0-slim AS build

RUN apt-get -y update && \                                                                                                                                                                                                                                     
    apt-get -y install curl gnupg2 && \
    curl -Ss https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    apt-get -y install git python make gcc g++ apt-transport-https bzip2 libssl-dev && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt-get -y update && \
	apt-get -y install yarn
RUN git clone https://github.com/witchent/matrix-puppet-signal.git && \
    cd /matrix-puppet-signal && \                                                                                                                                                                                                                              
    git checkout 191be73
RUN cd /matrix-puppet-signal && \
    npm --unsafe-perm install
RUN cd /matrix-puppet-signal &&  \
    npm install -g rimraf && \
    npm install electron && \
    cd node_modules/signal-desktop && \
    yarn && \
    rm -r node_modules && \
    ln -s /matrix-puppet-signal/node_modules .

FROM node:14.1.0-slim
COPY --from=build /matrix-puppet-signal /matrix-puppet-signal

RUN apt-get -y update && \
    apt-get -y install libssl1.1 && \
    apt-get clean

RUN mkdir /conf /data && \
    ln -s /conf/config.json /matrix-puppet-signal/config.json && \
    ln -s /conf/signal-registration.yaml /matrix-puppet-signal/signal-registration.yaml && \
    ln -s /data/D_signal.sqlite /matrix-puppet-signal/D_signal.sqlite && \
    ln -s /data/__sysdb__.sqlite /matrix-puppet-signal/__sysdb__.sqlite && \
    ln -s /data /matrix-puppet-signal/data

ADD entry.sh /

ENTRYPOINT ["/bin/sh", "/entry.sh"]
