#!/bin/bash

# compile a "release" build
# ./build_release

# transfer the game assets to the server games storage
# scp -r bin/* epaths01.endlesspaths.com:/var/www/onemorepoint.com/web/data/games/aeroblox/
cd bin/
zip -r ../package.zip ./*
cd ../
mv package.zip /tmp/
# scp package.zip epaths01.endlesspaths.com:/tmp/
echo "Telling server to deploy:"
curl -d package=package.zip http://pplante:als85buk@onemorepoint.local/api/game/aeroblox/deploy/
echo ""
