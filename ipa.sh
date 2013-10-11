#!/bin/bash


cd `dirname $0`


SDK="iphoneos"
WORKSPACE_FILE_PATH="junkbox.xcworkspace"
TARGET_NAME="junkbox"
OUT_APP_DIR="ipa"
OUT_IPA_DIR="ipa"


if [ ! -d ${OUT_IPA_DIR} ]; then
    mkdir "${OUT_IPA_DIR}"
fi


CONFIGURATION=("debug" "release")
PRODUCT_NAME=("debug.junkbox" "junkbox")
PROVISIONING_PATH=("${SRC_ROOT}/ipa/provisioning/debug.junkbox.mobileprovision" "${SRC_ROOT}/ipa/provisioning/junkbox.mobileprovision")


for i in `seq 0 1`
do

xcodebuild clean -workspace "${WORKSPACE_FILE_PATH}"
xcodebuild -workspace "${WORKSPACE_FILE_PATH}" -sdk "${SDK}" -scheme "${TARGET_NAME}" -configuration "${CONFIGURATION[i]}" install DSTROOT="${OUT_APP_DIR}"
xcrun -sdk "${SDK}" PackageApplication "${PWD}/${OUT_APP_DIR}/Applications/${PRODUCT_NAME[i]}.app" -o "${PWD}/${OUT_IPA_DIR}/${PRODUCT_NAME[i]}.ipa" -embed "${PROVISIONING_PATH[i]}"

done
