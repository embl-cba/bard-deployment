# Install k8s cluster locally #
This instruction details the steps required to install a local k8s cluster for testing of BARD. 
If you have an existing k8s cluster you do not need these steps, please visit [here](deploy-bard) to deploy BARD>

## Requirements ##
1. Ubuntu 22.04

### Step 1: Update system
```
sudo apt update -y
sudo apt upgrade -y
```
  
### Step 2: Disable swap

`sudo swapoff -a`

Load overlay and br_netfilter kernel modules
  
```
sudo modprobe overlay

sudo modprobe br_netfilter
```

Create the containerd.conf to load modules

```
sudo tee /etc/modules-load.d/containerd.conf > /dev/null <<EOF
overlay
br_netfilter
EOF
```
  

### Step3: Install containerd.io from docker repository

Open a terminal, install common packages
 
```
sudo apt-get install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
``` 

add source
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg

sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```
  
You will be prompted with a Y/N option in order to proceed with the installation.

  
Install containerd.io by
```
sudo apt update -y
sudo apt install -y containerd.io
```
 

### Step 4: Configure containerd.io
  
Configure containerd to use systemd as cgroup

```
sudo containerd config default > sudo /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
```

Enable the containerd utility by running:
``` 
sudo systemctl restart containerd
sudo systemctl enable containerd
```


### Step 5: Add K8s v1.28 signing key
```
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```
  

### Step 6: Add Xenial K8s Repo
``` 
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y
```

### Step 7: Install K8s

Create kubernetes.conf for sysctl.d

```
cat >>/etc/sysctl.d/kubernetes.conf <<EOF

net.bridge.bridge-nf-call-ip6tables = 1

net.bridge.bridge-nf-call-iptables = 1

net.ipv4.ip_forward = 1

EOF
```

Reload system sysctl changes
```
sysctl --system
```
  
Install kubelet, kubeadm, kubectl

```  
apt install -y kubelet kubeadm kubectl
```
k8s is now installed on your local system.

Check the version of kubeadm and verify the installation through by runnning:
 
```
kubeadm version -o yaml
```
you should get similar output as below:
```
clientVersion:
buildDate: "2022-10-12T10:55:36Z"
compiler: gc
gitCommit: 434bfd82814af038ad94d62ebe59b133fcb50506
gitTreeState: clean
gitVersion: v1.25.3
goVersion: go1.19.2
major: "1"
minor: "25"
platform: linux/amd64
```
