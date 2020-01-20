# Offline-Helm-Project
Perfect for pulling together all the Dependencies needed to port to an offline env
This is and always will be a Free and Open Source Project

### Pre Reqs
* git
* helm
* gsutil

### How to install helm 3 on your machine
```
#helm is not included in this git project
sudo cp tools/helm /usr/bin/
```

### Install and login to Google Cloud to use gsutil
```
#install gsutil
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
#use helmprojectoffline@gmail.com as the login account
```

### Script Usage
First get your helm Charts and List of Associated Docker Containers and the Pictures associated with the charts using this script
```
./all_gather_plus_pics.sh
```
