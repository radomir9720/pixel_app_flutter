#!/usr/bin/env bash

rootMainDirectory="./lib/"
mainFilePrefix="main_"
mainFileSuffix=".dart"

if [ $# -lt 2 ] 
then echo "Not enough parameters. 
Two positional parameters are required:
1. Build type("apk", "appbundle", "ios")
2. Flavor("dev", "prod" or "stg")"
exit 1
fi

if [ "$1" != "apk" ] && [ "$1" != "appbundle" ] && [ "$1" != "ios" ]
then echo "Wrong \"build type\" parameter
Available build types:
1. \"apk\"
2. \"appbundle\"
3. \"ios\""
exit 2
fi

buildType=$1

if [ "$2" == "dev" ]; then flavor=development 
elif [ "$2" == "prod" ]; then flavor="production"
elif [ "$2" == "stg" ]; then flavor="staging"
else echo "Wrong \"flavor\" parameter
Available flavors:
1. \"dev\" for development
2. \"prod\" for production
3. \"stg\" for staging"
exit 3 
fi
mainPath="$rootMainDirectory$mainFilePrefix$flavor$mainFileSuffix"
echo "
building: $buildType
flavor: $flavor
path: $mainPath
"
flutter build $buildType --flavor $flavor -t $mainPath