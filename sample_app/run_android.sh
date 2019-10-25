#!/usr/bin/env bash

while getopts ":c" opt; do
  case ${opt} in
    c ) # Clean node modules and install
        rm -rf node_modules/
        npm install
      ;;
    \? ) echo "Usage: cmd [-c]"
      ;;
  esac
done

react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res

react-native run-android
