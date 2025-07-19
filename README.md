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

Switch active users:

```
sui client switch --address <alias>
```

Remove an account from the system:

```
sui client remove-address <alias>
```