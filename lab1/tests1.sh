#!/bin/bash

./build/ARM/gem5.opt configs/example/se.py --cpu-type=TimingSimpleCPU -c ~/Packages/comparch2019/myprog
cp -r m5out ~/Packages/comparch2019
mv ~/Packages/comparch2019/m5out ~/Packages/comparch2019/timingsimple

./build/ARM/gem5.opt configs/example/se.py --cpu-type=MinorCPU --caches -c ~/Packages/comparch2019/myprog
cp -r m5out ~/Packages/comparch2019
mv ~/Packages/comparch2019/m5out ~/Packages/comparch2019/minor

./build/ARM/gem5.opt configs/example/se.py --cpu-type=TimingSimpleCPU --mem-size=1MB -c ~/Packages/comparch2019/myprog
cp -r m5out ~/Packages/comparch2019
mv ~/Packages/comparch2019/m5out ~/Packages/comparch2019/timingsimple_1mb

./build/ARM/gem5.opt configs/example/se.py --cpu-type=MinorCPU --caches --mem-size=1MB -c ~/Packages/comparch2019/myprog
cp -r m5out ~/Packages/comparch2019
mv ~/Packages/comparch2019/m5out ~/Packages/comparch2019/minor_1mb

./build/ARM/gem5.opt configs/example/se.py --cpu-type=TimingSimpleCPU --cpu-clock=10MHz --sys-clock=10MHz -c ~/Packages/comparch2019/myprog
cp -r m5out ~/Packages/comparch2019
mv ~/Packages/comparch2019/m5out ~/Packages/comparch2019/timingsimple_10mhz

./build/ARM/gem5.opt configs/example/se.py --cpu-type=MinorCPU --caches --cpu-clock=10MHz --sys-clock=10MHz -c ~/Packages/comparch2019/myprog
cp -r m5out ~/Packages/comparch2019
mv ~/Packages/comparch2019/m5out ~/Packages/comparch2019/minor_10mhz
