# Offline-Helm-Project
Perfect for pulling together all the Dependencies needed to port to an offline env
This is and always will be a Free and Open Source Project

### Pre Reqs
* git
* helm
```
#curl down helm binary and move it to bin
curl -o helm-v2.14.3-linux-amd64.tar.gz https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz
tar -zxvf helm-v2.14.3-linux-amd64.tar.gz
chmod +x linux-amd64/helm
sudo mv linux-amd64/helm /usr/local/bin/
helm init -c
rm helm-v2.14.3-linux-amd64.tar.gz
rm -rf linux-amd64/

#test install for clent
helm version --client

#expected output, server should not be working, just client. This is fine
#Client: &version.Version{SemVer:"v2.14.3", GitCommit:"0e7f3b6637f7af8fcfddb3d2941fcc7cbebb0085", GitTreeState:"clean"}
```
* For all_get.sh: gsutil
```
#install gsutil
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
#use helmprojectoffline@gmail.com as the login account
```

### Usage
First get your helm Charts and List of Associated Docker Containers using this script
```
./gather.sh
```

Grab the pictures using this script
```
./getpictures.sh
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

