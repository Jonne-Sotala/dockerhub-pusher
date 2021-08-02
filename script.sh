#!/bin/sh

helpFunction()
{
   echo ""
   echo "Usage: $0 -d project_link -n project_name"
   echo -e "\t-d Github HTTPS link"
   echo -e "\t-n Project name that is used when pushing to Docker Hub"
   exit 1 # Exit script after printing help
}

while getopts "d:n:" opt
do
   case "$opt" in
      d ) project_link="$OPTARG" ;;
      n ) project_name="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$project_link" ] || [ -z "$project_name" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
 
export LINK=$(echo $project_link | sed "s|https://|https://$(cat GITHUB_TOKEN):x-oauth-basic@|")
export HUB_USERNAME=$(cat HUB_USERNAME)
export HUB_PASS=$(cat HUB_PASS)

echo "Cloning Github repository"
git clone $LINK app
cd app

echo "Building docker image"
docker build -t $HUB_USERNAME/$project_name . 

echo "Login into Docker"
echo $HUB_PASS | docker login -u $HUB_USERNAME --password-stdin

echo "Pushing docker image to hub tagged as $HUB_USERNAME/$project_name"
docker push $HUB_USERNAME/$project_name

