# helm-to-container
Getting containers for a closed environment in an ugly way

### Pre Reqs
```
cd
#clone helm charts
git clone https://github.com/helm/charts.git
#clone this repository
https://github.com/mjschmidt/helm-to-container.git
#curl down helm binary and move it to bin
curl -o helm-v2.14.3-linux-amd64.tar.gz https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz
tar -zxvf helm-v2.14.3-linux-amd64.tar.gz
chmod +x linux-amd64/helm
sudo mv linux-amd64/helm /usr/local/bin/

#test install for clent
helm version

#expected output, server should not be working, just client. This is fine
#Client: &version.Version{SemVer:"v2.14.3", GitCommit:"0e7f3b6637f7af8fcfddb3d2941fcc7cbebb0085", GitTreeState:"clean"}
#'no server error, but this is okay'
```

### Usage
```
cd ~/charts
git pull
cd ~/helm-to-container
git pull
### outputs a file to ~/closed-env-container-images.txt
./charts_image_list.sh
echo
echo
echo
echo
echo
#copy this list of containers image:tag and run any docker pull scripts to grab them all
cat https://github.com/mjschmidt/helm-to-container.git
```

#### Ignore this for now
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



