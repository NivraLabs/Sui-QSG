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