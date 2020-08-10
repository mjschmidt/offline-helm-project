#/bin/bash

#This script has a few for loops that are run multiple times that could probably be made into a function in the future where parameters are passed in a more resonable way. For now, this works... It takes about an hour to run bbecause helm pull is so slow. Google had a distributed pull tool that helped make those much faster, but bitnami charts are still VERY slow... we should explore some sort of distributed curl or wget tool in the future... I think there is a library written in Go we map eventually be able to use?

#Start your engines
start=`date +%s`

cp $HOME/closed-env-container-images.txt-old $HOME/container-backup-lists/closed-env-container-images.txt-$(date +'%m-%d-%Y')
cp $HOME/closed-env-container-images.txt $HOME/closed-env-container-images.txt-old 
#import functions
source gatherallfunctions



#This sections calls each function

SETVERS
HELMUPDATE
GETKUBECHARTS
GETKUBECHARTDEPS
GETROOKCHARTS
GETROOKCHARTDEPS
GETRANCHERSTABLECHARTS
GETRANCHERSTABLECHARTDEPS
GETRANCHERLATESTCHARTS
GETRANCHERLATESTCHARTDEPS
GETBITNAMICHARTS
GETBITNAMICHARTDEPS
GETVMWARECHARTS
GETVMWARECHARTDEPS
CLEANUP
#the fixindexfiles function must be run before the chartpics function
FIXINDEXFILES
GETCHARTPICS
CREATETAR

#end functions
( cat $HOME/closed-env-container-images.txt $HOME/closed-env-container-images.txt-old ) | sort | uniq -c | awk '$1==1 {print $2}'


end=`date +%s`

runtime=$((end-start))
runtime_in_minutes=$(( $runtime / 60 ))
echo
echo
echo 'your run time was ' $runtime_in_minutes ' minutes!'

