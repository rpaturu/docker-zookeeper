# docker-zookeeper
Apache Zookeeper Docker Container

# Build Docker image by [Packer](http://www.packer.io/)

## How to run

Install Docker and Packer and execute the following commands

```
$ packer validate zookeeper.json
$ packer build -var 'version=v1.0.0' -var 'base_version=v1.0.0' zookeeper.json
```
Once packer creates the container, ansible provisions the container. Once container is provisioned, an image is created and pushed to docker index.
