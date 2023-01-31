How to setup polygon network:

1. Run the setup script that creates the necessary folders for the volumes to work
    ```bash
    chmod +x ./setup.sh && ./setup-sh
    ```
2. Change some variables if needed in run.sh
3. Run the docker container

     ```bash
    docker-compose up
    ```

Ports:
<br>
1. 30303 - Bootnode network discovery port
2. 8545 - RPC port
3. 8546 - WS port
4. 26656 - Node discovery port(Discovers more nodes with this port opened)