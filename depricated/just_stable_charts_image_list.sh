#/bin/bash

pathtocharts='/home/'$USER'/charts'
stablecharts=$pathtocharts'/stable'
incubatorcharts=$pathtocharts'/incubator'


#generate stable charts list
rm stable.charts.txt
ls -C $stablecharts | awk '{ print $1 }' > stable.charts.txt
ls -C $stablecharts | awk '{ print $2 }' >> stable.charts.txt
ls -C $stablecharts | awk '{ print $3 }' >> stable.charts.txt


#add invubator charts list
rm incubator.charts.txt
ls -C $incubatorcharts | awk '{ print $1 }' > incubator.charts.txt
ls -C $incubatorcharts | awk '{ print $2 }' >> incubator.charts.txt
ls -C $incubatorcharts | awk '{ print $3 }' >> incubator.charts.txt

#walk stable charts list and get image list
rm image.list
rm image.notag.list
rm tag.noimage.list

for f in `cat stable.charts.txt`;
do 
#echo "####### $f ########";
#echo "####### $f ########" >> image.list
#echo "####### $f ########" >> image.notag.list
#echo "####### $f ########" >> tag.noimage.list
#get the image names from values file
#sleep .03
if [[  $f = "azuremonitor-containers" || $f = "vault-operator" || $f = "telegraf" || $f = "sumologic-fluentd" || $f = "sumokube" || $f = "stolon" || $f = "spinnaker" || $f = "sonatype-nexus" || $f = "signalfx-agent" || $f = "sentry" || $f = "satisfy" || $f = "rethinkdb" || $f = "reloader" || $f = "prometheus-mysql-exporter" || $f = "msoms" || $f = "mongodb-replicaset" || $f = "artifactory" || $f = "artifactory-ha" || $f = "mattermost-team-edition" || $f = "external-dns" || $f = "gitlab-ce" || $f = "gitlab-ee" || $f = "good" || $f = "influxdb" || $f = "ingressmonitorcontroller" || $f = "ipfs" || $f = "external-dns"  ]]
then
 echo "go get $f - is currently excluded due to bad values files ########";
else


#for manual debugging of chart to image match up
#echo "####### $f ########" >> image.list
#echo "####### $f ########" >> image.notag.list
#echo "####### $f ########" >> tag.noimage.list


echo "go get $f from stable helm"

grep -i "repository:\|image:\|Image:" $stablecharts/$f/values.yaml | grep -v "sampleEhcacheClient" |  grep -v "sysctlImage:" | grep -v "hyperkubeImage:" | grep -v "prometheusConfigReloader" | grep -v "configmapReloadImage:" |grep -v "mcImage:" | grep -v "waitImage:" | grep -v "AlwaysPullfalse:" | grep -v "downloadDashboards" | grep -v "chownDataImage:" | grep -v "gocd/gocd-" | grep -v "#" | grep -v "busyboxImage" | grep -v "initImage:" | sed -e "s/repository: //g" | sed -e 's/RequestCertsImage://g' | sed -e "s/image://g" | sed -e "s/repo: //g" | sed -e 's/Image://g' | sed -e "s/\"//g" | sed -e "s/ //g" | grep -v ":" >> image.notag.list

grep -i "tag:" $stablecharts/$f/values.yaml | grep -v "#" |  grep -v "imageTag: \"9.6.2\"" | grep -v "kubeTag:" | sed -e "s/ImageTag://g" |  sed -e "s/RequestCertsImageTag://g" | sed -e "s/host.*//g" | sed  -e "s/kubeTag:kube//g" | sed -e 's/testImageTag:master//g' | sed -e "s/tag://g" | sed -e "s/ //g" | sed -e "s/imageTag://g" | sed -e "s/\'//g" | sed -e "s/\"//g" >> tag.noimage.list
grep -i "initContainerImage: " $stablecharts/$f/values.yaml | grep -v "#" | sed -e "s/\"//g" | sed -e "s/initContainerImage://g" | sed -e "s/ //g" | grep -v ":" >> image.notag.list
grep -i "image:" $stablecharts/$f/values.yaml | grep -v "#" | sed -e "s/\"//g" | sed -e "s/image://g" | sed -e "s/ImageTag://g" | sed -e "s/RequestCertsImageTag://g" | sed -e "s/ //g" | grep ":"  >> image.list
fi
if [[ $f = "distribution" ]]
then
grep -i "tag:" $stablecharts/$f/values.yaml | grep -v "#" | sed -e "s/ImageTag://g" |  sed -e "s/RequestCertsImageTag://g" | sed -e "s/host.*//g" | sed  -e "s/kubeTag:kube//g" | sed -e 's/testImageTag:master//g' | sed -e "s/tag://g" | sed -e "s/ //g" | sed -e "s/imageTag://g" | sed -e "s/\'//g" | sed -e "s/\"//g" >> tag.noimage.list
fi
if [[ $f = "mission-control" ]]
then
grep -i "tag:" $stablecharts/$f/values.yaml | grep -v "3.6.3-0" | grep -v "#" | sed -e "s/ImageTag://g" |  sed -e "s/RequestCertsImageTag://g" | sed -e "s/host.*//g" | sed  -e "s/kubeTag:kube//g" | sed -e 's/testImageTag:master//g' | sed -e "s/tag://g" | sed -e "s/ //g" | sed -e "s/imageTag://g" | sed -e "s/\'//g" | sed -e "s/\"//g" >> tag.noimage.list
grep -i "tag:" $stablecharts/$f/values.yaml | grep -v "3.6.3-0" | grep -v "#" | sed -e "s/ImageTag://g" |  sed -e "s/RequestCertsImageTag://g" | sed -e "s/host.*//g" | sed  -e "s/kubeTag:kube//g" | sed -e 's/testImageTag:master//g' | sed -e "s/tag://g" | sed -e "s/ //g" | sed -e "s/imageTag://g" | sed -e "s/\'//g" | sed -e "s/\"//g" >> tag.noimage.list
grep -i "tag:" $stablecharts/$f/values.yaml | grep -v "3.6.3-0" | grep -v "#" | sed -e "s/ImageTag://g" |  sed -e "s/RequestCertsImageTag://g" | sed -e "s/host.*//g" | sed  -e "s/kubeTag:kube//g" | sed -e 's/testImageTag:master//g' | sed -e "s/tag://g" | sed -e "s/ //g" | sed -e "s/imageTag://g" | sed -e "s/\'//g" | sed -e "s/\"//g" >> tag.noimage.list

