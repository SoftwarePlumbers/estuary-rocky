#!/bin/bash

if [ -f ~/.settings ]
then
	source ~/.settings
else
	echo -n "Input git user:"
	read GIT_USER
	echo -n "Input git token:"
	read GIT_TOKEN

	echo "
		GIT_USER=${GIT_USER}
		GIT_TOKEN=${GIT_TOKEN}
	" >  ~/.settings

	chmod o-r ~/.settings
fi

docker build \
	-t fission-suite/estuary \
	--build-arg GIT_USER=${GIT_USER} \
	--build-arg GIT_TOKEN=${GIT_TOKEN} \
	.
