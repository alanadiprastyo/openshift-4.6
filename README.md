# Installation Openshift 4.6  on VMware

## Chapter 1. Requirement OCP 4.6 on Vmware
1. Master 	= 3 (vCPU = 4, RAM = 16 GB, HDD = 120 GB)
2. Worker	= 3 (vCPU = 8, RAM = 32 GB, HDD = 120 GB)
3. Bootstrap	= 1 (vCPU = 4, RAM = 16 GB, HDD = 120 GB) --> Temporary Node
4. Bastion	= 1 (vCPU = 4, RAM = 8 GB, HDD = 120 GB)
5. Helper	= 1 (vCPU = 4, RAM = 8 GB, HDD = 120 GB)

### Network Requirement
1. Master 	(10.0.22.22-24 /24)
2. Worker 	(10.0.22.25-27 /24)
3. Bootstrap	(10.0.22.21 /24)
4. Bastion	(10.0.22.20 /24)
5. Helper	(10.0.22.18 /24)

### Vmware vSphere infrastucture requirements
![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/vmware-req.png)
**Note : If you use a vSphere version 6.5 instance, consider upgrading to 6.7U3 or 7.0 before you install OpenShift Container Platform.**
- You must ensure that the time on your ESXi hosts is synchronized before you install OpenShift Container Platform. See [Edit Time Configuration for a Host](https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.vsphere.vcenterhost.doc/GUID-8756D419-A878-4AE0-9183-C6D5A91A8FB1.html) in the VMware documentation. 
- A limitation of using VPC is that the Storage Distributed Resource Scheduler (SDRS) is not supported. See [vSphere Storage for Kubernetes FAQs](https://vmware.github.io/vsphere-storage-for-kubernetes/documentation/faqs.html) in the VMware documentation.

### Creating the User Provisioned Infrastructure
Before you deploy an OpenShift Container Platform cluster that uses user-provisioned infrastructure, you must create the underlying infrastructure.

*Prerequistes*
- Review the [OpenShift Container Platform 4.x Tested Integrations](https://access.redhat.com/articles/4128421) page before you create the supporting infrastructure for your cluster.

*Procedure*
1. Configure DHCP or set static IP addresses on each node.
2. Provision the required load balancers.
3. Configure the ports for your machines.
4. Configure DNS.
5. Ensure network connectivity.

### Networking Requirements for UPI
All the Red Hat Enterprise Linux CoreOS (RHCOS) machines require network in **initramfs** during boot to fetch Ignition config from the machine config server.

During the initial boot, the machines require either a *DHCP server or that static IP addresses* be set on each host in the cluster in order to establish a network connection, which allows them to download their Ignition config files.

**It is recommended to use the DHCP server to manage the machines for the cluster long-term. Ensure that the DHCP server is configured to provide persistent IP addresses and host names to the cluster machines.**

The Kubernetes API server must be able to resolve the node names of the cluster machines. If the API servers and worker nodes are in different zones, you can configure a default DNS search zone to allow the API server to resolve the node names. Another supported approach is to always refer to hosts by their fully-qualified domain names in both the node objects and all DNS requests.

![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/table-firewall.png)

### Example Topology
![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/topologi-ocp.png)

## Chapter 2. Set DNS (A and PTR Record) - Helper Node
Configure Bind Server :
```
root@helper# git clone https://github.com/alanadiprastyo/openshift-4.6.git
root@helper# yum -y install bind bind-utils
root@helper# setenforce 0
root@helper# cp openshift-4.6/dns/named.conf /etc/named.conf
```
Configure A Record :
```
root@helper# cp openshift-4.6/dns/lab-home.example.com /var/named/
```
Configure PTR Record :
```
root@helper# cp openshift-4.6/dns/10.0.22.in-addr.arpa  /var/named/
```
Restart Service Bind :
```
root@helper# systemctl restart named
root@helper# systemctl enable named
root@helper# systemctl status named
```
Make sure DNS can reply your query :
```
[root@helper ~]# nslookup ocp4-bootstrap.lab-home.example.com
Server:         10.0.22.18
Address:        10.0.22.18#53

Name:   ocp4-bootstrap.lab-home.example.com
Address: 10.0.22.21

[root@helper ~]# dig -x 10.0.22.21
;; ANSWER SECTION:
21.22.0.10.IN-ADDR.ARPA. 3600   IN      PTR     ocp4-bootstrap.lab-home.example.com.

;; AUTHORITY SECTION:
22.0.10.IN-ADDR.ARPA.   3600    IN      NS      bastion.lab-home.example.com.

;; ADDITIONAL SECTION:
bastion.lab-home.example.com. 604800 IN A       10.0.22.20

[root@helper ~]# dig -t srv _etcd-server-ssl._tcp.lab-home.example.com.
;; ANSWER SECTION:
_etcd-server-ssl._tcp.lab-home.example.com. 86400 IN SRV 0 10 2380 etcd-0.lab-home.example.com.
_etcd-server-ssl._tcp.lab-home.example.com. 86400 IN SRV 0 10 2380 etcd-1.lab-home.example.com.
_etcd-server-ssl._tcp.lab-home.example.com. 86400 IN SRV 0 10 2380 etcd-2.lab-home.example.com.

;; AUTHORITY SECTION:
lab-home.example.com.   604800  IN      NS      bastion.lab-home.example.com.

;; ADDITIONAL SECTION:
etcd-0.lab-home.example.com. 604800 IN  A       10.0.22.22
etcd-1.lab-home.example.com. 604800 IN  A       10.0.22.23
etcd-2.lab-home.example.com. 604800 IN  A       10.0.22.24
bastion.lab-home.example.com. 604800 IN A       10.0.22.20

[root@helper ~]# cat /etc/resolv.conf
# Generated by NetworkManager
nameserver 10.0.22.18
nameserver 10.0.22.238
```
NOTE: Update file `/var/named/lab-home.example.com and 10.0.22.in-addr.arpa` be adapted to your environment 

## Chapter 4. Set HAProxy as Load Balancer
```
root@helper# yum -y install haproxy
root@helper# cp openshift-4.6/haproxy/haproxy.cfg /etc/haproxy/
```
Please edit IP Address for Bootstrap, Master and Router (Worker).
You can check file conf **/etc/haproxy/haproxy.cfg**

```
Port 6443 : Bootstrap and Master ( API)
Port 22623 : Bootstrap and Master ( machine config)
Port 80 : Router-infra ( ingress http)
Port 443 : Router-infra ( ingress https)
Port 9000 : GUI for HAProxy
```

## Chapter 5. Preparation Installation Redhat CoreOS
Before you install openshift 4, you must create redhat account at cloud.redhat.com
![Cloud_Redhat](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/cloud-redhat.png)
Choose Red Hat Openshift Cluster Manager
![Cloud_Redhat](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/rhocp-4.png)
Click Create Cluster
![Cloud_Redhat](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/create-cluster.png)
Click Redhat Openshift Container Platform
![Cloud_Redhat](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/rhocp-deploy.png)
and Choose Run on Vmware VSphere
![Cloud_Redhat](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/rhocp-vmware.png)

Download Openshift Installer :

https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz

Download CLI (oc client & kubectl) :

https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz

Download RHCOS OVA (Template VM) :

https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/latest/latest/rhcos-vmware.x86_64.ova

