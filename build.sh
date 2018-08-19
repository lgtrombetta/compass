#!/bin/bash

mkdir build
cd build

# build
cmake ..
make -j2

# create package
mkdir pa

cp manifest.json pa
cp app/compass.desktop pa
cp ../compass.apparmor pa

mkdir pa/lib
mkdir pa/share

cp -r ../app/graphics pa
rm pa/graphics/*.txt

mkdir pa/lib/arm-linux-gnueabihf/

cp -r backend/Compass pa/lib/arm-linux-gnueabihf/

mkdir pa/share/qml/
mkdir pa/share/qml/compass

cp ../app/Main.qml pa/share/qml/compass

cp -r pa/graphics pa/share/qml/compass

click build pa
