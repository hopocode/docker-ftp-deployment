#!/bin/sh
#
# get config file as arg
CONFIG_FILE=$1
#
# check if config file exists
FULL_PATH_CONFIG_FILE=$(pwd)/$CONFIG_FILE
if test -f "$FULL_PATH_CONFIG_FILE"; then
    ## file exists
    echo "Using config file $FULL_PATH_CONFIG_FILE"
else
    echo "Error: Config file $FULL_PATH_CONFIG_FILE does not exists."
    exit 0
fi
# Register kill function
trap "docker stop deploymachine" INT
# Start container from image, mount volumes and run deployment
docker run --rm --name deploymachine -v $(pwd):/var/www/html/data hopocode/ftp-deployment php /var/www/ftp-deployment/deployment /var/www/html/data/$CONFIG_FILE
echo "Deployment done"
