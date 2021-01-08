# Configure Jenkins for CI/CD


## 1. Install Jenkins on Centos 7
```
yum install java-1.8.0-openjdk-devel
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
yum install jenkins
systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins
```
check listen port 8080
```
# netstat -tunelp | grep 8080
tcp6       0      0 :::8080                 :::*                    LISTEN      998        20280      1662/java

```
add firewalld
```
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```
- access to web console jenkins <http://url:8080>
![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/unlock-jenkins.png)

- show initial password admin
```
# cat /var/lib/jenkins/secrets/initialAdminPassword
xxxxxxxxxxxxxxxxxxxxx
```
- Install plugin, choose install suggested plugins
![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/customize-jenkins.png)

- getting started install plugins
![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/getting-started.png)

- create user admin
![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/create-admin-jenkins.png)

- Instance Configuration
![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/instance-config.png)

- Jenkins is ready
![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/jenkins-ready.png)

- dashboard jenkins
![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/jenkins-dashboard.png)

