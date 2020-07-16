#################################
###  Minio Helm Addon Script  ###
#################################

## This script is to run following completion of the all_gather_plus_pics.sh from the offline helm project in Github.
## It takes the list created of helm charts and containers associated and updates them with the Serverless Minio bucket

# create date variable
d=`date +%Y-%m-%d-%H-%M`

# copy old image list from minio
mc cp minio/helmcharts/closed-env-container-images.txt ~/

# rename old image list
mv ~/closed-env-container-images.txt ~/old-list

# append new list created to old list
cat ~/closedcontainerfiles/closed-env-container-images.txt >> ~/old-list

# sort list and rename old back to original name
cat ~/old-list | sort | uniq > ~/closed-env-container-images.txt

# move and rename old list in minio to old_container_lists bucket
mc mv minio/helmcharts/closed-env-container-images.txt minio/helmcharts/old_container_lists/closed-evn-container-images-$d

# move new unique list back to minio
mc cp ~/closed-env-container-images.txt minio/helmcharts

# move old helm-charts.tar to old_charts bucket
mc mv minio/helmcharts/helm-charts.tar minio/helmcharts/old_charts/helm-charts-$d.tar

# move new helm-charts.tar
mc cp ~/helm-charts.tar minio/helmcharts/

# remove any charts older than 5 days
mc rm --recursive --force --older-than 5d minio/helmcharts/old_charts/

# remove any lists older than 30 days
mc rm --recursive --force --older-than 30d minio/helmcharts/old_container_lists/

# cleanup
rm -rf ~/helm-charts.tar ~/closed-env-container-images.txt ~/closedcontainerfiles/ ~/old-list

echo happy dance
