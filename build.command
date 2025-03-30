#!/bin/bash

set -e

cd "$(dirname "$0")"

WORKING_LOCATION="$(pwd)"
APPLICATION_NAME=RecruitmentService
rm -rf build
mkdir build

cd build

xcodebuild -workspace "$WORKING_LOCATION/$APPLICATION_NAME.xcworkspace" \
    -scheme "$APPLICATION_NAME" \
    -configuration Debug \
    -derivedDataPath "$WORKING_LOCATION/build/DerivedDataApp" \
    -destination 'generic/platform=iOS' \
    clean build \
    ONLY_ACTIVE_ARCH="NO" DWARF_DSYM_FOLDER_PATH="$WORKING_LOCATION/build" \
    CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO" \

DD_APP_PATH="$WORKING_LOCATION/build/DerivedDataApp/Build/Products/Debug-iphoneos/$APPLICATION_NAME.app"
TARGET_APP="$WORKING_LOCATION/build/$APPLICATION_NAME.app"
cp -r "$DD_APP_PATH" "$TARGET_APP"

codesign --remove "$TARGET_APP"
if [ -e "$TARGET_APP/_CodeSignature" ]; then
    rm -rf "$TARGET_APP/_CodeSignature"
fi
if [ -e "$TARGET_APP/embedded.mobileprovision" ]; then
    rm -rf "$TARGET_APP/embedded.mobileprovision"
fi

mkdir Payload
cp -r "$APPLICATION_NAME.app" "Payload/$APPLICATION_NAME.app"
zip -vr "$APPLICATION_NAME.ipa" Payload
rm -rf "$APPLICATION_NAME.app"
rm -rf DerivedDataApp
rm -rf Payload

open .
