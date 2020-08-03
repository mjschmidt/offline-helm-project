### Minio Helm Addon Script ###

## This script is to run following completion of the all_gather_plus_pics.sh from the offline helm project in Github
## It takes the list created of helm charts and containers associated and updates them with the Serverless Minio bucket

# create date variable
d=`date +%Y-%m-%d-%H-%M`

# move new container list to tmp folder
mv ~/closed-env-container-images.txt /tmp/full-list

# copy yesterdays image list from minio
mc cp minio/helmcharts/closed-env-container-images.txt ~/

# rename yesterdays image list
mv ~/closed-env-container-images.txt ~/yester-list

# append todays list to yesterdays list
cat /tmp/full-list >> ~/yester-list

# copy old list from minio temp
mc mv minio/helmcharts/temp/temp-old.txt ~/

# append old list to yesterdays list
cat ~/temp-old.txt >> ~/yester-list

# move new full list to mino temp folder
mc mv /tmp/full-list minio/helmcharts/temp/temp-old.txt

# sort out new unique list and rename back to original
cat ~/yester-list | sort | uniq -u > ~/closed-env-container-images.txt

# rename and move yesterdays list in minio to old_container_lists bucket
mc mv minio/helmcharts/closed-env-container-images.txt minio/helmcharts/old_container_lists/closed-evn-container-images-$d

# move new unique list back to minio
mc cp ~/closed-env-container-images.txt minio/helmcharts

# move old helm-charts.tar to old_charts bucket
mc mv minio/helmcharts/helm-charts.tar minio/helmcharts/old_charts/helm-charts-$d.tar

# move new helm-charts.tar
mc cp ~/helm-charts.tar minio/helmcharts

# remove any charts older than 7 days
mc rm --recursive --force --older-than 7d minio/helmcharts/old_charts/

# remove any container lists older than 30 days
mc rm --recursive --force --older-than 30d minio/helmcharts/old_container_lists/

# cleanup
rm -rf ~/helm-charts.tar ~/closed-env-container-images.txt ~/temp-old.txt ~/yester-list

echo happy dance
