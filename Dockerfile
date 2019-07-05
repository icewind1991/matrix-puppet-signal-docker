FROM node:12-alpine

RUN apk add --no-cache git python make gcc g++
RUN git clone https://github.com/matrix-hacks/matrix-puppet-signal.git
RUN cd /matrix-puppet-signal && \
    npm install && \
    cd node_modules && \
    rm -rf signal-desktop && \
    git clone "https://github.com/signalapp/signal-desktop.git" && \
    cd signal-desktop && \
    git checkout v0.39.0

RUN mkdir /conf /data && \
    ln -s /conf/config.json /matrix-puppet-signal/config.json && \
    ln -s /conf/signal-registration.yaml /matrix-puppet-signal/signal-registration.yaml && \
    ln -s /data/D_signal.sqlite /matrix-puppet-signal/D_signal.sqlite && \
    ln -s /data/__sysdb__.sqlite /matrix-puppet-signal/__sysdb__.sqlite && \
    ln -s /data /matrix-puppet-signal/data

ADD entry.sh /

ENTRYPOINT ["/bin/sh", "/entry.sh"]
