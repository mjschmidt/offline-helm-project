for f in `cat ~/closed-env-container-images.txt`;
do

docker pull $f
docker rmi $f

#if [[ $(docker images | grep $f) = $f ]]
#then
#docker rmi $f
#else
#
#fi

done
