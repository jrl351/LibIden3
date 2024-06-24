# LibIden3 XCFramework 

## To Create an XCFramework

- Clone this repo in the same directory as `c-polygonid` and
  `libbabyjubjub`

- If you have not done so already, run `make init` in `libbabyjubjub`

- Run `build.sh`

## To Publish a New Version of a framework

Right now the witness calculator builds `.a` files that are too big to upload to github.  Therefore this xcframework is downloaded as a `.zip` file.  This means if you make any updates, you need to upload a new version.  Here's how to do that.

- First choose a tag name, which is our version.  For our purposes, let's assume we're using tag `v0.0.9`

- Run `./build.sh`

- Zip the framework:
```
zip -r witnesscalc.zip WitnessCalc.xcframework
```

- Get the SHA value for the zip file:
```
openssl dgst -sha256 witnesscalc.zip
```

- Update `Package.swift`.

Change the `.binaryTarget` value.  The `url` will have the version we're about to create after `download`:  
`url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.9/witnesscalc.zip"`

Change the `checksum` value to be the SHA value from the `openssl` command from earlier:  
`checksum: "83807727c184eb03a38cc0a4c7ed9eb1cb2df96d80885536f99f1eff936f6938"` 

- Commit and push `Package.swift`

- Create and push the tag:
```
git tag v0.0.9
git push --tags
```

- Open the [Github page for this repo](https://github.com/jrl351/LibPolygonID).

- Click on "Releases"

- Click "Draft a new release"

- Click "Choose a tag" and select your tag (e.g. v0.0.9)

- Fill in a title and description

- Where it says "Attach binaries by dropping them here or selecting them" drag the zip file you just created and drop it there.

- Click "Publish Release"

## TODO
- PR for build stuff for c-polgyonid
