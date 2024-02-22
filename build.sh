#!/bin/bash

XCF_DIR=`pwd`
XCF_LIBS="$XCF_DIR/libs"
XCF_TMP="$XCF_DIR/tmp"
XCF_INCLUDE="$XCF_DIR/include"

BJJ_DIR="$XCF_DIR/../BabyJubjub"
BJJ_LIBS="$XCF_DIR/babyjubjub/libs"

CPOLY_DIR="$XCF_DIR/../c-polygonid"

RS_DIR="$XCF_DIR/../rapidsnark"
RS_MACOS_DIR="$RS_DIR/package_macos_arm64"
RS_LIBS="$XCF_DIR/rapidsnark/libs"

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
rm -f $BJJ_LIBS/*.a
rm -f $RS_LIBS/*.a
rm -f $XCF_LIBS/*.a
rm -rf *.xcframework
rm -f *.zip

echo "Building libbabyjubjub..."

cd "$BJJ_DIR"

git pull

make ios
make bindings

mkdir -p $XCF_INCLUDE
cp target/bindings.h $XCF_INCLUDE/babyjubjub.h

mkdir -p $BJJ_LIBS
cp libs/libbabyjubjub-ios.a $BJJ_LIBS/libbabyjubjub-ios.a
cp libs/libbabyjubjub-ios-sim.a $BJJ_LIBS/libbabyjubjub-ios-sim.a
cp libs/libbabyjubjub-macos.a $BJJ_LIBS/libbabyjubjub-macos.a

cd $XCF_DIR
xcodebuild -verbose -create-xcframework \
     -output BabyJubjub.xcframework \
    -library $BJJ_LIBS/libbabyjubjub-macos.a \
    -library $BJJ_LIBS/libbabyjubjub-ios-sim.a \
    -library $BJJ_LIBS/libbabyjubjub-ios.a



echo "Building rapidsnark..."

RS_FILES=(librapidsnark libfr libfq libgmp)

cd $RS_DIR

git pull

git submodule init
git submodule update

./build_gmp.sh macos_arm64
mkdir -p build_prover_macos_arm64 && cd build_prover_macos_arm64
cmake .. -DTARGET_PLATFORM=macos_arm64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$RS_MACOS_DIR
make -j4 && make install

mkdir -p $RS_LIBS

for file in "${RS_FILES[@]}"; do
  cp "$RS_MACOS_DIR/lib/$file.a" "$RS_LIBS/$file-macos.a"
done

rm -f $RS_LIBS/rapidsnark-*
libtool -static -no_warning_for_no_symbols \
  -o $RS_LIBS/rapidsnark-macos.a \
  $RS_LIBS/*-macos.a


cd $XCF_DIR
xcodebuild -verbose -create-xcframework \
    -output Rapidsnark.xcframework \
    -library $RS_LIBS/rapidsnark-macos.a

echo "Building c-polygon..."

cd "$CPOLY_DIR"

git pull

make ios-simulator
make ios
make darwin-arm64

cp ios/libpolygonid.h "$XCF_INCLUDE"

mkdir -p $XCF_LIBS
cp ios/libpolygonid-darwin-arm64.a $XCF_LIBS/cpolygonid-macos.a
cp ios/libpolygonid-ios.a $XCF_LIBS/cpolygonid-ios.a
cp ios/libpolygonid-ios-simulator.a $XCF_LIBS/cpolygonid-ios-sim.a

echo "Merging libraries..."

cd "$XCF_DIR"

libtool -static -no_warning_for_no_symbols \
  -o libs/libpolygonid-macos.a \
  libs/*-macos.a

libtool -static -no_warning_for_no_symbols \
  -o libs/libpolygonid-ios.a \
  libs/*-ios.a

libtool -static -no_warning_for_no_symbols \
  -o libs/libpolygonid-ios-sim.a \
  libs/*-ios-sim.a
  
echo "Building xcframeworks..."



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
