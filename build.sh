#!/bin/bash

XCF_DIR=`pwd`
XCF_LIBS="$XCF_DIR/libs"
XCF_TMP="$XCF_DIR/tmp"
XCF_INCLUDE="$XCF_DIR/include"

BJJ_DIR="$XCF_DIR/../libbabyjubjub"
BJJ_TARGET="$BJJ_DIR/target"

CPOLY_DIR="$XCF_DIR/../c-polygonid"

set -e

mergeLibraries() {
  local target_lib="${XCF_LIBS}/$1"
  local libs=$2

  mkdir -p "$XCF_TMP"
  cd "$XCF_TMP"
  for lib in $libs; do 
    local lib_path="${XCF_LIBS}/$lib"
    ar -x $lib_path
  done
  ar -rsv "$target_lib" *.o
  rm -Rf "$XCF_TMP"
}

# echo "Cleaning..."

mkdir -p libs
rm -f libs/*.a
rm -rf *.xcframework
rm -f *.zip

echo "Building libbabyjubjub..."

cd "$BJJ_DIR"

make ios
make bindings

cp target/bindings.h $XCF_INCLUDE/babyjubjub.h

cp libs/libbabyjubjub-ios.a $XCF_LIBS/libbabyjubjub-ios.a
cp libs/libbabyjubjub-ios-sim.a $XCF_LIBS/libbabyjubjub-ios-sim.a
cp libs/libbabyjubjub-macos.a $XCF_LIBS/libbabyjubjub-macos.a

echo "Building c-polygon..."

cd "$CPOLY_DIR"

make ios-simulator
make ios
make darwin

cp ios/libpolygonid.h "$XCF_INCLUDE"
cp ios/libpolygonid-darwin.a $XCF_LIBS/cpolygonid-macos.a
cp ios/libpolygonid-ios.a $XCF_LIBS/cpolygonid-ios.a
cp ios/libpolygonid-ios-sim.a $XCF_LIBS/cpolygonid-ios-sim.a 

echo "Merging libraries..."

cd "$XCF_DIR"

libtool -static -no_warning_for_no_symbols \
  -o libs/libpolygonid-macos.a \
  libs/libbabyjubjub-macos.a \
  libs/cpolygonid-macos.a

libtool -static -no_warning_for_no_symbols \
  -o libs/libpolygonid-ios.a \
  libs/libbabyjubjub-ios.a \
  libs/cpolygonid-ios.a
  
libtool -static -no_warning_for_no_symbols \
  -o libs/libpolygonid-ios-sim.a \
  libs/libbabyjubjub-ios-sim.a \
  libs/cpolygonid-ios-sim.a
  
echo "Building xcframework..."

xcodebuild -verbose -create-xcframework \
     -output LibPolygonID.xcframework \
    -library libs/libpolygonid-macos.a \
    -headers ./include/ \
    -library libs/libpolygonid-ios-sim.a \
    -headers ./include/ \
    -library libs/libpolygonid-ios.a \
    -headers ./include/

#echo "Zipping..."
#zip -r libpolygonid.zip LibPolygonID.xcframework

#openssl dgst -sha256 libpolygonid.zip
