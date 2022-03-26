<img src="img/microk8s-logo.png" height="100">   <img src="img/kubernetes-logo.png" height="100">    <img src="img/kube-bench-logo.png" height="105">

# MicroK8s & Kubernetes security benchmark from CIS

## Goal & Deliverables

![workflow badge](https://github.com/didier-durand/microk8s-kube-bench/workflows/MicroK8s%20kube-bench/badge.svg)

MicroK8s analysed for CIS benchmark with kube-bench. 

This repository implements a 100% automated workflow (via [microk8s-kube-bench.yml](.github/workflows/microk8s-kube-bench.yml) + [microk8s-kube-bench.sh](sh/microk8s-kube-bench.sh)) providing the installation of Microk8s on Ubuntu (run as a Github CI /CD worker). Kube-bench is then deployed and executed to obtain the analysis of the configuration of this Kubernetes cluster.

Last execution report on Github CI/CD is appended below. This workflow is scheduled for daily execution via cron directive in 
[microk8s-kube-bench.yml](.github/workflows/microk8s-kube-bench.yml)) : it can then check new snaps (see below) of MicroK8s as they get published. 

All suggestions for improvements or extensions are welcome. Same for pull requests!

## MicroK8s

[Microk8s](https://github.com/ubuntu/microk8s) by Canonical is single-package, fully conformant and lightweight Kubernetes distribution that works 
on numerous flavours of Linux. It is aimed at developer workstations, IoT, Edge & CI/CD. Simple to manage, this pure upstream distribution has 
same-day tracking for new releases, patches generated by root project. The [Snap package manager](https://en.wikipedia.org/wiki/Snap_(package_manager)) 
takes care of corresponding automated updates when new upstream code gets pushed.

Canonical additionally provides various preconfigured [standard K8s add-ons](https://microk8s.io/docs/addons) on top of the raw distribution: 
dashboard, istio, knative, metallb, cilium, kubeflow, etc.  They make MicroK8s quite suitable for advanced tests on a laptop. It is also a very 
easy way to [get started](https://microk8s.io/tutorials) with K8s on an autonomous / personal system.

 
## Kube-bench

As [per Wikipedia](https://en.wikipedia.org/wiki/Center_for_Internet_Security): *"The Center for Internet Security (CIS) is a 501(c)(3) nonprofit 
organization, formed in October, 2000. Its mission is to "identify, develop, validate, promote, and sustain best practice 
solutions for cyber defense and build and lead communities to enable an environment of trust in cyberspace".The organization is headquartered in 
East Greenbush, New York, with members including large corporations, government agencies, and academic institutions."*

[kube-bench](https://github.com/aquasecurity/kube-bench) by [Aqua Security](https://www.aquasec.com/) is a Go application that analyses how securely 
Kubernetes is deployed by running the checks documented in the [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes/).
Tests are configured with YAML files, making this tool easy to update as test specifications evolve.

The numbered items (like 1.2.3) found in execution report below correspond to the various points being defined and commented with this same number 
in the [official documentation](https://www.cisecurity.org/benchmark/kubernetes/) of the benchmark.

Basically, the analyis is executed via a [Yaml manifest](https://github.com/aquasecurity/kube-bench/blob/master/job.yaml) defining a [Kubernetes Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) deployed on the cluster. This job triggers the execution of
[aquasec/kube-bench:latest](https://hub.docker.com/r/aquasec/kube-bench) container image pulled from Docker Hub.

[This article](https://medium.com/better-programming/how-to-harden-your-kubernetes-cluster-with-kube-bench-fae71eb24d8) delivers deep and interesting 
insights on the benchmark.

## Fork and setup

If you want to reuse this repository, just fork it in your account. You can right away execute this workflow by using the button defined in the 
[workflow yaml](.github/workflows/microk8s-kube-bench.yml) via *'workflow_dispatch'* directive. No commit to change code needed: just run!

<img src="img/microk8s-kube-bench-workflow-button.jpg" height="250">

## Last execution report

```
execution date: Sat Mar 26 01:36:30 UTC 2022
 
microk8s snap version: microk8s  v1.19.15   2530   1.19/stable    canonical*  classic
 
W0326 01:36:16.408874    6666 util.go:315] 
Unable to find the programs kubectl or kubelet in the PATH.
These programs are used to determine which version of Kubernetes is running.
Make sure the /usr/local/mount-from-host/bin directory is mapped to the container,
either in the job.yaml file, or Docker command.

For job.yaml:
...
- name: usr-bin
  mountPath: /usr/local/mount-from-host/bin
...

For docker command:
   docker -v $(which kubectl):/usr/local/mount-from-host/bin/kubectl ....

Alternatively, you can specify the version with --version
   kube-bench --version <VERSION> ...
W0326 01:36:27.665812    6666 util.go:315] 
Unable to find the programs kubectl or kubelet in the PATH.
These programs are used to determine which version of Kubernetes is running.
Make sure the /usr/local/mount-from-host/bin directory is mapped to the container,
either in the job.yaml file, or Docker command.

For job.yaml:
...
- name: usr-bin
  mountPath: /usr/local/mount-from-host/bin
...

For docker command:
   docker -v $(which kubectl):/usr/local/mount-from-host/bin/kubectl ....

Alternatively, you can specify the version with --version
   kube-bench --version <VERSION> ...
[INFO] 1 Master Node Security Configuration
[INFO] 1.1 Master Node Configuration Files
[FAIL] 1.1.1 Ensure that the API server pod specification file permissions are set to 644 or more restrictive (Automated)
[FAIL] 1.1.2 Ensure that the API server pod specification file ownership is set to root:root (Automated)
[FAIL] 1.1.3 Ensure that the controller manager pod specification file permissions are set to 644 or more restrictive (Automated)
[FAIL] 1.1.4 Ensure that the controller manager pod specification file ownership is set to root:root (Automated)
[FAIL] 1.1.5 Ensure that the scheduler pod specification file permissions are set to 644 or more restrictive (Automated)
[FAIL] 1.1.6 Ensure that the scheduler pod specification file ownership is set to root:root (Automated)
[FAIL] 1.1.7 Ensure that the etcd pod specification file permissions are set to 644 or more restrictive (Automated)
[FAIL] 1.1.8 Ensure that the etcd pod specification file ownership is set to root:root (Automated)
[WARN] 1.1.9 Ensure that the Container Network Interface file permissions are set to 644 or more restrictive (Manual)
[WARN] 1.1.10 Ensure that the Container Network Interface file ownership is set to root:root (Manual)
[FAIL] 1.1.11 Ensure that the etcd data directory permissions are set to 700 or more restrictive (Automated)
[FAIL] 1.1.12 Ensure that the etcd data directory ownership is set to etcd:etcd (Automated)
[FAIL] 1.1.13 Ensure that the admin.conf file permissions are set to 644 or more restrictive (Automated)
[FAIL] 1.1.14 Ensure that the admin.conf file ownership is set to root:root (Automated)
[FAIL] 1.1.15 Ensure that the scheduler.conf file permissions are set to 644 or more restrictive (Automated)
[FAIL] 1.1.16 Ensure that the scheduler.conf file ownership is set to root:root (Automated)
[FAIL] 1.1.17 Ensure that the controller-manager.conf file permissions are set to 644 or more restrictive (Automated)
[FAIL] 1.1.18 Ensure that the controller-manager.conf file ownership is set to root:root (Automated)
[FAIL] 1.1.19 Ensure that the Kubernetes PKI directory and file ownership is set to root:root (Automated)
[WARN] 1.1.20 Ensure that the Kubernetes PKI certificate file permissions are set to 644 or more restrictive (Manual)
[WARN] 1.1.21 Ensure that the Kubernetes PKI key file permissions are set to 600 (Manual)
[INFO] 1.2 API Server
[WARN] 1.2.1 Ensure that the --anonymous-auth argument is set to false (Manual)
[PASS] 1.2.2 Ensure that the --basic-auth-file argument is not set (Automated)
[FAIL] 1.2.3 Ensure that the --token-auth-file parameter is not set (Automated)
[PASS] 1.2.4 Ensure that the --kubelet-https argument is set to true (Automated)
[PASS] 1.2.5 Ensure that the --kubelet-client-certificate and --kubelet-client-key arguments are set as appropriate (Automated)
[FAIL] 1.2.6 Ensure that the --kubelet-certificate-authority argument is set as appropriate (Automated)
[FAIL] 1.2.7 Ensure that the --authorization-mode argument is not set to AlwaysAllow (Automated)
[FAIL] 1.2.8 Ensure that the --authorization-mode argument includes Node (Automated)
[FAIL] 1.2.9 Ensure that the --authorization-mode argument includes RBAC (Automated)
[WARN] 1.2.10 Ensure that the admission control plugin EventRateLimit is set (Manual)
[PASS] 1.2.11 Ensure that the admission control plugin AlwaysAdmit is not set (Automated)
[WARN] 1.2.12 Ensure that the admission control plugin AlwaysPullImages is set (Manual)
[WARN] 1.2.13 Ensure that the admission control plugin SecurityContextDeny is set if PodSecurityPolicy is not used (Manual)
[PASS] 1.2.14 Ensure that the admission control plugin ServiceAccount is set (Automated)
[PASS] 1.2.15 Ensure that the admission control plugin NamespaceLifecycle is set (Automated)
[FAIL] 1.2.16 Ensure that the admission control plugin PodSecurityPolicy is set (Automated)
[FAIL] 1.2.17 Ensure that the admission control plugin NodeRestriction is set (Automated)
[PASS] 1.2.18 Ensure that the --insecure-bind-address argument is not set (Automated)
[PASS] 1.2.19 Ensure that the --insecure-port argument is set to 0 (Automated)
[PASS] 1.2.20 Ensure that the --secure-port argument is not set to 0 (Automated)
[FAIL] 1.2.21 Ensure that the --profiling argument is set to false (Automated)
[FAIL] 1.2.22 Ensure that the --audit-log-path argument is set (Automated)
[FAIL] 1.2.23 Ensure that the --audit-log-maxage argument is set to 30 or as appropriate (Automated)
[FAIL] 1.2.24 Ensure that the --audit-log-maxbackup argument is set to 10 or as appropriate (Automated)
[FAIL] 1.2.25 Ensure that the --audit-log-maxsize argument is set to 100 or as appropriate (Automated)
[WARN] 1.2.26 Ensure that the --request-timeout argument is set as appropriate (Automated)
[PASS] 1.2.27 Ensure that the --service-account-lookup argument is set to true (Automated)
[PASS] 1.2.28 Ensure that the --service-account-key-file argument is set as appropriate (Automated)
[FAIL] 1.2.29 Ensure that the --etcd-certfile and --etcd-keyfile arguments are set as appropriate (Automated)
[PASS] 1.2.30 Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate (Automated)
[PASS] 1.2.31 Ensure that the --client-ca-file argument is set as appropriate (Automated)
[FAIL] 1.2.32 Ensure that the --etcd-cafile argument is set as appropriate (Automated)
[WARN] 1.2.33 Ensure that the --encryption-provider-config argument is set as appropriate (Manual)
[WARN] 1.2.34 Ensure that encryption providers are appropriately configured (Manual)
[WARN] 1.2.35 Ensure that the API Server only makes use of Strong Cryptographic Ciphers (Manual)
[INFO] 1.3 Controller Manager
[WARN] 1.3.1 Ensure that the --terminated-pod-gc-threshold argument is set as appropriate (Manual)
[FAIL] 1.3.2 Ensure that the --profiling argument is set to false (Automated)
[PASS] 1.3.3 Ensure that the --use-service-account-credentials argument is set to true (Automated)
[PASS] 1.3.4 Ensure that the --service-account-private-key-file argument is set as appropriate (Automated)
[PASS] 1.3.5 Ensure that the --root-ca-file argument is set as appropriate (Automated)
[PASS] 1.3.6 Ensure that the RotateKubeletServerCertificate argument is set to true (Automated)
[PASS] 1.3.7 Ensure that the --bind-address argument is set to 127.0.0.1 (Automated)
[INFO] 1.4 Scheduler
[FAIL] 1.4.1 Ensure that the --profiling argument is set to false (Automated)
[PASS] 1.4.2 Ensure that the --bind-address argument is set to 127.0.0.1 (Automated)

== Remediations master ==
1.1.1 Run the below command (based on the file location on your system) on the
master node.
For example, chmod 644 /etc/kubernetes/manifests/kube-apiserver.yaml

1.1.2 Run the below command (based on the file location on your system) on the master node.
For example,
chown root:root /etc/kubernetes/manifests/kube-apiserver.yaml

1.1.3 Run the below command (based on the file location on your system) on the master node.
For example,
chmod 644 /etc/kubernetes/manifests/kube-controller-manager.yaml

1.1.4 Run the below command (based on the file location on your system) on the master node.
For example,
chown root:root /etc/kubernetes/manifests/kube-controller-manager.yaml

1.1.5 Run the below command (based on the file location on your system) on the master node.
For example,
chmod 644 /etc/kubernetes/manifests/kube-scheduler.yaml

1.1.6 Run the below command (based on the file location on your system) on the master node.
For example,
chown root:root /etc/kubernetes/manifests/kube-scheduler.yaml

1.1.7 Run the below command (based on the file location on your system) on the master node.
For example,
chmod 644 /etc/kubernetes/manifests/etcd.yaml

1.1.8 Run the below command (based on the file location on your system) on the master node.
For example,
chown root:root /etc/kubernetes/manifests/etcd.yaml

1.1.9 Run the below command (based on the file location on your system) on the master node.
For example,
chmod 644 <path/to/cni/files>

1.1.10 Run the below command (based on the file location on your system) on the master node.
For example,
chown root:root <path/to/cni/files>

1.1.11 On the etcd server node, get the etcd data directory, passed as an argument --data-dir,
from the below command:
ps -ef | grep etcd
Run the below command (based on the etcd data directory found above). For example,
chmod 700 /var/lib/etcd

1.1.12 On the etcd server node, get the etcd data directory, passed as an argument --data-dir,
from the below command:
ps -ef | grep etcd
Run the below command (based on the etcd data directory found above).
For example, chown etcd:etcd /var/lib/etcd

1.1.13 Run the below command (based on the file location on your system) on the master node.
For example,
chmod 644 /etc/kubernetes/admin.conf

1.1.14 Run the below command (based on the file location on your system) on the master node.
For example,
chown root:root /etc/kubernetes/admin.conf

1.1.15 Run the below command (based on the file location on your system) on the master node.
For example,
chmod 644 /etc/kubernetes/scheduler.conf

1.1.16 Run the below command (based on the file location on your system) on the master node.
For example,
chown root:root /etc/kubernetes/scheduler.conf

1.1.17 Run the below command (based on the file location on your system) on the master node.
For example,
chmod 644 /etc/kubernetes/controller-manager.conf

1.1.18 Run the below command (based on the file location on your system) on the master node.
For example,
chown root:root /etc/kubernetes/controller-manager.conf

1.1.19 Run the below command (based on the file location on your system) on the master node.
For example,
chown -R root:root /etc/kubernetes/pki/

1.1.20 audit test did not run: failed to run: "find /etc/kubernetes/pki/ -name '*.crt' | xargs stat -c permissions=%a", output: "find: /etc/kubernetes/pki/: No such file or directory\nBusyBox v1.34.1 (2021-11-23 00:57:35 UTC) multi-call binary.\n\nUsage: stat [-ltf] [-c FMT] FILE...\n\nDisplay file (default) or filesystem status\n\n\t-c FMT\tUse the specified format\n\t-f\tDisplay filesystem status\n\t-L\tFollow links\n\t-t\tTerse display\n\nFMT sequences for files:\n %a\tAccess rights in octal\n %A\tAccess rights in human readable form\n %b\tNumber of blocks allocated (see %B)\n %B\tSize in bytes of each block reported by %b\n %d\tDevice number in decimal\n %D\tDevice number in hex\n %f\tRaw mode in hex\n %F\tFile type\n %g\tGroup ID\n %G\tGroup name\n %h\tNumber of hard links\n %i\tInode number\n %n\tFile name\n %N\tFile name, with -> TARGET if symlink\n %o\tI/O block size\n %s\tTotal size in bytes\n %t\tMajor device type in hex\n %T\tMinor device type in hex\n %u\tUser ID\n %U\tUser name\n %x\tTime of last access\n %X\tTime of last access as seconds since Epoch\n %y\tTime of last modification\n %Y\tTime of last modification as seconds since Epoch\n %z\tTime of last change\n %Z\tTime of last change as seconds since Epoch\n\nFMT sequences for file systems:\n %a\tFree blocks available to non-superuser\n %b\tTotal data blocks\n %c\tTotal file nodes\n %d\tFree file nodes\n %f\tFree blocks\n %i\tFile System ID in hex\n %l\tMaximum length of filenames\n %n\tFile name\n %s\tBlock size (for faster transfer)\n %S\tFundamental block size (for block counts)\n %t\tType in hex\n %T\tType in human readable form\n", error: exit status 123
1.1.21 audit test did not run: failed to run: "find /etc/kubernetes/pki/ -name '*.key' | xargs stat -c permissions=%a", output: "find: /etc/kubernetes/pki/: No such file or directory\nBusyBox v1.34.1 (2021-11-23 00:57:35 UTC) multi-call binary.\n\nUsage: stat [-ltf] [-c FMT] FILE...\n\nDisplay file (default) or filesystem status\n\n\t-c FMT\tUse the specified format\n\t-f\tDisplay filesystem status\n\t-L\tFollow links\n\t-t\tTerse display\n\nFMT sequences for files:\n %a\tAccess rights in octal\n %A\tAccess rights in human readable form\n %b\tNumber of blocks allocated (see %B)\n %B\tSize in bytes of each block reported by %b\n %d\tDevice number in decimal\n %D\tDevice number in hex\n %f\tRaw mode in hex\n %F\tFile type\n %g\tGroup ID\n %G\tGroup name\n %h\tNumber of hard links\n %i\tInode number\n %n\tFile name\n %N\tFile name, with -> TARGET if symlink\n %o\tI/O block size\n %s\tTotal size in bytes\n %t\tMajor device type in hex\n %T\tMinor device type in hex\n %u\tUser ID\n %U\tUser name\n %x\tTime of last access\n %X\tTime of last access as seconds since Epoch\n %y\tTime of last modification\n %Y\tTime of last modification as seconds since Epoch\n %z\tTime of last change\n %Z\tTime of last change as seconds since Epoch\n\nFMT sequences for file systems:\n %a\tFree blocks available to non-superuser\n %b\tTotal data blocks\n %c\tTotal file nodes\n %d\tFree file nodes\n %f\tFree blocks\n %i\tFile System ID in hex\n %l\tMaximum length of filenames\n %n\tFile name\n %s\tBlock size (for faster transfer)\n %S\tFundamental block size (for block counts)\n %t\tType in hex\n %T\tType in human readable form\n", error: exit status 123
1.2.1 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the below parameter.
--anonymous-auth=false

1.2.3 Follow the documentation and configure alternate mechanisms for authentication. Then,
edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and remove the --token-auth-file=<filename> parameter.

1.2.6 Follow the Kubernetes documentation and setup the TLS connection between
the apiserver and kubelets. Then, edit the API server pod specification file
/etc/kubernetes/manifests/kube-apiserver.yaml on the master node and set the
--kubelet-certificate-authority parameter to the path to the cert file for the certificate authority.
--kubelet-certificate-authority=<ca-string>

1.2.7 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --authorization-mode parameter to values other than AlwaysAllow.
One such example could be as below.
--authorization-mode=RBAC

1.2.8 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --authorization-mode parameter to a value that includes Node.
--authorization-mode=Node,RBAC

1.2.9 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --authorization-mode parameter to a value that includes RBAC,
for example:
--authorization-mode=Node,RBAC

1.2.10 Follow the Kubernetes documentation and set the desired limits in a configuration file.
Then, edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
and set the below parameters.
--enable-admission-plugins=...,EventRateLimit,...
--admission-control-config-file=<path/to/configuration/file>

1.2.12 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --enable-admission-plugins parameter to include
AlwaysPullImages.
--enable-admission-plugins=...,AlwaysPullImages,...

1.2.13 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --enable-admission-plugins parameter to include
SecurityContextDeny, unless PodSecurityPolicy is already in place.
--enable-admission-plugins=...,SecurityContextDeny,...

1.2.16 Follow the documentation and create Pod Security Policy objects as per your environment.
Then, edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --enable-admission-plugins parameter to a
value that includes PodSecurityPolicy:
--enable-admission-plugins=...,PodSecurityPolicy,...
Then restart the API Server.

1.2.17 Follow the Kubernetes documentation and configure NodeRestriction plug-in on kubelets.
Then, edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --enable-admission-plugins parameter to a
value that includes NodeRestriction.
--enable-admission-plugins=...,NodeRestriction,...

1.2.21 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the below parameter.
--profiling=false

1.2.22 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --audit-log-path parameter to a suitable path and
file where you would like audit logs to be written, for example:
--audit-log-path=/var/log/apiserver/audit.log

1.2.23 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --audit-log-maxage parameter to 30 or as an appropriate number of days:
--audit-log-maxage=30

1.2.24 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --audit-log-maxbackup parameter to 10 or to an appropriate
value.
--audit-log-maxbackup=10

1.2.25 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --audit-log-maxsize parameter to an appropriate size in MB.
For example, to set it as 100 MB:
--audit-log-maxsize=100

1.2.26 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
and set the below parameter as appropriate and if needed.
For example,
--request-timeout=300s

1.2.29 Follow the Kubernetes documentation and set up the TLS connection between the apiserver and etcd.
Then, edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the etcd certificate and key file parameters.
--etcd-certfile=<path/to/client-certificate-file>
--etcd-keyfile=<path/to/client-key-file>

1.2.32 Follow the Kubernetes documentation and set up the TLS connection between the apiserver and etcd.
Then, edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the etcd certificate authority file parameter.
--etcd-cafile=<path/to/ca-file>

1.2.33 Follow the Kubernetes documentation and configure a EncryptionConfig file.
Then, edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the --encryption-provider-config parameter to the path of that file: --encryption-provider-config=</path/to/EncryptionConfig/File>

1.2.34 Follow the Kubernetes documentation and configure a EncryptionConfig file.
In this file, choose aescbc, kms or secretbox as the encryption provider.

1.2.35 Edit the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml
on the master node and set the below parameter.
--tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM
_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM
_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM
_SHA384

1.3.1 Edit the Controller Manager pod specification file /etc/kubernetes/manifests/kube-controller-manager.yaml
on the master node and set the --terminated-pod-gc-threshold to an appropriate threshold,
for example:
--terminated-pod-gc-threshold=10

1.3.2 Edit the Controller Manager pod specification file /etc/kubernetes/manifests/kube-controller-manager.yaml
on the master node and set the below parameter.
--profiling=false

1.4.1 Edit the Scheduler pod specification file /etc/kubernetes/manifests/kube-scheduler.yaml file
on the master node and set the below parameter.
--profiling=false


== Summary master ==
19 checks PASS
33 checks FAIL
13 checks WARN
0 checks INFO

[INFO] 3 Control Plane Configuration
[INFO] 3.1 Authentication and Authorization
[WARN] 3.1.1 Client certificate authentication should not be used for users (Manual)
[INFO] 3.2 Logging
[WARN] 3.2.1 Ensure that a minimal audit policy is created (Manual)
[WARN] 3.2.2 Ensure that the audit policy covers key security concerns (Manual)

== Remediations controlplane ==
3.1.1 Alternative mechanisms provided by Kubernetes such as the use of OIDC should be
implemented in place of client certificates.

3.2.1 Create an audit policy file for your cluster.

3.2.2 Consider modification of the audit policy in use on the cluster to include these items, at a
minimum.


== Summary controlplane ==
0 checks PASS
0 checks FAIL
3 checks WARN
0 checks INFO

[INFO] 4 Worker Node Security Configuration
[INFO] 4.1 Worker Node Configuration Files
[PASS] 4.1.1 Ensure that the kubelet service file permissions are set to 644 or more restrictive (Automated)
[PASS] 4.1.2 Ensure that the kubelet service file ownership is set to root:root (Automated)
[PASS] 4.1.3 If proxy kubeconfig file exists ensure permissions are set to 644 or more restrictive (Manual)
[PASS] 4.1.4 Ensure that the proxy kubeconfig file ownership is set to root:root (Manual)
[FAIL] 4.1.5 Ensure that the --kubeconfig kubelet.conf file permissions are set to 644 or more restrictive (Automated)
[WARN] 4.1.6 Ensure that the --kubeconfig kubelet.conf file ownership is set to root:root (Manual)
[WARN] 4.1.7 Ensure that the certificate authorities file permissions are set to 644 or more restrictive (Manual)
[WARN] 4.1.8 Ensure that the client certificate authorities file ownership is set to root:root (Manual)
[PASS] 4.1.9 Ensure that the kubelet --config configuration file has permissions set to 644 or more restrictive (Automated)
[PASS] 4.1.10 Ensure that the kubelet --config configuration file ownership is set to root:root (Automated)
[INFO] 4.2 Kubelet
[PASS] 4.2.1 Ensure that the anonymous-auth argument is set to false (Automated)
[FAIL] 4.2.2 Ensure that the --authorization-mode argument is not set to AlwaysAllow (Automated)
[PASS] 4.2.3 Ensure that the --client-ca-file argument is set as appropriate (Automated)
[PASS] 4.2.4 Ensure that the --read-only-port argument is set to 0 (Manual)
[PASS] 4.2.5 Ensure that the --streaming-connection-idle-timeout argument is not set to 0 (Manual)
[FAIL] 4.2.6 Ensure that the --protect-kernel-defaults argument is set to true (Automated)
[PASS] 4.2.7 Ensure that the --make-iptables-util-chains argument is set to true (Automated)
[PASS] 4.2.8 Ensure that the --hostname-override argument is not set (Manual)
[WARN] 4.2.9 Ensure that the --event-qps argument is set to 0 or a level which ensures appropriate event capture (Manual)
[WARN] 4.2.10 Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate (Manual)
[PASS] 4.2.11 Ensure that the --rotate-certificates argument is not set to false (Manual)
[PASS] 4.2.12 Verify that the RotateKubeletServerCertificate argument is set to true (Manual)
[WARN] 4.2.13 Ensure that the Kubelet only makes use of Strong Cryptographic Ciphers (Manual)

== Remediations node ==
4.1.5 Run the below command (based on the file location on your system) on the each worker node.
For example,
chmod 644 /etc/kubernetes/kubelet.conf

4.1.6 Run the below command (based on the file location on your system) on the each worker node.
For example,
chown root:root /etc/kubernetes/kubelet.conf

4.1.7 Run the following command to modify the file permissions of the
--client-ca-file chmod 644 <filename>

4.1.8 Run the following command to modify the ownership of the --client-ca-file.
chown root:root <filename>

4.2.2 If using a Kubelet config file, edit the file to set authorization: mode to Webhook. If
using executable arguments, edit the kubelet service file
/etc/systemd/system/snap.microk8s.daemon-kubelet.service on each worker node and
set the below parameter in KUBELET_AUTHZ_ARGS variable.
--authorization-mode=Webhook
Based on your system, restart the kubelet service. For example:
systemctl daemon-reload
systemctl restart kubelet.service

4.2.6 If using a Kubelet config file, edit the file to set protectKernelDefaults: true.
If using command line arguments, edit the kubelet service file
/etc/systemd/system/snap.microk8s.daemon-kubelet.service on each worker node and
set the below parameter in KUBELET_SYSTEM_PODS_ARGS variable.
--protect-kernel-defaults=true
Based on your system, restart the kubelet service. For example:
systemctl daemon-reload
systemctl restart kubelet.service

4.2.9 If using a Kubelet config file, edit the file to set eventRecordQPS: to an appropriate level.
If using command line arguments, edit the kubelet service file
/etc/systemd/system/snap.microk8s.daemon-kubelet.service on each worker node and
set the below parameter in KUBELET_SYSTEM_PODS_ARGS variable.
Based on your system, restart the kubelet service. For example:
systemctl daemon-reload
systemctl restart kubelet.service

4.2.10 If using a Kubelet config file, edit the file to set tlsCertFile to the location
of the certificate file to use to identify this Kubelet, and tlsPrivateKeyFile
to the location of the corresponding private key file.
If using command line arguments, edit the kubelet service file
/etc/systemd/system/snap.microk8s.daemon-kubelet.service on each worker node and
set the below parameters in KUBELET_CERTIFICATE_ARGS variable.
--tls-cert-file=<path/to/tls-certificate-file>
--tls-private-key-file=<path/to/tls-key-file>
Based on your system, restart the kubelet service. For example:
systemctl daemon-reload
systemctl restart kubelet.service

4.2.13 If using a Kubelet config file, edit the file to set TLSCipherSuites: to
TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
or to a subset of these values.
If using executable arguments, edit the kubelet service file
/etc/systemd/system/snap.microk8s.daemon-kubelet.service on each worker node and
set the --tls-cipher-suites parameter as follows, or to a subset of these values.
--tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
Based on your system, restart the kubelet service. For example:
systemctl daemon-reload
systemctl restart kubelet.service


== Summary node ==
14 checks PASS
3 checks FAIL
6 checks WARN
0 checks INFO

[INFO] 5 Kubernetes Policies
[INFO] 5.1 RBAC and Service Accounts
[WARN] 5.1.1 Ensure that the cluster-admin role is only used where required (Manual)
[WARN] 5.1.2 Minimize access to secrets (Manual)
[WARN] 5.1.3 Minimize wildcard use in Roles and ClusterRoles (Manual)
[WARN] 5.1.4 Minimize access to create pods (Manual)
[WARN] 5.1.5 Ensure that default service accounts are not actively used. (Manual)
[WARN] 5.1.6 Ensure that Service Account Tokens are only mounted where necessary (Manual)
[INFO] 5.2 Pod Security Policies
[WARN] 5.2.1 Minimize the admission of privileged containers (Manual)
[WARN] 5.2.2 Minimize the admission of containers wishing to share the host process ID namespace (Manual)
[WARN] 5.2.3 Minimize the admission of containers wishing to share the host IPC namespace (Manual)
[WARN] 5.2.4 Minimize the admission of containers wishing to share the host network namespace (Manual)
[WARN] 5.2.5 Minimize the admission of containers with allowPrivilegeEscalation (Manual)
[WARN] 5.2.6 Minimize the admission of root containers (Manual)
[WARN] 5.2.7 Minimize the admission of containers with the NET_RAW capability (Manual)
[WARN] 5.2.8 Minimize the admission of containers with added capabilities (Manual)
[WARN] 5.2.9 Minimize the admission of containers with capabilities assigned (Manual)
[INFO] 5.3 Network Policies and CNI
[WARN] 5.3.1 Ensure that the CNI in use supports Network Policies (Manual)
[WARN] 5.3.2 Ensure that all Namespaces have Network Policies defined (Manual)
[INFO] 5.4 Secrets Management
[WARN] 5.4.1 Prefer using secrets as files over secrets as environment variables (Manual)
[WARN] 5.4.2 Consider external secret storage (Manual)
[INFO] 5.5 Extensible Admission Control
[WARN] 5.5.1 Configure Image Provenance using ImagePolicyWebhook admission controller (Manual)
[INFO] 5.7 General Policies
[WARN] 5.7.1 Create administrative boundaries between resources using namespaces (Manual)
[WARN] 5.7.2 Ensure that the seccomp profile is set to docker/default in your pod definitions (Manual)
[WARN] 5.7.3 Apply Security Context to Your Pods and Containers (Manual)
[WARN] 5.7.4 The default namespace should not be used (Manual)

== Remediations policies ==
5.1.1 Identify all clusterrolebindings to the cluster-admin role. Check if they are used and
if they need this role or if they could use a role with fewer privileges.
Where possible, first bind users to a lower privileged role and then remove the
clusterrolebinding to the cluster-admin role :
kubectl delete clusterrolebinding [name]

5.1.2 Where possible, remove get, list and watch access to secret objects in the cluster.

5.1.3 Where possible replace any use of wildcards in clusterroles and roles with specific
objects or actions.

5.1.4 Where possible, remove create access to pod objects in the cluster.

5.1.5 Create explicit service accounts wherever a Kubernetes workload requires specific access
to the Kubernetes API server.
Modify the configuration of each default service account to include this value
automountServiceAccountToken: false

5.1.6 Modify the definition of pods and service accounts which do not need to mount service
account tokens to disable it.

5.2.1 Create a PSP as described in the Kubernetes documentation, ensuring that
the .spec.privileged field is omitted or set to false.

5.2.2 Create a PSP as described in the Kubernetes documentation, ensuring that the
.spec.hostPID field is omitted or set to false.

5.2.3 Create a PSP as described in the Kubernetes documentation, ensuring that the
.spec.hostIPC field is omitted or set to false.

5.2.4 Create a PSP as described in the Kubernetes documentation, ensuring that the
.spec.hostNetwork field is omitted or set to false.

5.2.5 Create a PSP as described in the Kubernetes documentation, ensuring that the
.spec.allowPrivilegeEscalation field is omitted or set to false.

5.2.6 Create a PSP as described in the Kubernetes documentation, ensuring that the
.spec.runAsUser.rule is set to either MustRunAsNonRoot or MustRunAs with the range of
UIDs not including 0.

5.2.7 Create a PSP as described in the Kubernetes documentation, ensuring that the
.spec.requiredDropCapabilities is set to include either NET_RAW or ALL.

5.2.8 Ensure that allowedCapabilities is not present in PSPs for the cluster unless
it is set to an empty array.

5.2.9 Review the use of capabilites in applications running on your cluster. Where a namespace
contains applicaions which do not require any Linux capabities to operate consider adding
a PSP which forbids the admission of containers which do not drop all capabilities.

5.3.1 If the CNI plugin in use does not support network policies, consideration should be given to
making use of a different plugin, or finding an alternate mechanism for restricting traffic
in the Kubernetes cluster.

5.3.2 Follow the documentation and create NetworkPolicy objects as you need them.

5.4.1 if possible, rewrite application code to read secrets from mounted secret files, rather than
from environment variables.

5.4.2 Refer to the secrets management options offered by your cloud provider or a third-party
secrets management solution.

5.5.1 Follow the Kubernetes documentation and setup image provenance.

5.7.1 Follow the documentation and create namespaces for objects in your deployment as you need
them.

5.7.2 Seccomp is an alpha feature currently. By default, all alpha features are disabled. So, you
would need to enable alpha features in the apiserver by passing "--feature-
gates=AllAlpha=true" argument.
Edit the /etc/kubernetes/apiserver file on the master node and set the KUBE_API_ARGS
parameter to "--feature-gates=AllAlpha=true"
KUBE_API_ARGS="--feature-gates=AllAlpha=true"
Based on your system, restart the kube-apiserver service. For example:
systemctl restart kube-apiserver.service
Use annotations to enable the docker/default seccomp profile in your pod definitions. An
example is as below:
apiVersion: v1
kind: Pod
metadata:
  name: trustworthy-pod
  annotations:
    seccomp.security.alpha.kubernetes.io/pod: docker/default
spec:
  containers:
    - name: trustworthy-container
      image: sotrustworthy:latest

5.7.3 Follow the Kubernetes documentation and apply security contexts to your pods. For a
suggested list of security contexts, you may refer to the CIS Security Benchmark for Docker
Containers.

5.7.4 Ensure that namespaces are created to allow for appropriate segregation of Kubernetes
resources and that all new resources are created in a specific namespace.


== Summary policies ==
0 checks PASS
0 checks FAIL
24 checks WARN
0 checks INFO

== Summary total ==
33 checks PASS
36 checks FAIL
46 checks WARN
0 checks INFO

```
