#!/bin/bash

# compile a "release" build
./build_release

cd bin/
zip -r ../package.zip ./*
cd ../

# transfer the game assets to the server games storage
scp package.zip onemorepoint.com:/tmp/

# tell the server to pick up the package and deploy it.
echo "Telling server to deploy:"
curl -d package=package.zip http://apigamedeployer:jaSPuphUv6KuVefa8am7FEchaD9g8s6g@onemorepoint.local/api/game/meteor/deploy/
echo ""

rm package.zip