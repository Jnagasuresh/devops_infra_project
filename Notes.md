// This file contains project running notes

> This is a blockquote. </br>
> It can span multiple lines.


#### To quit with out saving

```
:qa! enter
```
#### Setpermission on particular file or directory

```
chmod 600 /home/lalitha.jonna19/ssh-key
```

#### To Login VM using ssh key
> ssh -i ssh-key-file user@ip

#### To Login VM using passsword
> ssh  user@ip

#### To list out in particular directory
> ls -la /home

#### Some of ansible commands
> ansible -m ping -i inv all

**syntax-check**
> ansible-playbook -i inv 1-jenkins-master.yaml --syntax-check

__dry run__

> ansible-playbook -i inv 1-jenkins-master.yaml --check 

**Normal**

> ansible-playbook -i inv 1-jenkins-master.yaml 

> ansible -m ping -i inv all


** To check java verssion **
> java --version

### General commands 
 > Systemctl status jenkins

**Jenkings home directory:**

> /var/lib/jenkins

**To Remove linux file**
> rm -rf 1-jenkins-master.yaml

**Provide sudo permissions to user:**
 > sudo usermod -aG sudo lalitha.jonna19

 **Git basic** 
```
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/Jnagasuresh/i27-eureka.git
git push -u origin main
```

**Use the chmod command to set the permissions to 0600 (read and write for the owner, no permissions for others).**
> chmod 600 ssh-key

** To verify permissions**
--After changing the permissions, you can verify them using the ls -l command.
> ls -l ssh-key

**Connect using sshkey
>ssh -i /path/to/ssh-key lalitha.jonna19@10.1.0.3


**Node ips**
```
instance_ips = {
  "ansible" = {
    "private_ip" = "10.1.0.6"
    "public_ip" = "34.72.234.200"
  }
  "jenkins-master" = {
    "private_ip" = "10.1.0.3"
    "public_ip" = "34.69.220.109"
  }
  "jenkins-slave" = {
    "private_ip" = "10.1.0.2"
    "public_ip" = "34.69.44.175"
  }
  "sonarqube" = {
    "private_ip" = "10.5.0.2"
    "public_ip" = "34.73.212.154"
  }
}
```