#!/bin/bash

XCF_DIR=`pwd`
XCF_LIBS="$XCF_DIR/libs"
XCF_INCLUDE="$XCF_DIR/include"

BJJ_DIR="$XCF_DIR/../libbabyjubjub"
BJJ_TARGET="$BJJ_DIR/target"

CPOLY_DIR="$XCF_DIR/../c-polygonid"

echo "Cleaning..."

mkdir -p libs
rm -f libs/*.a
rm -rf LibPolygonID.xcframework
rm -f libpolygonid.zip

echo "Building libbabyjubjub..."

cd "$BJJ_DIR"
cargo build --release --lib --target aarch64-apple-darwin
cargo build --release --lib --target x86_64-apple-darwin
cargo build --release --lib --target aarch64-apple-ios-sim
cargo build --release --lib --target aarch64-apple-ios 
cargo build --release --lib --target x86_64-apple-ios

lipo -create \
    target/aarch64-apple-ios-sim/release/libbabyjubjub.a \
    target/x86_64-apple-ios/release/libbabyjubjub.a \
    -output $XCF_LIBS/libbabyjubjub-ios-sim.a \

lipo -create \
  target/x86_64-apple-darwin/release/libbabyjubjub.a \
  target/aarch64-apple-darwin/release/libbabyjubjub.a \
  -output $XCF_LIBS/libbabyjubjub-macos.a

cp target/aarch64-apple-ios/release/libbabyjubjub.a $XCF_LIBS/libbabyjubjub-ios.a

make bindings
cp target/bindings.h $XCF_INCLUDE/babyjubjub.h

echo "Building c-polygon..."

cd "$CPOLY_DIR"

make ios
make darwin

cp ios/libpolygonid.h "$XCF_INCLUDE"
cp ios/libpolygonid-darwin.a $XCF_LIBS/cpolygon-macos.a
cp ios/libpolygonid-ios.a $XCF_LIBS/cpolygon-ios.a
cp ios/libpolygonid-ios-simulator.a $XCF_LIBS/cpolygon-ios-sim.a

echo "Merging libraries..."

cd "$XCF_DIR"

libtool -static -no_warning_for_no_symbols \
  -o libs/libpolygonid-macos.a \
  libs/libbabyjubjub-macos.a \
  libs/cpolygon-macos.a \

libtool -static -no_warning_for_no_symbols \
  -o libs/libpolygonid-ios.a \
  libs/libbabyjubjub-ios.a \
  libs/cpolygon-ios.a \

libtool -static -no_warning_for_no_symbols \
  -o libs/libpolygonid-ios-sim.a \
  libs/libbabyjubjub-ios-sim.a \
  libs/cpolygon-ios-sim.a \

echo "Building xcframework..."

xcodebuild -create-xcframework \
    -library libs/libpolygonid-macos.a \
    -headers ./include/ \
    -library libs/libpolygonid-ios.a \
    -headers ./include/ \
    -library libs/libpolygonid-ios-sim.a \
    -headers ./include/ \
    -output LibPolygonID.xcframework

echo "Zipping..."
zip -r libpolygonid.zip LibPolygonID.xcframework

openssl dgst -sha256 libpolygonid.zip
