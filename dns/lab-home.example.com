$TTL    604800
@       IN      SOA     bastion.lab-home.example.com. admin.lab-home.example.com. (
                112     ; Serial
             604800     ; Refresh
              86400     ; Retry
            2419200     ; Expire
             604800     ; Negative Cache TTL
)

; name servers - NS records
@    IN      NS      bastion.lab-home.example.com.

; name servers - A records
bastion.lab-home.example.com.         IN      A       10.0.22.20

; OpenShift Container Platform Cluster - A records
ocp4-bootstrap.lab-home.example.com.             IN      A      10.0.22.21
ocp4-control-plane-1.lab-home.example.com.       IN      A      10.0.22.22
ocp4-control-plane-2.lab-home.example.com.       IN      A      10.0.22.23
ocp4-control-plane-3.lab-home.example.com.       IN      A      10.0.22.24
ocp4-compute-1.lab-home.example.com.           IN    A    10.0.22.25
ocp4-compute-2.lab-home.example.com.            IN      A    10.0.22.26
ocp4-compute-3.lab-home.example.com.            IN      A    10.0.22.27

; OpenShift internal cluster IPs - A records
api.lab-home.example.com.        IN    A    10.0.22.18
api-int.lab-home.example.com.    IN    A    10.0.22.18

;internal
*.apps.lab-home.example.com.     IN    A    10.0.22.18
*.pub.lab-home.example.com.     IN      A       10.0.22.17


etcd-0.lab-home.example.com.    IN    A     10.0.22.22
etcd-1.lab-home.example.com.    IN    A    10.0.22.23
etcd-2.lab-home.example.com.     IN    A       10.0.22.24

; OpenShift internal cluster IPs - SRV records
_etcd-server-ssl._tcp.lab-home.example.com.    86400     IN    SRV     0    10    2380    etcd-0
_etcd-server-ssl._tcp.lab-home.example.com.    86400     IN    SRV     0    10    2380    etcd-1
_etcd-server-ssl._tcp.lab-home.example.com.    86400     IN    SRV     0    10    2380    etcd-2


