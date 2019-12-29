#!/bin/bash

./run.sh $1
L1I_SIZE=64kB L1D_SIZE=128kB ./run.sh $1
L1I_SIZE=128kB L1D_SIZE=64kB ./run.sh $1
L1I_ASSOC=1 ./run.sh $1
L1D_ASSOC=1 ./run.sh $1
L1I_ASSOC=4 ./run.sh $1
L1D_ASSOC=4 ./run.sh $1
L2_ASSOC=4 ./run.sh $1
L2_ASSOC=16 ./run.sh $1
L2_SIZE=1MB ./run.sh $1
L2_SIZE=4MB ./run.sh $1
CACHELINE_SIZE=32 ./run.sh $1
CACHELINE_SIZE=128 ./run.sh $1

