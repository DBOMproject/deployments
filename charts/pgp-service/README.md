# PGP Service Chart

This Helm chart is a lightweight way to configure and run the official
[PGP Service Docker image][].

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Requirements](#requirements)
- [Installing](#installing)
  - [Install released version using Helm repository](#install-released-version-using-helm-repository)
  - [Install development version using master branch](#install-development-version-using-master-branch)
- [Upgrading](#upgrading)
- [Configuration](#configuration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
<!-- Use this to update TOC: -->
<!-- docker run --rm -it -v $(pwd):/usr/src jorgeandrada/doctoc --github -->


## Requirements

* [Helm][] >=3.0.0
* Kubernetes >=1.13


## Installing

### Install released version using Helm repository

* Add the DBoM repo:
`helm repo add --ca-file <ca file> --cert-file <cert file> --key-file <key file> --username <username> --password <password> <repo name> http://charts.dbom.io`

* Install it:
  - with Helm 3: 
  `helm install --ca-file <ca file> --cert-file <cert file> --key-file <key file> --username=<username> --password=<password> --version <version> <repo name>/pgp-service`


### Install development version using master branch

* Clone the git repo: `git clone https://github.com/DBOMproject/deployments.git`

* Install it:
  - with Helm 3:
   `helm install ${deployname} ./deployments/charts/pgp-service --wait --version ${version} --namespace ${namespace} --set image.tag=${version} --set namespace=${namespace} ${additionalHelmParams}`


## Upgrading

* Get latest changes : `git pull`

* Upgrade it:
  - with Helm 3: 
  `helm upgrade -i ${deployname} ./deployments/charts/pgp-service --wait --version ${version} --namespace ${namespace} --set image.tag=${version} --set namespace=${namespace} ${additionalHelmParams}`


## Configuration

| Parameter                  | Description                                                        | Default                                       |
|----------------------------|--------------------------------------------------------------------|-----------------------------------------------|
| `affinity`                 | Configurable [affinity]                                            | {}                                            |
| `fullnameOverride`         | Overrides the full name of the resources. "                        | `""`                                          |
| `image.pullPolicy`         | The Kubernetes [imagePullPolicy] value                             | `IfNotPresent`                                |
| `imagePullSecrets`         | Configuration for [imagePullSecrets] for using a private registry  | `[]`                                          |
| `ingress`                  | [ingress] to expose the chainsource gateway service.               | see [values.yaml]                             |
| `labels`                   | Configurable [labels] applied to all chainsource gateway pods      | {}                                            |
| `logging.level`            | The logging level                                                  | `info`                                        |
| `nameOverride`             | Overrides the chart name for resources. default to `.Chart.Name`   | `""`                                          |
| `nodeSelector`             | Configurable [nodeSelector]                                        | `{}`                                          |
| `persistence.accessMode`   | Access mode for the volume                                         | `ReadWriteOnce`                               |
| `persistence.annotations`  | Annotations for the volume                                         | {}                                            |
| `persistence.enabled`      | Enable a persistent volume                                         | true                                          |
| `persistence.size`         | Size of volume                                                     | `1Gi`                                         |
| `persistence.storageClass` | Storage class to use                                               | `nfs-client`                                  |
| `pgp.createImage`          | PGP-create docker image                                            | `dbomproject/pgp-create`           |
| `pgp.config.hkpAddress`    | Address of HKP server to connect to                                | `http://keyserver.pks:11371/`                 |
| `pgp.config.id.email`      | Email to attach to public key                                      | `pgp@example.com`                             |
| `pgp.config.id.name`       | Name to attach to public key                                       | `PGP Example`                                 |
| `pgp.config.secret`        | Kubernetes secret to store the private key                         | `pgp-key`                                     |
| `pgp.config.keyType`       | Type of key to generate                                            | `ed25519`                                     |
| `pgp.logLevel`             | Log level of the service                                           | `info`                                        |
| `pgp.role`                 | Name of kubernetes role to have access to secrets                  | `standalone-pgp-secret-create`                |
| `pgp.serviceImage`         | PGP-service docker image                                           | `dbomproject/pgp-service` |
| `podAnnotations`           | Configurable [annotations]                                         | {}                                            |
| `podSecurityContext`       | Allows you to set the [securityContext] for the pod                | see [values.yaml]                             |
| `resources`                | Allows you to set the [resources] for the Deployment               | see [values.yaml]                             |
| `securityContext`          | Allows you to set the [securityContext] for the container          | see [values.yaml]                             |
| `service`                  | Configurable [service][] to expose the chainsource gateway         | see [values.yaml]                             |
| `serviceAccount`           | Allows you to overwrite the "default" [serviceAccount] for the pod | see [values.yaml]                             |
| `tolerations`              | Configurable [tolerations][]                                       | `[]`                                          |


[affinity]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
[annotations]: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
[helm]: https://helm.sh
[imagePullPolicy]: https://kubernetes.io/docs/concepts/containers/images/#updating-images
[imagePullSecrets]: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret
[ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/
[labels]: https://kubernetes.io/docs/conceptsoverview/working-with-objects/labels/
[resources]: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
[securityContext]: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
[service]: https://kubernetes.io/docs/concepts/services-networking/service/
[serviceAccount]: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
[tolerations]: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
[values.yaml]: values.yaml