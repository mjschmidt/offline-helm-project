
pathtocharts='/home/'$USER'/charts'
stablecharts=$pathtocharts'/stable'
#incubatorcharts=$pathtochart'/$incubatorcharts'


#generate stable charts list
rm stable.charts.txt
ls -C $stablecharts | awk '{ print $1 }' > stable.charts.txt
ls -C $stablecharts | awk '{ print $2 }' >> stable.charts.txt
ls -C $stablecharts | awk '{ print $3 }' >> stable.charts.txt


#add invubator charts list
#rm incubator.charts.txt
#ls -C $incubatorcharts/ | awk '{ print $1 }' > incubator.charts.txt
#ls -C $incubatorcharts/ | awk '{ print $2 }' >> incubator.charts.txt
#ls -C $incubatorcharts/ | awk '{ print $3 }' >> incubator.charts.txt


for f in `cat stable.charts.txt`;
do
echo
echo
echo
echo
echo "helm template $stablecharts/$f | grep \"image:\""
helm template $stablecharts/$f | grep "image:"

done
