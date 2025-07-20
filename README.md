# MBR-game

## Overview
A classic ping pong game. A 2-player game. 
The first player controls the first platform using the "W" and "S" keys. 
The second player controls the second platform using the up and down keys. 
The game ends (does not freeze) if the ball goes out of bounds.

## Dependencies

```bash
sudo apt install make nasm qemu-system-x86 -y
```

## Build
From the root of the repository, run following commands:

```bash
make build
```

## Run

```bash
make run
```