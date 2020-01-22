#/bin/bash

#This script has a few for loops that are run multiple times that could probably be made into a function in the future where parameters are passed in a more resonable way. For now, this works... It takes about an hour to run bbecause helm pull is so slow. Google had a distributed pull tool that helped make those much faster, but bitnami charts are still VERY slow... we should explore some sort of distributed curl or wget tool in the future... I think there is a library written in Go we map eventually be able to use?

#Start your engines
start=`date +%s`

#set global variables
imagestoreurl=https://test.com
chartstoreurl=test.com
bucket=pics
pathtocharts=$(pwd)

#set helm chart stable variables
indexfilestable=/tmp/kubernetes-charts/index.yaml
stablecharts=$pathtocharts'/stable'

#set helm chart incubator variables
indexfileincubator=/tmp/kubernetes-charts-incubator/index.yaml
incubatorcharts=$pathtocharts'/incubator'

#set bitnami helm chart variables & since bitnami takes so long, in the future we'll only want to get the delta's so we want to keep track of the old list as well as the new list. For now, we don't do that, but setup for follow on work.
indexfilebitnami=/tmp/bitnami-charts/index.yaml
bitnamicharts=$pathtocharts'/bitnami-charts'
rm -rf $bitnamicharts'-old'
mv $bitnamicharts $bitnamicharts'-old'
mkdir $bitnamicharts




#move latest verison of helm to usr bin
sudo mv /usr/bin/helm /usr/bin/helm_old
sudo cp tool/helm /usr/bin/helm

#update help
helm repo update

#I think this stuff is old and can be deleted
#rm stable.charts.txt
#ls $stablecharts > stable.charts.txt


#add invubator charts list
#rm incubator.charts.txt
#ls  $incubatorcharts  > incubator.charts.txt
#End area of "I think this stuff is old and can be deleted


#This tool is much faster than helm for gathering all the stable and incubator helm charts. Helm pull takes forever. Its worth it and is easy to configure (see readme)
gsutil -m cp -R gs://kubernetes-charts .
gsutil -m cp -R gs://kubernetes-charts-incubator .
ls kubernetes-charts/ > all.stable.charts.txt
ls kubernetes-charts-incubator/ > all.incubator.charts.txt

#Loop through stable and template out all charts to be able to easily grab image and tags
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

#Loop through incubator and template out all charts to be able to easily grab image and tags
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


#bitnami charts gathering here
cd $bitnamicharts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

#This command finds every version of every helm chart and puts it into a file where we can actually do something with it
helm search repo bitnami --versions | cut -c -47 | grep -v NAME | awk '{$1=$1};1' | sed 's/ / --version /g' > fetch-bitnami.txt


#This loop goes through and pulls all the helm charts. It should be made faster in the future with some sort of distributed pull tool. 
#You can't just run helm pull as background processes because things break and not all charts are pulled.
cat fetch-bitnami.txt | while read line
do

echo helm pull $line
helm pull $line &
sleep .5

done
#curl down the bitnami index file
curl -o index.yaml -L https://charts.bitnami.com/bitnami/index.yaml

#Loop through stable and template out all charts to be able to easily grab image and tags

#get the list of all the charts for the same type of for loop as we do with stable and incubator
mv fetch-bitnami.txt ../
cd ../
echo $(pwd)
ls $bitnamicharts > bitnami.charts.txt

#Loop through bitnami and template out all charts to be able to easily grab image and tags
for f in `cat bitnami.charts.txt`;
do
echo
echo
echo
echo
echo writing out template /tmp/$f-final
mkdir /tmp/$f-final
helm template --output-dir /tmp/$f-final $bitnamicharts/$f
grep -hR image: /tmp/$f-final >>./imagelist.txt
rm -rf /tmp/$f-final
rm -rf /tmp/$f
done
rm bitnami.charts.txt

#end fetch bitnami charts


#Clean up container list
cat imagelist.txt |sed 's/^.*\(image.*\).*$/\1/' |sed 's/image://' |sed 's/\"//g' |grep -v "'" |sort |uniq  >~/closed-env-container-images.txt
rm imagelist.txt


