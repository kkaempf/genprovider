#!/bin/sh
for i in $(seq 1 10); do
  wbemecn -noverify https://wsman:secret@localhost:5989/root/cimv2:RCP_SimpleClass
done
