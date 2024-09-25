# Operator SDK Builder

This repository contains the build configurations for building
the operator-sdk-builder image.

The builder image contains the following tools:

- [operator-sdk cli](https://sdk.operatorframework.io/docs/installation/)
- [kustomize](https://kustomize.io/)
- [envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)

Refer to the [.gitmodules](.gitmodules) file in order
to see the versions of `operator-sdk` and `kustomize`.

## Usage

```dockerfile

FROM konflux-ci/operator-sdk-builder:latest as builder

COPY ./. /repo
WORKDIR /repo
RUN kustomize build config/manifests/ \
    | envsubst \
    | operator-sdk generate bundle --output-dir build

FROM scratch

COPY --from=builder /repo/build/manifests /manifests/
COPY --from=builder /repo/build/metadata /metadata/
```