#move chart files to tmp foler for processing

mv kubernetes-charts /tmp/
mv kubernetes-charts-incubator /tmp/
mv bitnami-charts /tmp/

#end moving fetched helm charts to /tmp/

#get the pics usint a serioes of for loops

cat /tmp/kubernetes-charts/index.yaml | grep icon | sed 's/    icon: //g' > iconlist; uniq iconlist output.txt; cat -n output.txt | sed 's/^.......//' > imagelist_stable.txt; rm output.txt iconlist
cat /tmp/kubernetes-charts-incubator/index.yaml | grep icon | sed 's/    icon: //g' >> iconlist; uniq iconlist output.txt; cat -n output.txt | sed 's/^.......//' > imagelist_incubator.txt; rm output.txt iconlist
cat /tmp/bitnami-charts/index.yaml | grep icon | sed 's/    icon: //g' >> iconlist; uniq iconlist output.txt; cat -n output.txt | sed 's/^.......//' > imagelist_bitnami.txt; rm output.txt iconlist
rm -rf /tmp/chartpics/
mkdir -p /tmp/chartpics/ 
for f in `cat imagelist_stable.txt`;
do
d=`echo $f |sed 's/https\:\/\///g' | sed 's/\//-/g'`
j=$(echo $f |  sed 's;/;\\/;g')
sed -i "/icon: $j/c\    icon: $imagestoreurl/$bucket/$d" $indexfilestable
echo go get image "### $(echo $f| sed 's|.*/||') ###";
curl -o /tmp/chartpics/$(echo $f | sed 's/https\:\/\///g' | sed 's/\//-/g') $f &
done

for f in `cat imagelist_incubator.txt`;
do
d=`echo $f |sed 's/https\:\/\///g' | sed 's/\//-/g'`
j=$(echo $f |  sed 's;/;\\/;g')
sed -i "/icon: $j/c\    icon: $imagestoreurl/$bucket/$d" $indexfileincubator
echo go get image "### $(echo $f| sed 's|.*/||') ###";
curl -o /tmp/chartpics/$(echo $f | sed 's/https\:\/\///g' | sed 's/\//-/g') $f
done


for f in `cat imagelist_bitnami.txt`;
do
d=`echo $f |sed 's/https\:\/\///g' | sed 's/\//-/g'`
j=$(echo $f |  sed 's;/;\\/;g')
sed -i "/icon: $j/c\    icon: $imagestoreurl/$bucket/$d" $indexfilebitnami
echo go get image "### $(echo $f| sed 's|.*/||') ###";
curl -o /tmp/chartpics/$(echo $f | sed 's/https\:\/\///g' | sed 's/\//-/g') $f
done

# end of the get the pictures section


#this section is for fixing the index files, right now I am not confident it does bitnami right but kubernetes and kubernetes incubator are correct

sed -i "s/kubernetes-charts.storage.googleapis.com/$chartstoreurl\/stable/g"  $indexfilestable
sed -i "s/kubernetes-charts-incubator.storage.googleapis.com/$chartstoreurl\/incubator/g"  $indexfileincubator
sed -i "s/charts.bitnami.com/$chartstoreurl/g" $indexfilebitnami
sed -i "s/bitnami.com/$chartstoreurl\/g" $indexfilebitnami

# end of indexfile fixting seciton

#create the tar file and clean up list files
cd /tmp
sed -i "s/charts.bitnami.com/$chartstoreurl/g" bitnami-charts/index.yaml
tar -cf ~/helm-charts.tar  kubernetes-charts-incubator kubernetes-charts chartpics bitnami-charts
rm -rf kubernetes-charts-incubator kubernetes-charts chartpics bitnami-charts

#end of clean up and tar creation

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
cd $pathtocharts
rm stable.charts.txt incubator.charts.txt imagelist_incubator.txt  imagelist_stable.txt fetch-bitnami.txt imagelist_bitnami.txt 

end=`date +%s`

runtime=$((end-start))
runtime_in_minutes=$(( $runtime / 60 ))
echo
echo
echo 'your run time was ' $runtime_in_minutes ' minutes!'

