#!/bin/bash 

[[ -z $L1I_SIZE ]] && L1I_SIZE=32kB
[[ -z $L1I_ASSOC ]] && L1I_ASSOC=2
[[ -z $L1D_SIZE ]] && L1D_SIZE=64kB
[[ -z $L1D_ASSOC ]] && L1D_ASSOC=2
[[ -z $L2_SIZE ]] && L2_SIZE=2MB
[[ -z $L2_ASSOC ]] && L2_ASSOC=8
[[ -z $CACHELINE_SIZE ]] && CACHELINE_SIZE=64
[[ -z $CPU_CLOCK ]] && CPU_CLOCK=2GHz

case "$1" in
specbzip2)
PARAMS=(-c spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10")
;;
specmcf)
PARAMS=(-c spec_cpu2006/429.mcf/src/specmcf -o "spec_cpu2006/429.mcf/data/inp.in")
;;
spechmmer)
PARAMS=(-c spec_cpu2006/456.hmmer/src/spechmmer -o "--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 spec_cpu2006/456.hmmer/data/bombesin.hmm")
;;
specsjeng)
PARAMS=(-c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt")
;;
speclibm)
PARAMS=(-c spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of")
;;
esac

./build/ARM/gem5.opt -d "$1"_results/l1i-"$L1I_SIZE"-"$L1I_ASSOC"__l1d-"$L1D_SIZE"-"$L1D_ASSOC"__l2-"$L2_SIZE"-"$L2_ASSOC"__lines-"$CACHELINE_SIZE" configs/example/se.py --cpu-type=MinorCPU --caches --l2cache "${PARAMS[@]}" \
--l1i_size="$L1I_SIZE" --l1i_assoc="$L1I_ASSOC" --l1d_size="$L1D_SIZE" --l1d_assoc="$L1D_ASSOC" --l2_size="$L2_SIZE" --l2_assoc="$L2_ASSOC" --cacheline_size="$CACHELINE_SIZE" --cpu-clock="$CPU_CLOCK" -I 10000000

