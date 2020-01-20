#/bin/bash
start=`date +%s`
#Add helm repos here
pathtocharts=$(pwd)
bitnamicharts=$pathtocharts'/bitnami'

rm -rf $bitnamicharts'-old'
mv $bitnamicharts $bitnamicharts'-old'
mkdir $bitnamicharts

cd $bitnamicharts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm search repo bitnami --versions | cut -c -47 | grep -v NAME | awk '{$1=$1};1' | sed 's/ / --version /g' > fetch-bitnami.txt



cat fetch-bitnami.txt | while read line 
do

echo helm pull $line
helm pull $line &
sleep .5

done
curl -o index.yaml -L https://charts.bitnami.com/bitnami/index.yaml


mv fetch-bitnami.txt ../
cd ../
echo $(pwd)
ls $bitnamicharts > bitnami.charts.txt

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

cat imagelist.txt |sed 's/^.*\(image.*\).*$/\1/' |sed 's/image://' |sed 's/\"//g' |grep -v "'" |sort |uniq  >~/closed-env-container-images.txt
end=`date +%s`

runtime=$((end-start))
echo
echo
echo 'your run time was ' $runtime
