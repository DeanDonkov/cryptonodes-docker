FROM debian:9

ENV RPC_USER=user
ENV RPC_PASS=pass
ENV RPC_PORT=8332
ENV RPC_ALLOW_IP=127.0.0.1
ENV ZMQ_PORT=29000
ENV ZMQ_ADDRESS=localhost
ENV TESTNET=0
ENV EXTRAFLAGS=""
ENV DEBIAN_FRONTEND=noninteractive

ARG NODE_VERSION
ENV BITCOIN_VERSION ${NODE_VERSION}

RUN apt update && apt upgrade -y && apt install -y wget
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz
RUN tar xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz
RUN install -m 0755 -o root -g root -t /usr/local/bin bitcoin-${BITCOIN_VERSION}/bin/*

EXPOSE ${RPC_PORT}
EXPOSE ${ZMQ_PORT}

ENTRYPOINT bitcoind -rpcuser="$RPC_USER" \
    -rpcpassword="$RPC_PASS" \
    -rpcport="$RPC_PORT" \
    -rpcallowip="${RPC_ALLOW_IP}" \
    -rpcbind=0.0.0.0 \
    -listen \
    -server \
    -zmqpubhashblock="tcp://${ZMQADDRESS}:${ZMQ_PORT}" \
    -zmqpubhashtx="tcp://${ZMQADDRESS}:${ZMQ_PORT}" \
    -zmqpubrawblock="tcp://${ZMQADDRESS}:${ZMQ_PORT}" \
    -zmqpubrawtx="tcp://${ZMQADDRESS}:${ZMQ_PORT}" \
    -zmqpubsequence="tcp://${ZMQADDRESS}:${ZMQ_PORT}" \
    -testnet=${TESTNET} \
    ${EXTRAFLAGS}
