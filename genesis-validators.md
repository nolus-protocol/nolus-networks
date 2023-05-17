# Setting Up a Nolus Genesis Validator
​
Thank you for becoming a genesis validator on Nolus! This guide will
provide instructions on setting up a node, submitting a gentx, and other
tasks needed to participate in the launch of the Nolus Pirin mainnet.
​
The primary point of communication for the genesis process and future
updates will be the \#genesis-validators on the [Nolus Discord](https://discord.com/invite/nolus-protocol).
​
Some important notes on joining as a genesis validator:
​
1. **Please try to submit your gentxs by the End of Day UTC on May 19.**
2. To be a genesis validator, you must have NLS at genesis. Investors, advisors, participants in community-building incentivized campaigns will have some at genesis assigned to the addresses they have provided.
The rest of the submitted genesis validator addresses will receive a small amount of NLS tokens.
​
## Hardware
​
The recommended hardware to run a Nolus validating node is:
​
- 4+ physical CPUs
- 16+ GB RAM
- 240+ GB SSD
- At least 100 mbps network bandwidth
​
As the network grows, it might be necessary to adjust some of the components above.
​
## Instructions
​
These instructions are written targeting an Ubuntu 22.04 LTS system.
If you are using a different operating system, you might need to adjust the commands you will see.
​
### Install Go
​
Nolus is built using Go and requires Go version 1.19. In this
example, we will be installing Go on the above Ubuntu 22.04. You can skip this step if you have this already:
​
``` {.sh}
# Remove any existing Go installation if you are not on Go 1.19
sudo rm -rf /usr/local/go
​
# Download and Install the desired version of Go 
wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz
​
# Update environment variables to include go
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source $HOME/.profile
```
​
To verify that Go is installed:
​
``` {.sh}
go version
# Should return go version go1.19.4 linux/amd64
```
​
### Clone the Nolus Source Code
​
Use git to retrieve the Nolus source code from the [nolus-core](https://github.com/nolus-protocol/nolus-core) repository and checkout the
v0.3.0 tag which contains the latest stable release.
​
``` {.sh}
git clone https://github.com/nolus-protocol/nolus-core
cd nolus-core
git checkout v0.3.0
```
​
## Install nolusd
​
You can now build the Nolus daemon.
​
``` {.sh}
make install
```
​
### Verify Your Installation
​
Verify that you have nolusd (v0.3.0) correctly installed.
​
``` {.sh}
nolusd version --long
​
name: nolus
server_name: nolusd
version: 0.3.0
commit: c8946e0c7d0bb4d4f95f83fbeb37db150cf27127
build_tags: netgo ledger,
go: go version go1.19.4 linux/amd64
```
​
### Initialize your Node
​
Now that your software is installed, you can initialize your Nolus node.
​
``` {.sh}
nolusd init <your_moniker> --chain-id=pirin-1
```
​
This will create a new `.nolus` folder in your HOME directory.
​
### Add or recover key
​
You can add the application key which you'll use to sign the genesis transaction.
Adding is done via:
``` {.sh}
nolusd keys add <key-name>
```
You'd need to memorize and keep the mnemonic that gets generated safe!
​
​
Recovering an existing key is done via:
``` {.sh}
nolusd keys add <key-name> --recover
```
​
You can also import a key via Ledger. To do so, you can connect a Ledger
device with the Cosmos app open and then run:
​
``` {.sh}
nolusd keys add <key_name> --ledger
```
​
and follow any prompts.
​
### Add a genesis account with some NLS
​
Since you are using an empty generated genesis.json and not a pregenesis.json containing the balances, you'd need to add some tokens to the wallet such that the gentx does not fail:
​
``` {.sh}
nolusd add-genesis-account <wallet-address-of-the-imported-key-previously> 10000000unls
```
​
### Create GenTx
​
Now that you have you key imported, you are able to use it to create
your gentx.
​
To create the genesis transaction, make sure you adjust the necessary parameters for your validator such as moniker, self-stake, commission etc. 
​
Note that your gentx will be rejected if you use an amount different to what you would have at genesis for the self-stake.
​
If you would like to override the memo field, use the `--ip` and
`--node-id` flags.
​
An example genesis command would thus look like:
​
``` {.sh}
nolusd gentx <key-name> 1000000unls \
--chain-id pirin-1 \
--moniker="<moniker>" \
--identity="<keybaseio-id>"
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--details="XXXXXXXX" \
--security-contact="XXXXXXXX" \
--website="XXXXXXXX"
```
​
You can find your gentx-<node-id>.json under HOME/.nolus/config/gentx/:
​
​
### Submit Your GenTx
​
To submit your GenTx for inclusion in the chain, please upload it to the
[https://github.com/nolus-protocol/nolus-networks](https://github.com/nolus-protocol/nolus-networks)
repo by End of Day, May 19th.
​
To upload the your genesis file, please follow these steps:
​
1. Rename the gentx file just generated to gentx-{your-moniker}.json
    (please do not include any spaces or special characters in the file
    name)
2. Fork this repo by going to
    <https://github.com/nolus-protocol/nolus-networks>, clicking on fork, and
    choosing your account (if multiple).
3. Clone your copy of the fork to your local machine
​
``` {.sh}
git clone https://github.com/<your_github_username>/nolus-networks
```
​
4. Copy the gentx to the networks repo (ensure that it is in the
    correct folder)
​
``` {.sh}
cp ~/.nolus/config/gentx/gentx-<your-moniker>.json networks/mainnet/pirin-1/gentxs/
```
​
5. Commit and push to your repo.
​
``` {.sh}
cd nolus-networks
git add mainnet/pirin-1/gentxs/*
git commit -m "<your validator moniker> gentx"
git push origin master
```
​
6. Create a pull request from your fork to master on this repo.
7. Let us know on Discord (/#genesis-validators) when you've completed this process!
8. Stay tuned for next steps which will be shared after May the 19th.