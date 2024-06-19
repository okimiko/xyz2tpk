#!/bin/bash -x

[[ $BOUNDS ]] || BOUNDS=[-180,-90,180,90]
[[ $FORMAT ]] || FORMAT=png
[[ $URL ]] || URL=https://tile.openstreetmap.org/{z}/{x}/{y}.$FORMAT
[[ $MIN ]] || MIN=0
[[ $MAX ]] || MAX=10
[[ $FOLDER ]] || FOLDER=$PWD/export/
[[ $NAME ]] || NAME=world

if [ -f /.dockerenv ]
then
    export NODE_PATH=/opt/app/node_modules
    node -e "require('/opt/app/dist/xyz2tpk.js').xyz2tpk($BOUNDS, $MIN, $MAX, '$URL', '$FORMAT', '$FOLDER')"

    cd /opt/app/export
    zip ${NAME}_${MIN}-${MAX}_$(date +%Y-%m-%d).tpk -0 -r esriinfo servicedescriptions v101
else
    docker run -ti -v $FOLDER:/opt/app/export/ --rm -e BOUNDS=$BOUNDS -e FORMAT=$FORMAT -e URL=$ULR -e MIN=$MIN -e MAX=$MAX -e NAME=$NAME xyz2tpk:latest
fi
