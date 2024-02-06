# PolygonID XCFramework 

## To Create an XCFramework

- Clone this repo in the same directory as `c-polygonid` and
  `libbabyjubjub`

- If you have not done so already, run `make init` in `libbabyjubjub`

- Run `build.sh`

## To Publish a New Version

- Choose a tag name.  For our purposes, let's assume we're using tag `v0.0.2`

- Zip the framework:
```
zip -r libpolygonid.zip LibPolygonID.xcframework
```

- Get the SHA value for the zip file:
```
openssl dgst -sha256 libpolygonid.zip
```

- Update `Package.swift`.

Change the `.binaryTarget` value.  The `url` will have the version we're about to create after `download`:  
`url: "https://github.com/jrl351/LibPolygonID/releases/download/v0.0.2/libpolygonid.zip"`

Change the `checksum` value to be the result from the `openssl` command from earlier:  
`checksum: "83807727c184eb03a38cc0a4c7ed9eb1cb2df96d80885536f99f1eff936f6938"` 


- Commit and push `Package.swift`

- Create and push the tag:
```
git tag v0.0.2
git push --tags
```

- Open the [Github page for this repo](https://github.com/jrl351/LibPolygonID).

- Click "Draft a new release"

- Click "Choose a tag" and select your tag (e.g. v0.0.2)

- Fill in a title and description

- Where it says "Attach binaries by dropping them here or selecting them." drag the zip file you just created and drop it there.

- Click "Publish Release"


## TODO
- PR for build stuff for c-polgyonid and libbjj
- Much makefile to add for libbjj
