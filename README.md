# Network Doctor Container

network-doctor container 是用于容器/网络的『测试、问题定位 和 故障排除』工具。本身基于alipine linux3.15构建

此容器镜像包含很多工具，还有一个 `nginx` 网络服务器，默认监听 `80` 和 `443` 端口。 Web 服务器有助于以直接的方式运行此容器映像，因此您可以简单地 `exec` 进入容器并使用各种工具。

工具下载地址：
[https://hub.docker.com/r/dongjiang1989/network-doctor](https://hub.docker.com/r/dongjiang1989/network-doctor)

或者

```bash
docker pull dongjiang1989/network-doctor:latest
```


## 支持平台
* linux/amd64
* linux/arm64

### 工具集


* 以非 root 身份运行；某些工具（例如 `traceroute`、`tcptraceroute` 等）将不起作用
* 监听端口 `1180` 和 `11443` - 替换nginx 的 `80` 和 `443` 端口
* 一些可执行文件被手动设置为 `setuid`，所以这些工具仍然可用。使用 `setuid` 设置的工具有：
  * apk 
  * arping
  * busybox
  * mii-tool
  * tcpdump
  * tcptraceroute
  * traceroute
  * tshark
  * nsenter

**注意：** SSL 证书是为“localhost”生成的，是自签名的，并放置在 `/certs/` 目录中。在测试期间，请忽略证书警告/错误。使用 curl 时，您可以使用 `-k` 忽略 SSL 证书警告/错误。

------

# 如何使用镜像？
## 如何在 ``容器/pod网络`中使用这个镜像?

### 容器:

```bash
$ docker run  -d dongjiang1989/network-doctor:latest
```

进入容器：

```bash
$ docker exec -it container-name /bin/bash
```


### Kubernetes:

创建`pod`：
```
$ kubectl run network-dockor --image=dongjiang1989/network-dockor:latest
```

创建`deployment`：
```
$ kubectl create deployment network-dockor  --image=dongjiang1989/network-dockor:latest
```

进入容器
```
$ kubectl exec -it pod-name /bin/bash
```

**Note:** 可以通过 `--namespace=<your-desired-namespace>` 设置部署在那个`namespace`中

### 通过 `hack/network-dockor-daemonset.yaml` 进行部署
