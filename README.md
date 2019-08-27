# helm-to-container
Getting containers for a closed environment in an ugly way

### Pre Reqs
1. helm/charts in your home dir

```
#clone down the complimentary repsistory or an empty one where where you wish to push charts to git
https://github.com/mjschmidt/low-to-high-chart-zips.git
#clone my repository
git clone https://github.com/mjschmidt/test-helm-repo.git
# cd in 
cd helm-repo/
#install gsutil
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init

#Don't forget to pull down changest first
 
# use gsutil to get all the kubernetes charts you may want.
gsutil -m cp -R gs://kubernetes-charts .
gsutil -m cp -R gs://kubernetes-charts-incubator .
```

### Usage
```
### outputs a file to ~/closed-env-container-images.txt
./charts_image_list.sh
```


