#!/bin/bash

for i in specbzip2_results/* spechmmer_results/* speclibm_results/* specmcf_results/* specsjeng_results/*
do
#echo -n "Now running in $i ..."
#./GEM5ToMcPAT.py -o "$i"/mcpat.xml "$i"/stats.txt "$i"/config.json ProcessorDescriptionFiles/inorder_arm.xml
#./mcpat -infile "$i"/mcpat.xml -print_level 5 > "$i"/mcpat.out
#cat "$i"/mcpat.out | sed 's/L2/L2:/g' > "$i"/mcpat.out.fixed
#./print_eda.py "$i"/mcpat.out.fixed "$i"/stats.txt > "$i"/eda.txt
echo -n "$i" >> eda_table.txt
echo -n "	" >> eda_table.txt
cat "$i"/eda.txt >> eda_table.txt
#echo "done"
done
