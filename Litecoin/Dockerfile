FROM debian:9

ENV RPC_USER=user
ENV RPC_PASS=pass
ENV RPC_PORT=9332
ENV RPC_ALLOW_IP=127.0.0.1
ENV TESTNET=0
ENV EXTRAFLAGS=""
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade && apt install -y wget
RUN wget https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz
RUN tar xzf litecoin-0.18.1-x86_64-linux-gnu.tar.gz
RUN install -m 0755 -o root -g root -t /usr/local/bin litecoin-0.18.1/bin/*

EXPOSE ${RPC_PORT}

ENTRYPOINT litecoind -rpcuser="$RPC_USER" \
    -rpcpassword="$RPC_PASS" \
    -rpcport="$RPC_PORT" \
    -rpcallowip="${RPC_ALLOW_IP}" \
    -rpcbind=0.0.0.0 \
    -listen \
    -server \
    -testnet=${TESTNET} \
    ${EXTRAFLAGS}
