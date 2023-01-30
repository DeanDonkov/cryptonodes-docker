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
ENV BITCOIN_REPOSITORY=https://bitcoincore.org/bin
ENV ARCHITECTURE=x86_64-linux-gnu.tar.gz

RUN apt update && apt -y upgrade && apt install -y wget

RUN export LATEST_RELEASE=$(curl https://api.github.com/repos/bitcoin/bitcoin/releases/latest |  python3 -c "import sys, json; print(json.load(sys.stdin)['tag_name'].replace('v', ''))")

RUN wget $BITCOIN_REPOSITORY/bitcoin-core-$LATEST_RELEASE/bitcoin-$LATEST_RELEASE-${ARCHITECTURE
RUN tar xzf bitcoin-24.0.1-x86_64-linux-gnu.tar.gz
RUN install -m 0755 -o root -g root -t /usr/local/bin bitcoin-24.0.1/bin/*

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
