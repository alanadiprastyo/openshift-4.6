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

![Arch_OCP_4.X](https://raw.githubusercontent.com/alanadiprastyo/openshift-4.6/master/gambar/topologi-ocp.png)

## Chapter 2. Set DNS (A and PTR Record) - Helper Node
Configure A Record & PTR Record on Bind :
```

```
