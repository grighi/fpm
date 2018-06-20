
# x13as is the program used for detrending. It must be built from source.
# These are the commands that would be used once the program is available.
# Note that they must be run *after* running linux_build.sh

echo '' > out

for i in {1..6}; do
    cut -f$i measures.csv > tmp
    sed -i -e 's/NA//g' tmp
    x13as basic_spec -o seasadj
    sed '2d' seasadj.s12
    cut -f2 seasadj.s12 > tmp2
    paste out tmp2 > out2
    mv out2 out
    rm tmp tmp2
done
 
sed '2d' out > tmp
mv tmp out
rm seasadj*

Rscript plot.R


