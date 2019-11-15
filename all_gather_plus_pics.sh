#/bin/bash
imagestoreurl=https://test.com
chartstoreurl=test.com
bucket=pics
indexfilestable=/tmp/kubernetes-charts/index.yaml
indexfileincubator=/tmp/kubernetes-charts-incubator/index.yaml
pathtocharts=$(pwd)'/charts'
stablecharts=$pathtocharts'/stable'
incubatorcharts=$pathtocharts'/incubator'

#clone helm charts to local folder
git clone https://github.com/helm/charts.git

#update help
helm repo update

#generate stable charts list
rm stable.charts.txt
ls $stablecharts > stable.charts.txt


#add invubator charts list
rm incubator.charts.txt
ls  $incubatorcharts  > incubator.charts.txt

#Make directorys for .tgz
gsutil -m cp -R gs://kubernetes-charts .
gsutil -m cp -R gs://kubernetes-charts-incubator .
ls kubernetes-charts/ > all.stable.charts.txt
ls kubernetes-charts-incubator/ > all.incubator.charts.txt

#Loop through stable 
for f in `cat all.stable.charts.txt`;
do 
echo
echo
echo
echo
echo writing out template
mkdir /tmp/$f-final
helm template --output-dir /tmp/$f-final kubernetes-charts/$f
grep -hR image: /tmp/$f-final >>./imagelist.txt
rm -rf /tmp/$f-final
rm -rf /tmp/$f
done
rm all.stable.charts.txt

#Loop through incubator
for f in `cat all.incubator.charts.txt`;
do
#helm fetch  --untar --untardir /tmp incubator/$f
#helm fetch  -d /tmp/helm-charts-incubator incubator/$f
mkdir /tmp/$f-final
helm template --output-dir /tmp/$f-final kubernetes-charts-incubator/$f
grep -hR image: /tmp/$f-final >>./imagelist.txt
rm -rf /tmp/$f-final
rm -rf /tmp/$f
done
rm all.incubator.charts.txt

#Clean up container list
cat imagelist.txt |sed 's/^.*\(image.*\).*$/\1/' |sed 's/image://' |sed 's/\"//g' |grep -v "'" |sort |uniq  >~/closed-env-container-images.txt
rm imagelist.txt

mv kubernetes-charts /tmp/
mv kubernetes-charts-incubator /tmp/
#tar stable and incubator charts
#gsutil -m cp -R gs://kubernetes-charts .
#gsutil -m cp -R gs://kubernetes-charts-incubator .

#get the pics

cat /tmp/kubernetes-charts/index.yaml | grep icon | sed 's/    icon: //g' > iconlist; uniq iconlist output.txt; cat -n output.txt | sed 's/^.......//' > imagelist_stable.txt; rm output.txt iconlist
cat /tmp/kubernetes-charts-incubator/index.yaml | grep icon | sed 's/    icon: //g' > iconlist; uniq iconlist output.txt; cat -n output.txt | sed 's/^.......//' > imagelist_incubator.txt; rm output.txt iconlist
rm -rf /tmp/chartpics/
mkdir -p /tmp/chartpics/ 
for f in `cat imagelist_stable.txt`;
do
d=`echo $f |sed 's/https\:\/\///g' | sed 's/\//-/g'`
j=$(echo $f |  sed 's;/;\\/;g')
sed -i "/icon: $j/c\    icon: $imagestoreurl/$bucket/$d" $indexfilestable
echo go get image "### $(echo $f| sed 's|.*/||') ###";
curl -o /tmp/chartpics/$(echo $f | sed 's/https\:\/\///g' | sed 's/\//-/g') $f
done

for f in `cat imagelist_incubator.txt`;
do
d=`echo $f |sed 's/https\:\/\///g' | sed 's/\//-/g'`
j=$(echo $f |  sed 's;/;\\/;g')
sed -i "/icon: $j/c\    icon: $imagestoreurl/$bucket/$d" $indexfileincubator
echo go get image "### $(echo $f| sed 's|.*/||') ###";
curl -o /tmp/chartpics/$(echo $f | sed 's/https\:\/\///g' | sed 's/\//-/g') $f
done
sed -i "s/kubernetes-charts.storage.googleapis.com/$chartstoreurl\/stable/g"  $indexfilestable
sed -i "s/kubernetes-charts-incubator.storage.googleapis.com/$chartstoreurl\/incubator/g"  $indexfileincubator

cd /tmp
tar -cf ~/helm-charts.tar  kubernetes-charts-incubator kubernetes-charts chartpics
rm -rf kubernetes-charts-incubator kubernetes-charts chartpics

echo
echo
echo
echo Your charts and pics are now in ~/helm-charts.tar and ready to be moved to offline env
echo The list of associated Docker images can be found in ~/closed-env-container-images.txt
echo Reccomend you cat ~/closed-env-container-images.txt to list the image list on the screen for easy copy paste
echo


cd $pathtocharts
cd ../
rm -rf ./charts
rm stable.charts.txt incubator.charts.txt imagelist_incubator.txt  imagelist_stable.txt
