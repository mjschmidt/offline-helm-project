#/bin/bash

pathtocharts=$(pwd)'/charts/'
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
rm -rf /tmp/helm-charts-stable
rm -rf /tmp/helm-charts-incubator
mkdir /tmp/helm-charts-stable
mkdir /tmp/helm-charts-incubator

#Loop through stable 
for f in `cat stable.charts.txt`;
do 
echo
echo
echo helm fatching
helm fetch  --untar --untardir /tmp stable/$f 
helm fetch  -d /tmp/helm-charts-stable stable/$f
echo
echo
echo writing out template
mkdir /tmp/$f-final
helm template --output-dir /tmp/$f-final /tmp/$f
grep -hR image: /tmp/$f-final >>./imagelist.txt
rm -rf /tmp/$f-final
rm -rf /tmp/$f
done


#Loop through incubator
for f in `cat incubator.charts.txt`;
do
helm fetch  --untar --untardir /tmp incubator/$f
helm fetch  -d /tmp/helm-charts-incubator incubator/$f
mkdir /tmp/$f-final
helm template --output-dir /tmp/$f-final /tmp/$f
grep -hR image: /tmp/$f-final >>./imagelist.txt
rm -rf /tmp/$f-final
rm -rf /tmp/$f
done

#Clean up container list
cat imagelist.txt |sed 's/^.*\(image.*\).*$/\1/' |sed 's/image://' |sed 's/\"//g' |grep -v "'" |sort |uniq  >~/closed-env-container-images.txt
rm imagelist.txt

#tar stable and incubator charts
cd /tmp
#gsutil -m cp -R gs://kubernetes-charts .
#gsutil -m cp -R gs://kubernetes-charts-incubator .
tar -cf ~/helm-charts.tar.gz helm-charts-stable helm-charts-incubator kubernetes-charts-incubator kubernetes-charts
rm -rf kubernetes-charts-incubator kubernetes-charts 

echo
echo
echo
echo You charts are now in ~/helm-charts.tar.gz and ready to be moved to offline env
echo The list of associated Docker images can be found in ~/closed-env-container-images.txt
echo Reccomend you cat ~/closed-env-container-images.txt to list the image list on the screen for easy copy paste
echo
echo Next steps
echo For pictures simply run the get pictures script


cd $pathtocharts
cd ../
rm -rf ./charts
rm stable.charts.txt incubator.charts.txt
