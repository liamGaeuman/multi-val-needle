
reset session

set terminal postscript eps enhanced color
set output "boxplot.eps"
set datafile separator comma

file="results.txt"

filter(n,q,position) = sprintf("<(cat %s | awk -F, '$1 == %d && $2 == %d{print $0\",\"%d}')",file,n,q,position)
qlabels="1,2,3,4,5,"

set xlabel "n"
set ylabel "cycle mutation runtime"
set yrange [1:*]
set logscale y
set grid x mytics

set key noautotitle left top
set style fill solid 0.3

PosX = 4               # x-position of boxplot

plot for [n=5:15] for [q=2:5] PosX=PosX+1 filter(n,q,PosX) u 4:3 w boxplot lc q, \
     for [q=2:5] sprintf("< echo '%s'", qlabels) u (NaN):q w boxes lc q ti sprintf("q=%d",q), \
     for [n=5:15] file u ((n-1)*4-10):(NaN):xtic(sprintf("%d",n))



