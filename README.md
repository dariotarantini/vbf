# vbf
A brainfuck interpreter/compiler written in V.
## Installation
### Linux, macOS, Windows, *BSD, WSL, Android, Raspbian
```
git clone https://github.com/vpervenditti/vbf
cd vbf
v -prod 
```

Okay, you need:  
    1. V compiler  
    2. Git  
    3. Curl  
On Ubuntu, you can easy install them using: `sudo apt install git curl -y`  
If you need V, install it here https://vlang.io  
To install vbf, just run: `curl https://raw.githubusercontent.com/vpervenditti/vbf/master/install.sh | sudo bash`
## Usage
```
vbf 0.5 - simple brainfuck interpreter/compiler
Usage: vbf [options] [file]

Options:
 - run		Run a brainfuck script
 - build	Generate a C program from brainfuck that can be compiled
 - help		Show this message
```
