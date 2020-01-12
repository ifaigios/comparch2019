#!/bin/bash

echo "Benchmark	L1I_s	L1I_a	L1D_s	L1D_a	L2_s	L2_a	LINE_s	CPI	L1I_miss	L1D_miss	L2_miss	Power	Energy	Delay	Area	EDA" > eda-table.txt
for i in specbzip2_results/* spechmmer_results/* speclibm_results/* specmcf_results/* specsjeng_results/*
do
echo -n "Now running in $i ..."
./GEM5ToMcPAT.py -o "$i"/mcpat.xml "$i"/stats.txt "$i"/config.json ProcessorDescriptionFiles/inorder_arm.xml
./mcpat -infile "$i"/mcpat.xml -print_level 5 > "$i"/mcpat.out
cat "$i"/mcpat.out | sed 's/L2/L2:/g' > "$i"/mcpat.out.fixed
./print_eda.py "$i"/mcpat.out.fixed "$i"/stats.txt > "$i"/eda.txt
echo -n "$i" | sed 's/kB//g' | sed 's/MB//g' | sed 's/__lines//g' | sed 's/__/ /g' | sed 's/-/ /g' | sed 's/l1i //g' | sed 's/l1d //g'| sed 's/l2 //g'| sed 's/_results\// /g' | sed 's/ /\t/g' >> eda-table.txt
echo -n "	" >> eda-table.txt
cat "$i"/eda.txt >> eda-table.txt
echo "done"
done
