# Trillian Agent

This Helm chart is a lightweight way to configure and run the official DBoM Trillian Agent Docker image.

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

- [Helm][] >=3.0.0
- Kubernetes >=1.13

## Installing

### Install released version using Helm repository

- Add the DBoM repo:
  `helm repo add --ca-file <ca file> --cert-file <cert file> --key-file <key file> --username <username> --password <password> <repo name> http://charts.dbom.io`

- Install it:
  - with Helm 3:
    `helm install --ca-file <ca file> --cert-file <cert file> --key-file <key file> --username=<username> --password=<password> --version <version> <repo name>/trillian-agent`

### Install development version using master branch

- Clone the git repo: `git clone https://github.com/DBOMproject/deployments.git`

- Install it:
  - with Helm 3:
    `helm install ${deployname} ./deployments/charts/trillian-agent --wait --version ${version} --namespace ${namespace} --set image.tag=${version} --set namespace=${namespace} ${additionalHelmParams}`

## Upgrading

- Get latest changes : `git pull`

- Upgrade it:
  - with Helm 3:
    `helm upgrade -i ${deployname} ./deployments/charts/trillian-agent --wait --version ${version} --namespace ${namespace} --set image.tag=${version} --set namespace=${namespace} ${additionalHelmParams}`

## Configuration

| Parameter                      | Description                                                        | Default                      |
| ------------------------------ | ------------------------------------------------------------------ | ---------------------------- |
| `affinity`                     | Configurable [affinity]                                            | {}                           |
| `agent.port`                   | Port to expose                                                     | `port`                       |
| `fullnameOverride`             | Overrides the full name of the resources. "                        | `""`                         |
| `image.repository`             | `trillian-agent` image repository                                  | `dbomproject/trillian-agent` |
| `image.tag`                    | `trillian-agent` image tag                                         | `1.0.0`                      |
| `image.pullPolicy`             | The Kubernetes [imagePullPolicy] value                             | `IfNotPresent`               |
| `imagePullSecrets`             | Configuration for [imagePullSecrets] for using a private registry  | `[]`                         |
| `ingress`                      | [ingress] to expose the chainsource agent service.                 | see [values.yaml]            |
| `jaeger.agent.sidecar.enabled` | Is Jaeger Agent Sidecar Injection Enabled                          | `false`                      |
| `jaeger.agent.sidecar.name`    | The deployed jaeger to connect to                                  | `true`                       |
| `jaeger.enabled`               | Is jaeger tracing enabled                                          | `false`                      |
| `jaeger.host`                  | The jaeger host to send traces to                                  | ``                           |
| `jaeger.sampler.type`          | The jaeger sampler type to use                                     | `const`                      |
| `jaeger.sampler.param`         | The parameter to pass to the jaeger sampler                        | `1`                          |
| `jaeger.serviceName`           | The name of the service passed to jaeger                           | `Chainsource Gateway`        |
| `labels`                       | Configurable [labels] applied to all trillian agent pods           | {}                           |
| `logging.level`                | The logging level                                                  | `info`                       |
| `nameOverride`                 | Overrides the chart name for resources. default to `.Chart.Name`   | `""`                         |
| `nodeSelector`                 | Configurable [nodeSelector]                                        | `{}`                         |
| `persistence.accessMode`       | Access mode for the volume                                         | `ReadWriteOnce`              |
| `persistence.annotations`      | Annotations for the volume                                         | {}                           |
| `persistence.enabled`          | Enable a persistent volume                                         | true                         |
| `persistence.size`             | Size of volume                                                     | `1Gi`                        |
| `persistence.storageClass`     | Storage class to use                                               | `nfs-client`                 |
| `podAnnotations`               | Configurable [annotations]                                         | {}                           |
| `podSecurityContext`           | Allows you to set the [securityContext] for the pod                | see [values.yaml]            |
| `resources`                    | Allows you to set the [resources] for the Deployment               | see [values.yaml]            |
| `securityContext`              | Allows you to set the [securityContext] for the container          | see [values.yaml]            |
| `service`                      | Configurable [service][] to expose the agent                       | see [values.yaml]            |
| `serviceAccount`               | Allows you to overwrite the "default" [serviceAccount] for the pod | see [values.yaml]            |
| `tolerations`                  | Configurable [tolerations][]                                       | `[]`                         |
| `trillian.channelConfigMapID`  | Id of channel config map tree                                      | `0`                          |
| `trillian.endpoint`            | Trillian Server Endpoint to Connect to                             | `localhost:8091`             |

[affinity]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
[annotations]: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
[helm]: https://helm.sh
[imagepullpolicy]: https://kubernetes.io/docs/concepts/containers/images/#updating-images
[imagepullsecrets]: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret
[ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/
[labels]: https://kubernetes.io/docs/conceptsoverview/working-with-objects/labels/
[resources]: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
[securitycontext]: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
[service]: https://kubernetes.io/docs/concepts/services-networking/service/
[serviceaccount]: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
[tolerations]: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
[values.yaml]: values.yaml
