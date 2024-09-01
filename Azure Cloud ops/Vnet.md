* DMZ -- Demilitarized zone

CIDR: Classless Inter-Domain Routing notation
192.168.0.0/24 => 192.168.0.0 to 192.168.0.255
192.168.0.0/16 => 192.168.0.0 to 192.168.255.255
192.168.0.0/08 => 192.168.0.0 to 192.168.0.255

Recommendation:
  Small network is start with 192.168.0.x
  Large Network: start with 

  IP -- Dynamic or static
Private Endpoints


* NSG can assoicate to either VM or Subnet.
* Routing tables will be attached to Subnets.
* VM backup's are stored in page blocks
* Azure VM's are backed by VHD's (virtual hard drive)
* Azure data box
* WAF (Web Application Firewall)

* Availability zone
* Virtual machine scale set
* Availability set (hardware level)
  - Fault Domains
  - Update Domains 

  * Webservers, database servers generally will have static ips
  * public dynamic ip, public static ip, private dynamic ip, private static ip

  * NSG can define either on subnet or VM
  * NIC (Network interface card) is the one who has IP address, not the VM
  * VM can have more than one NIC (that means, more than one IP)

  * Azure vm is created from free defined templates, and pre defined sizes. ( There is not much customization is available to create vm's, one should consider only from predefined templates.)

  * tracet yahoo.com
  * route print
  * UDR:User defined routes
  * Virtual appliances
  * Route Tables
      - Other VNETS
      - Virtual Network Gatesways
      - Virtual appliances
      - Others
  
### Next Hop type
  - Virtual Network
  - Virtual Network gateway
  - Vitual appliance
  - None
  - Internet

* Global VNET peering

* DNS commands
* nslookup
* ipconfig

### Accelerated Networking
**Without Accelerated Networking** all networking traffic in and out of the VM traverses the host and the virtual switch. The virtual switch provides all policy enforcement to network traffic. Policies include network security groups, access control lists, isolation, and other network virtualized services.

**With Accelerated Networking** network traffic that arrives at the VM's network interface (NIC) is forwarded directly to the VM. Accelerated Networking offloads all network policies that the virtual switch applied, and it applies them in hardware. Because hardware applies policies, the NIC can forward network traffic directly to the VM. The NIC bypasses the host and the virtual switch, while it maintains all the policies that it applied in the host.

### offloading network processing

### Proximity Placement Groups:
 A proximity placement group is a logical grouping used to make sure that Azure compute resources are physically located close to each other. Proximity placement groups are useful for workloads where low latency is a requirement.


### Terminology
 * Spinning
 * SKU Size
 * SSL off-loading
 * Offloading



  

