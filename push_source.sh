#! /bin/bash

if [ "$1" == "github" ]
then
    git push github HEAD:source
elif [ "$1" == "gitcafe" ]
then
    git push gitcafe HEAD:source
else
    echo "dest wrong"
fi
