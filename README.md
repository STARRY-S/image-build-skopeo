# image-build-skopeo

Build [skopeo](https://github.com/containers/skopeo) in SUSE [SLE Base Container Image](https://www.suse.com/products/base-container-images/).

## Usage

Create a tag representing to the skopeo version, then the Drone CI will build the docker image.

The built `hardened-skopeo` docker image is available at [cnrancher/hardened-skopeo](https://hub.docker.com/r/cnrancher/hardened-skopeo).

---

Build docker image manually:

```sh
# Run this script on AMD64 machine
# cnrancher/hardened-skopeo:v1.11.0-amd64
SKOPEO_VERSION="v1.11.0" ./scripts/docker.sh

# Run this script on ARM64 machine
# cnrancher/hardened-skopeo:v1.11.0-arm64
SKOPEO_VERSION="v1.11.0" ./scripts/docker.sh

# Build manifest list by docker-buildx
# cnrancher/hardened-skopeo:v1.11.0
SKOPEO_VERSION="v1.11.0" ./scripts/docker-manifest.sh
```

## LICENSE

Copyright 2023 [Rancher Labs, Inc](https://rancher.com).

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
