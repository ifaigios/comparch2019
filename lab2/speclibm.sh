#!/bin/bash 

[[ -z $L1I_SIZE ]] && L1I_SIZE=32kB
[[ -z $L1I_ASSOC ]] && L1I_ASSOC=2
[[ -z $L1D_SIZE ]] && L1D_SIZE=64kB
[[ -z $L1D_ASSOC ]] && L1D_ASSOC=2
[[ -z $L2_SIZE ]] && L2_SIZE=2MB
[[ -z $L2_ASSOC ]] && L2_ASSOC=8
[[ -z $CACHELINE_SIZE ]] && CACHELINE_SIZE=64
[[ -z $CPU_CLOCK ]] && CPU_CLOCK=2GHz

./build/ARM/gem5.opt -d speclibm_results/l1i-"$L1I_SIZE"-"$L1I_ASSOC"__l1d-"$L1D_SIZE"-"$L1D_ASSOC"__l2-"$L2_SIZE"-"$L2_ASSOC"__lines-"$CACHELINE_SIZE" configs/example/se.py --cpu-type=MinorCPU --caches --l2cache \
--l1i_size=$L1I_SIZE \
--l1i_assoc=$L1I_ASSOC \
--l1d_size=$L1D_SIZE \
--l1d_assoc=$L1D_ASSOC \
--l2_size=$L2_SIZE \
--l2_assoc=$L2_ASSOC \
--cacheline_size=$CACHELINE_SIZE \
--cpu-clock=$CPU_CLOCK \
-c spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of" -I 100000000
