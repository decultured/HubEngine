#!/bin/bash

# compile a "release" build
./build_release
# ./build

cd bin/
rm *.cache
zip -9 -r ../package.zip ./*
cd ../

# transfer the game assets to the server games storage
scp package.zip onemorepoint.com:/tmp/

# tell the server to pick up the package and deploy it.
echo "Telling server to deploy:"
curl -d package=package.zip http://apigamedeployer:jaSPuphUv6KuVefa8am7FEchaD9g8s6g@www.onemorepoint.com/api/game/aeroblox/deploy/
echo ""

rm package.zip