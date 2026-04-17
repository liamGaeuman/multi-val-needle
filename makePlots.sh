#!/bin/bash
## n,q,t

function make_table_by_q {
    echo "n mean sd"
    cat $1 | sort -t',' -k1,2 -n | awk -F, -v q="$2" '$2 == q{print $0}' | datamash -t, groupby 1 mean 3 sstdev 3 --output-delimiter=' '
}

#make_table_by_q "results.txt" 2 > cycle-mutation-q2.dat
#make_table_by_q "results.txt" 3 > cycle-mutation-q3.dat
#make_table_by_q "results.txt" 4 > cycle-mutation-q4.dat
#make_table_by_q "results.txt" 5 > cycle-mutation-q5.dat

