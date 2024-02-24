#!/bin/bash

XCF_DIR=`pwd`
XCF_INCLUDE="$XCF_DIR/include"

set -e

buildBabyJubJub() {
  echo "Building libbabyjubjub..."

  BJJ_DIR="$XCF_DIR/../BabyJubjub"
  BJJ_LIBS="$XCF_DIR/babyjubjub/libs"
  BJJ_TARGET="BabyJubjub.xcframework"

  cd $XCF_DIR

  rm -f $BJJ_LIBS/*.a
  rm -Rf $BJJ_TARGET

  cd "$BJJ_DIR"
  git pull

  make ios
  make bindings

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
}

buildWitness() {
 echo "Building witnesscalc..."

 WITNESS_FILES=(
   witnesscalc_authV2
   witnesscalc_credentialAtomicQueryMTPV2
   witnesscalc_credentialAtomicQueryMTPV2OnChain
   witnesscalc_credentialAtomicQuerySigV2
   witnesscalc_credentialAtomicQuerySigV2OnChain
   witnesscalc_credentialAtomicQueryV3
   witnesscalc_credentialAtomicQueryV3OnChain
 )

 WITNESS_DIR="$XCF_DIR/../witnesscalc"
 WITNESS_PACKAGE_DIR="$WITNESS_DIR/package"
 WITNESS_IOS_SIM_DIR="$WITNESS_DIR/build_witnesscalc_ios_simulator"
 WITNESS_IOS_SIM_OUTPUT_DIR="$WITNESS_IOS_SIM_DIR/src/Release-iphonesimulator"
 WITNESS_LIBS="$XCF_DIR/witnesscalc/libs"
 WITNESS_TARGET="WitnessCalc.xcframework"

  cd $XCF_DIR
  rm -f $WITNESS_LIBS/*.a
  rm -Rf $WITNESS_TARGET


  cd $WITNESS_DIR

  git pull
  git submodule init
  git submodule update

  # MacOS - ARM
  set +e
  ./build_gmp.sh host
  set -e
  make arm64_host

  cp $WITNESS_PACKAGE_DIR/include/*.h $XCF_INCLUDE/

  mkdir -p $WITNESS_LIBS
  for file in "${WITNESS_FILES[@]}"; do
    cp "$WITNESS_PACKAGE_DIR/lib/lib$file.a" "$WITNESS_LIBS/lib$file-macos.a"
  done

  cp "$WITNESS_PACKAGE_DIR/lib/libfr.a" "$WITNESS_LIBS/libfr-macos.a"
  cp "$WITNESS_PACKAGE_DIR/lib/libgmp.a" "$WITNESS_LIBS/libgmp-macos.a"

  # iOS Simulator
  set +e
  ./build_gmp.sh ios_simulator
  set -e
  make ios-simulator
  cd $WITNESS_IOS_SIM_DIR
  for file in "${WITNESS_FILES[@]}"; do
    xcodebuild -project witnesscalc.xcodeproj \
      -destination 'generic/platform=iOS Simulator' \
      -configuration Release \
      -scheme ${file}Static
    cp $WITNESS_IOS_SIM_OUTPUT_DIR/lib$file.a $WITNESS_LIBS/lib$file-ios-sim.a
  done

  cd $WITNESS_DIR

  cp "$WITNESS_IOS_SIM_OUTPUT_DIR/libfr.a" "$WITNESS_LIBS/libfr-ios-sim.a"
  cp "$WITNESS_DIR/depends/gmp/package_iphone_simulator/lib/libgmp.a" "$WITNESS_LIBS/libgmp-ios-sim.a"

  echo "Merging witnesscalc libraries..."

  rm -f $WITNESS_LIBS/witnesscalc-*
  libtool -static -no_warning_for_no_symbols \
    -o $WITNESS_LIBS/witnesscalc-macos.a \
    $WITNESS_LIBS/*-macos.a

  libtool -static -no_warning_for_no_symbols \
    -o $WITNESS_LIBS/witnesscalc-ios-sim.a \
    $WITNESS_LIBS/*-ios-sim.a

  echo "Building witnesscalc framework..."

  cd $XCF_DIR
  xcodebuild -verbose -create-xcframework \
    -output WitnessCalc.xcframework \
    -library $WITNESS_LIBS/witnesscalc-macos.a \
    -library $WITNESS_LIBS/witnesscalc-ios-sim.a
}

buildRapidsnark() {
  echo echo "Building rapidsnark..."

  RS_FILES=(librapidsnark libfr libfq libgmp)
  RS_DIR="$XCF_DIR/../rapidsnark"
  RS_MACOS_DIR="$RS_DIR/package_macos_arm64"
  RS_IOS_SIM_DIR="$RS_DIR/build_prover_ios_simulator"
  RS_IOS_SIM_OUTPUT_DIR="$RS_IOS_SIM_DIR/src/Release-iphonesimulator"

  RS_LIBS="$XCF_DIR/rapidsnark/libs"
  RS_TARGET="Rapidsnark.xcframework"

  cd $XCF_DIR
  rm -f $RS_LIBS/*.a
  rm -Rf $RS_TARGET

  cd $RS_DIR

  git pull
  git submodule init
  git submodule update

  # MacOS
  ./build_gmp.sh macos_arm64
  mkdir -p build_prover_macos_arm64 && cd build_prover_macos_arm64
  cmake .. -DTARGET_PLATFORM=macos_arm64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$RS_MACOS_DIR
  make -j4 && make install

  mkdir -p $RS_LIBS
  for file in "${RS_FILES[@]}"; do
    cp "$RS_MACOS_DIR/lib/$file.a" "$RS_LIBS/$file-macos.a"
  done

  # iOS Simulator
  cd $RS_DIR

  set +e
  ./build_gmp.sh ios_simulator
  set -e
  mkdir -p $RS_IOS_SIM_DIR && cd $RS_IOS_SIM_DIR
  cmake .. -GXcode -DTARGET_PLATFORM=IOS -DCMAKE_INSTALL_PREFIX=../package_ios_simulator -DUSE_ASM=NO
  xcodebuild -destination 'generic/platform=iOS Simulator' \
    -scheme rapidsnarkStatic \
    -project rapidsnark.xcodeproj \
    -configuration Release

  cp "$RS_DIR/build_prover_ios_simulator/src/Debug-iphonesimulator/libfq.a" "$RS_LIBS/libfq-ios-sim.a"
  cp "$RS_DIR/build_prover_ios_simulator/src/Debug-iphonesimulator/libfr.a" "$RS_LIBS/libfr-ios-sim.a"
  cp "$RS_DIR/build_prover_ios_simulator/src/Debug-iphonesimulator/librapidsnark.a" "$RS_LIBS/librapidsnark-ios-sim.a"
  cp $RS_DIR/depends/gmp/package_iphone_simulator/lib/libgmp.a $RS_LIBS/libgmp-ios-sim.a

  echo "Merging rapidsnark libraries..."
  rm -f $RS_LIBS/rapidsnark-*
  libtool -static -no_warning_for_no_symbols \
    -o $RS_LIBS/rapidsnark-macos.a \
    $RS_LIBS/*-macos.a

  libtool -static -no_warning_for_no_symbols \
    -o $RS_LIBS/rapidsnark-ios-sim.a \
    $RS_LIBS/*-ios-sim.a

  cd $XCF_DIR
  xcodebuild -verbose -create-xcframework \
    -output Rapidsnark.xcframework \
    -library $RS_LIBS/rapidsnark-macos.a \
    -library $RS_LIBS/rapidsnark-ios-sim.a
}

buildCPolygonID() {
  echo "Building c-polygon..."

  CPOLY_DIR="$XCF_DIR/../c-polygonid"
  CPOLY_LIBS="$XCF_DIR/cpolygon/libs"
  CPOLY_TARGET="LibPolygonID.xcframework"

  cd $XCF_DIR

  rm -f $CPOLY_LIBS/*.a
  rm -Rf $CPOLY_TARGET

  cd $CPOLY_DIR
  git pull

  make ios-simulator
  make ios
  make darwin-arm64

  cp ios/libpolygonid.h "$XCF_INCLUDE"

  mkdir -p $CPOLY_LIBS
  cp ios/libpolygonid-darwin-arm64.a $CPOLY_LIBS/libpolygonid-macos.a
  cp ios/libpolygonid-ios.a $CPOLY_LIBS/libpolygonid-ios.a
  cp ios/libpolygonid-ios-simulator.a $CPOLY_LIBS/libpolygonid-ios-sim.a

  echo "Building xcframework..."
  cd "$XCF_DIR"
  xcodebuild -verbose -create-xcframework \
    -output LibPolygonID.xcframework \
    -library $CPOLY_LIBS/libpolygonid-macos.a \
    -headers ./include/ \
    -library $CPOLY_LIBS/libpolygonid-ios-sim.a \
    -headers ./include/ \
    -library $CPOLY_LIBS/libpolygonid-ios.a \
    -headers ./include/
}

buildBabyJubJub
buildWitness
buildRapidsnark
buildCPolygonID
