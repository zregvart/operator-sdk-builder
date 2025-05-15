FROM registry.access.redhat.com/ubi9/go-toolset:1.21.11-7 as osdk-builder

COPY ./operator-sdk/. /opt/app-root/src/
WORKDIR /opt/app-root/src
RUN go mod download
RUN  ls -l && CGO_ENABLED=0 GOOS=linux GOARCH=amd64  go build -a -o operator-sdk cmd/operator-sdk/main.go

FROM registry.access.redhat.com/ubi9/go-toolset:1.21.11-7 as kustomize-builder

COPY ./kustomize/. /opt/app-root/src/
WORKDIR /opt/app-root/src
RUN go mod download
RUN ls -l && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o kustomize ./kustomize

FROM registry.access.redhat.com/ubi9/ubi-minimal@sha256:92b1d5747a93608b6adb64dfd54515c3c5a360802db4706765ff3d8470df6290

COPY LICENSE /licenses
COPY --from=osdk-builder /opt/app-root/src/operator-sdk /bin
COPY --from=kustomize-builder /opt/app-root/src/kustomize /bin
RUN microdnf install -y gettext

ENTRYPOINT ["/bin/operator-sdk"]
