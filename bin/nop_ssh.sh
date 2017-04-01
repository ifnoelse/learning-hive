#!/usr/bin/env bash
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub>>~/.ssh/authorized_keys
for i in {2..3}
do
    ssh ifnoelse@node-0$i 'mkdir -p ~/.ssh'
    scp ~/.ssh/authorized_keys ifnoelse@node-02:~/.ssh
    ssh ifnoelse@node-0$i 'chmod 700 ~/.ssh;chmod 600 ~/.ssh/authorized_keys'
done