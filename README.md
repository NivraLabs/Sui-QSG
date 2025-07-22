# Sui Developer Quickstart Guide

This guide will explain how to set up a sui development environment and best practices used at NivraLabs.

## Prerequisites

Before you start, you'll need:
* [Rust](https://www.rust-lang.org/learn/get-started)
* [VS Code](https://code.visualstudio.com/)

## Install Sui & MVR

Get the latest [suiup](https://github.com/MystenLabs/suiup), a tool for managing Sui and MVR (Move package registry) versions:

```
cargo install --git https://github.com/Mystenlabs/suiup.git --locked
```

Install Sui:

```
suiup install sui
```

Install MVR:

```
suiup install mvr
```

## Set Up VSCode
[vip]

## Managing Sui Accounts
To interact with the Sui blockchain, a Sui account is needed. 
<br><br>
Create a new account:

```
sui client new-address ed25519
```

**Store the recovery phrase for your account from the resulting output in a secure way.**
<br><br>
Import an existing account:

```
sui keytool import '<recovery phrase>' ed25519
```

View accounts on this system:

```
sui client addresses
```

Switch the active account:

```
sui client switch --address <alias>
```

Remove an account from the system:

```
sui client remove-address <alias>
```

## Connect to the Sui Network

Sui has 3 networks:
* **Mainnet** (production)
* **Testnet** (test products, only announced network wipes)
* **Devnet** (experimentation, regular network wipes)

Create the following network environments:

```
sui client new-env --alias=mainnet --rpc https://fullnode.mainnet.sui.io:443
```
```
sui client new-env --alias=testnet --rpc https://fullnode.testnet.sui.io:443
```
```
sui client new-env --alias=devnet --rpc https://fullnode.devnet.sui.io:443
```

List all the network environments:

```
sui client envs
```

Set current environment: 

```
sui client switch --env <alias>
```

## Managing Objects

If your current environment is testnet or devnet, you can use the faucet command
to request gas coins:

```
sui client faucet
```

View account balance:

```
sui client balance
```

View objects owned by the active account:

```
sui client objects
```

View objects owned by another account address:

```
sui client objects <address>
```

Get complete object information:

```
sui client object <object id>
```

## Creating & Publishing Packages

Create a new package:

```
sui move new <package name>
```

Build the package:

```
sui move build
```

Run unit tests:

```
sui move test
```

Publish the package:

```
sui client publish --gas-budget <amount>
```

Upgrade a package:
* Existing public function signatures must remain the same.
* Existing struct layouts (including struct abilities) must remain the same.
* Otherwise, you're free to change the package however you like.

```
sui client upgrade --upgrade-capability <UPGRADE-CAP-ID>
```

## Example

In this example, we're going to mint a new token, EME COIN, linearly vested over 24 hours.
<br>
To get started, clone this repository and open a terminal in the example folder.
<br><br>
Create a new account if you haven't already and set it active:

```
sui client new-address ed25519
```
```
sui client switch --address <alias>
```

Next, set the current environment to the devnet:

```
sui client new-env --alias=devnet --rpc https://fullnode.devnet.sui.io:443
```
```
sui client switch --env devnet
```

Request some gas coins to deploy the package:

```
sui client faucet
```

publish the package:

```
sui client publish --gas-budget 100000000
```

Go to 'Object Changes' section in the resulting output and copy the 'PackageID' to an environment variable:

```
export PACKAGE_ID=0x33533a484ff9959a5a44ddf17d43533f480728e5b0a3a83e484dbbc8b81708d7
```

We will also need the TreasuryCap's 'ObjectID':

```
export TREASURY_CAP_ID=0xddf7e699ec687c3b513741918c04565fb4cc2a6e0d6165b02eb47f2c57afcc47
```

Finally, create an variable for your accounts address:

```
export MY_ADDRESS = $(sui client active-address)
```

Call the package to mint the tokens:

```
sui client ptb \
--gas-budget 100000000 \
--move-call $PACKAGE_ID::eme_coin::mint @$TREASURY_CAP_ID @0x6 \
--assign wallet \
--transfer-objects "[wallet]" @$MY_ADDRESS
```

In object changes, we see a new wallet object. Save the 'ObjectID' for claiming our tokens:
```
export WALLET_ID=0xeff006461f6ad47f9496975118b0cc016fd8971afc4c87af4fdec8ff1ee65b5f
```

To claim some tokens, call:

```
sui client ptb \
--gas-budget 100000000 \
--move-call $PACKAGE_ID::eme_coin::claim @$WALLET_ID @0x6 \
--assign eme-coin \
--transfer-objects "[eme-coin]" @$MY_ADDRESS
```
You may repeat this call to get more coins over the 24 hours.<br>
To see your new balance:
```
sui client balance
```
congratulations, you've just created your own token! Next, try to customize its properties and send some tokens to your friends on the testnet. 