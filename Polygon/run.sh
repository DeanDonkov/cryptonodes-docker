#!/bin/bash
HEIMDALL_ETH_RPC_URL="${HEIMDALL_ETH_RPC_URL:-http://localhost:-9545}"
HEIMDALL_BOR_RPC_URL="${HEIMDALL_BOR_RPC_URL:-http://bor0:-8545}"
HEIMDALL_SEEDS=${HEIMDALL_SEEDS:-f4f605d60b8ffaaf15240564e58a81103510631c@159.203.9.164:26656,4fb1bc820088764a564d4f66bba1963d47d82329@44.232.55.71:26656,2eadba4be3ce47ac8db0a3538cb923b57b41c927@35.199.4.13:26656,3b23b20017a6f348d329c102ddc0088f0a10a444@35.221.13.28:26656,25f5f65a09c56e9f1d2d90618aa70cd358aa68da@35.230.116.151:26656}

HEIMDALL_MAX_OPEN_CONNECTIONS="${HEIMDALL_MAX_OPEN_CONNECTIONS:-0}"
HEIMDALL_MAX_INBOUND_PEERS="${HEIMDALL_MAX_INBOUND_PEERS:-300}"
HEIMDALL_MAX_OUTBOUND_PEERS="${HEIMDALL_MAX_OUTBOUND_PEERS:-300}"

BOR_RPC_PORT="${RPC_PORT:-8545}"
BOR_WS_PORT="${WS_PORT:-8546}"
BOR_ADDRESS="${ADDRESS:-0.0.0.0}"
BOR_DISCOVERY_PORT="${PORT:-30303}"
BOR_SYNCMODE="${full}"
BOR_BOOTNODES="${BOR_BOOTNODES:-enode://0cb82b395094ee4a2915e9714894627de9ed8498fb881cec6db7c65e8b9a5bd7f2f25cc84e71e89d0947e51c76e85d0847de848c7782b13c0255247a6758178c@44.232.55.71:30303,enode://88116f4295f5a31538ae409e4d44ad40d22e44ee9342869e7d68bdec55b0f83c1530355ce8b41fbec0928a7d75a5745d528450d30aec92066ab6ba1ee351d710@159.203.9.164:30303}"
BOR_MODE="${BOR_MODE:-full}"
BOR_EXTRAFLAGS="${EXTRAFLAGS:-}"

LOGS_FOLDER="${LOGS_FOLDER:-/root/logs}"
HEIMDALL_HOME="${HEIMDALL_HOME:-/root/.heimdalld}"

#setup logging
mkdir ${LOGS_FOLDER} \
    && touch ${LOGS_FOLDER}/heimdalld.log \
    && touch ${LOGS_FOLDER}/rest-server.log \
    && touch ${LOGS_FOLDER}/bor.log

#setup heimdall configuration
sed -i "/seeds =/c\seeds = \"${HEIMDALL_SEEDS}\"" ${HEIMDALL_HOME}/config/config.toml \
    && sed -i "/bor_rpc_url/c\bor_rpc_url = \"${HEIMDALL_BOR_RPC_URL}\"" ${HEIMDALL_HOME}/config/config.toml \
    && sed -i "/eth_rpc_url/c\eth_rpc_url = \"${HEIMDALL_ETH_RPC_URL}\"" ${HEIMDALL_HOME}/config/config.toml \
    && sed -i "/^max_open_connections =/c\max_open_connections = \"${HEIMDALL_MAX_OPEN_CONNECTIONS}\"" ${HEIMDALL_HOME}/config/config.toml \
    && sed -i "/max_num_inbound_peers =/c\max_num_inbound_peers = \"${HEIMDALL_MAX_INBOUND_PEERS}\"" ${HEIMDALL_HOME}/config/config.toml \
    && sed -i "/max_num_outbound_peers =/c\max_num_outbound_peers = \"${HEIMDALL_MAX_OUTBOUND_PEERS}\"" ${HEIMDALL_HOME}/config/config.toml
#start heimdall, heimdall rest server with logs.

heimdalld start 2>&1 | tee /root/logs/heimdalld.log &
    heimdalld rest-server 2>&1 | tee /root/logs/rest-server.log &
    /blockbook -sync -blockchaincfg=/home/blockbook/build/blockchaincfg.json -debug=true -workers=${WORKERS:-1} -public=:${BLOCKBOOK_PORT:-9144} -logtostderr &
    #start bor server
    bor server -ipcdisable \
    -syncmode ${BOR_SYNCMODE} \
    -nat none \
    -txlookuplimit 0 \
    -cache 16000 \
    -port ${BOR_DISCOVERY_PORT} \
    -http \
    -http.addr ${BOR_ADDRESS} \
    -http.port=${BOR_RPC_PORT} \
    -http.vhosts '*' \
    -http.corsdomain '*' \
    -ws \
    -ws.addr ${BOR_ADDRESS} \
    -ws.port ${BOR_WS_PORT} \
    -ws.origins '*' \
    ${BOR_EXTRAFLAGS} 2>&1 | tee /root/logs/bor.log