fi

if [[ $f = "spring-cloud-data-flow" ]]
then
grep -i "version:" $stablecharts/$f/values.yaml | grep "version:" | sed -e "s/host.*//g" | sed  -e "s/kubeTag:kube//g" | sed -e 's/testImageTag:master//g' | sed -e "s/tag://g" | sed -e "s/ //g" | sed -e "s/imageTag://g" | sed -e "s/\'//g" | sed -e "s/\"//g" >> tag.noimage.list
fi

if [[ $f = "xray" ]]
then
grep -i "tag:" $stablecharts/$f/values.yaml | grep -v "3.6.3-0" | grep -v "#" | sed -e "s/ImageTag://g" |  sed -e "s/RequestCertsImageTag://g" | sed -e "s/host.*//g" | sed  -e "s/kubeTag:kube//g" | sed -e 's/testImageTag:master//g' | sed -e "s/tag://g" | sed -e "s/ //g" | sed -e "s/imageTag://g" | sed -e "s/\'//g" | sed -e "s/\"//g" >> tag.noimage.list
grep -i "tag:" $stablecharts/$f/values.yaml | grep -v "3.6.3-0" | grep -v "#" | sed -e "s/ImageTag://g" |  sed -e "s/RequestCertsImageTag://g" | sed -e "s/host.*//g" | sed  -e "s/kubeTag:kube//g" | sed -e 's/testImageTag:master//g' | sed -e "s/tag://g" | sed -e "s/ //g" | sed -e "s/imageTag://g" | sed -e "s/\'//g" | sed -e "s/\"//g" >> tag.noimage.list
grep -i "tag:" $stablecharts/$f/values.yaml | grep -v "3.6.3-0" | grep -v "#" | sed -e "s/ImageTag://g" |  sed -e "s/RequestCertsImageTag://g" | sed -e "s/host.*//g" | sed  -e "s/kubeTag:kube//g" | sed -e 's/testImageTag:master//g' | sed -e "s/tag://g" | sed -e "s/ //g" | sed -e "s/imageTag://g" | sed -e "s/\'//g" | sed -e "s/\"//g" >> tag.noimage.list
fi



done

cp tag.noimage.list tag.noimage.list.presed
awk '! /[QWERTYUIOPPPPPPPPASDFGHJKLZXCVBNM]/ { print }' image.list > image
sed -i 's/\"//g' image.notag.list
sed -i '/^$/d' image.notag.list
sed -i 's/\"//g' tag.noimage.list
sed -i '/^$/d' tag.noimage.list
sed -i "s/####### artifactory ########//g" image.notag.list
sed -i "s/docker.bintray.io\/jfrog\/artifactory-pro//g" image.notag.list
sed -i "s/docker.bintray.io\/jfrog\/nginx-artifactory-pro//g" image.notag.list
sed -i "s/####### artifactory ########//g" tag.noimage.list
sed -i "s/####### artifactory-ha ########//g" tag.noimage.list
sed -i "s/####### artifactory-ha ########//g" image.notag.list
sed -i "s/####### external-dns ########//g" image.notag.list
sed -i "s/####### gitlab-ce ########//g" image.notag.list
sed -i "s/####### gitlab-ee ########//g" image.notag.list
sed -i "s/####### good ########//g" image.notag.list
sed -i "s/####### gitlab-ce ########//g" tag.noimage.list
sed -i "s/####### gitlab-ee ########//g" tag.noimage.list
sed -i "s/####### good ########//g" tag.noimage.list
sed -i "s/####### external-dns ########//g" image.notag.list
sed -i "s/####### ingressmonitorcontroller ########//g" image.notag.list
sed -i "s/####### influxdb ########//g" image.notag.list
sed -i "s/####### ipfs ########//g" image.notag.list
sed -i "s/AlwaysPullfalse//g" image.notag.list






sed -i 's/\"//g' image.notag.list
sed -i '/^$/d' image.notag.list
sed -i 's/\"//g' tag.noimage.list
sed -i '/^$/d' tag.noimage.list


cp image.notag.list file1
cp tag.noimage.list file2
paste file{1,2}| column -s $'\t' -t > joined
cp joined ~/closed-env-container-images.txt
sed -i "s/'//g" ~/closed-env-container-images.txt
sed -i 's/  */:/g' ~/closed-env-container-images.txt
echo container list is at file location ~/closed-env-container-images.txt

rm file1 file2 image image.list image.notag.list incubator.charts.txt stable.charts.txt tag.noimage.list tag.noimage.list.presed
#rm joined
#sed -i 's///g' image.notag.list
#sed -i 's///g' tag.noimage.list















