#! /bin/bash

if [ "$1" == "github" ] || [ "$1" == "all" ]
then
    git push github HEAD:source
elif [ "$1" == "gitcafe" ] || [ "$1" == "all" ]
then
    git push gitcafe HEAD:source
else
    echo "dest wrong"
fi
