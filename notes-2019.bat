
curl   https://http-evader.semantic-gap.de/-BNBbcgSzNB90oj4Bd7U_XWG5OBN2_i8KcP84Fz63IRt06zgXPrQ-FGixLxc_sz5IY6oyAj-3IRt06z8XYrw6BmHrPAhtoA==



0323

ip -6 route 

root@smb-vm:/home/smb# ip -6 route
2001:7:1::/64 dev ens160 proto kernel metric 102 pref medium
fe80::/64 dev ens224 proto kernel metric 101 pref medium
fe80::/64 dev ens160 proto kernel metric 102 pref medium
fe80::/64 dev ens224 proto kernel metric 256 pref medium
fe80::/64 dev ens160 proto kernel metric 256 pref medium
default via 2001:7:1::38 dev ens160 proto static metric 20102 pref medium
root@smb-vm:/home/smb# ip -6 route delete 2001:7:1::/64


wget -qO - http://[2001:7:1::7]/ --header="Host: b1.ipv6.com"



fgt51: port5 --> sw port 12 

0321

FG34E1TB19900273 # sh sys interface  mgmt1

FG34E1TB19900273 # exec ping6 2001:172:43::38
PING 2001:172:43::38(2001:172:43::38) 56 data bytes
64 bytes from 2001:172:43::38: icmp_seq=1 ttl=64 time=0.048 ms
64 bytes from 2001:172:43::38: icmp_seq=2 ttl=64 time=0.011 ms
^C^[[A
--- 2001:172:43::38 ping statistics ---
3 packets transmitted, 2 packets received, 33% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.011/0.029/0.048/0.019 ms

FG34E1TB19900273 # exec ping6 2001:172:43::58
connect: Network is unreachable

FG34E1TB19900273 # exec ping6 2001:172:43::67
connect: Network is unreachable

config system interface
    edit "mgmt1"
......
        config ipv6 
            set ip6-address 2001:172:43::38/128         ------------------> reason 
            set ip6-allowaccess ping https ssh snmp http fgfm
        end
    next
end


0320

config web-proxy url-match
    edit "2"
        set url-pattern "ca"
        set forward-server "vm67"
    next
    edit "3"
        set url-pattern "com"
        set forward-server "fgt58"
    next
    edit "all2"
        set url-pattern "8$3"
    next
    edit "all"
        set url-pattern "*"
        set forward-server "vm58"
        set comment "forward-all"
    next
end





#!/bin/bash

ssh "$1" "nc -l 2323 > \"$2\" &"
pv "$2" | nc "$1" 2323

aiyan@van-201738-pc:~$ more cmd
smb://win2016.smb2016.lab/share_enc/curl-loop.sh
smbclient //smb-ubuntu.win2016.lab/share -m SMB3 -k -e


0316

re-org http checklist 
vip- willy 



C:\Opt\OpenSSH-Win64>ssh -L 5901:localhost:5901 -N -f -l aiyan  172.18.43.100
aiyan@172.18.43.100's password:

C:\Opt\OpenSSH-Win64>

===================2019

1212
Notes: ( ways after discussed with TOny
1) keep dc server busy 
2)  concurrent traffic to trigger 
3) replay the smb mesg ,, to sent reset proactivitely.. 

he /mt option of Robocopy can significantly improve speed on remote file transfers by using multiple threads when copying multiple small files

1205

Thanks  Jenny for the confirmation.
Here comes the test result on fg_5-6_auth_in_new_vdom.
In my test env ( 4000+ proxy-policies enabled/disabled) on 201E.
There sys mem stays** 14% **, which indicates the issues in 594598 not exist in 5.6 branch.
Please let me know if any further test needed for 5.6 regarding the ssl-exempt mem issue ( mantis 594598) .

Please note:  The test is no based on exact customer config due to no 6500F image at 5.6 build thus I switched to 201E . 




````

FortiGate-201E # get sys status | grep Version
Version: FortiGate-201E v5.6.0,build3924,190911 (GA)
Release Version Information: GA

==== When set all the policies disable 
FortiGate-201E # sh full fire proxy-policy | grep 'set status enable' -c
4403

FortiGate-201E # get sy perf status  | grep Mem
Memory: 4058188k total, 602588k used (14%), 3455600k free (86%)

==== When set all the policies disable
FortiGate-201E # sh full fire proxy-policy | grep 'set status disable' -c
4317

FortiGate-201E # get sy perf status  | grep Mem
Memory: 4058188k total, 575952k used (14%), 3482236k free (86%)

=======The master  policy for clone: 
FortiGate-201E # sh fir proxy-policy 4
config firewall proxy-policy
    edit 4
        set uuid 2b1c6c7e-1630-51ea-847d-b1099a22c7e5
        set proxy transparent-web
        set srcintf "ha"
        set dstintf "wan1"
        set srcaddr "all"
        set dstaddr "all"
        set service "webproxy"
        set action accept
        set schedule "always"
        set logtraffic all
        set utm-status enable
        set webfilter-profile "new_proxy"
        set profile-protocol-options "custom-default"
        set ssl-ssh-profile "my-ssl"
    next
end





Top3 581163: User-based Kerberos Authentication not working in new VDOM at Capgemi
80% 
sanity check OK , crashes found, some website(hp.com cant be processed correctly)

Mantis:
597795 wad crashed at wad_fw_policy_put and wad_hash_map_close  30% 
594451 application wad signal 6 (Aborted) crash, conserve mode  40%



1127

get sys perf status

diag test app wad 803
cmem_dump_stats(000, 00) ...

1121

 
TS: 
C2511-ATT1#clear line 8

1120
get system ha status
diagnose sys ha showcsum
execute ha synchronize config
execute ha manage <id>

FG6H1E5819900716 # get sys ha status


diag sys ha  
diag sys ha checksum show

exec ha sy start 

diag de app hasync /hatalk ...


1119

FIM (interface modules) 
FPM ( Process Modules) 
A FortiGate-7000 product consists of a FortiGate-7000 series chassis (for example, the FortiGate-7040E) with FortiGate-7000 modules installed in the chassis slots. 
A FortiGate-7040E chassis comes with two interface modules (FIM) to be installed in slots 1 and 2 to provide network connections and session-aware load balancing to two processor modules (FPM) to be installed in slots 3 and 4

conf auth scheme radius_test, set method as basic and user db as radius-server
radius:  vm-122   (172.18.43.122  aiyan/sa )
         secret        = testing123

 ( see  /etc/freeradius/clients)
client 0.0.0.0/0 {
    secret        = testing123
    shortname    = name 
}

user: /etc/freeradius/users 
grptest   Cleartext-Password := "fortinet"
           User-Service-Type = Login-User,
           Group = "group1",
           Fortinet-Group-Name = "devqa"

AVP: l=6 t=Service-Type(6) Value: 1 AVP: l=13 t=Vendor-Specific(26) v=Fortinet(12356) VSA: l=7 t=Fortinet-Group-Name(1) Value: &apos;devqa&apos;

1118
config authentication setting
    set active-auth-scheme "kerb_test"
    set captive-portal "fgt67"
    set captive-portal-port 8448
end


Nested LDAP: 

Yes, using the LDAP_MATCHING_RULE_IN_CHAIN matching rule (OID 1.2.840.113556.1.4.1941). For example:

(memberOf:1.2.840.113556.1.4.1941:=cn=group,cn=users,DC=devqa,dc=lab)



johns@johns-virtual-machine:~$ ldapsearch -h 172.18.43.124 -p 389 -D "cn=adu2,cn=users,dc=devqa,dc=lab" -w 12345678 -b "dc=devqa,dc=lab" "(|(objectSid=S-1-5-21-129035274-2917195938-48910757-513)(objectSid=S-1-5-21-129035274-2917195938-48910757-1105))" dn objectSid

# LDAPv3
# base <dc=devqa,dc=lab> with scope subtree
# filter: (|(objectSid=S-1-5-21-129035274-2917195938-48910757-513)(objectSid=S-1-5-21-129035274-2917195938-48910757-1105))
# requesting: ALL
#




1115 user time out:

wad user: 
firewall user: ( synced ..)
group: mantined by firewall user.


1114
Open the Active Directory Users and Computers snap-in
On the View menu, click Advanced Features.
Right-click the domain object, such as "company.com", and then click Properties.
On the Security tab, if the desired user account is not listed, click Add; if the desired user account is listed, proceed to step 7.
In the Select Users, Computers, or Groups dialog box, select the desired user account, and then click Add.
Click OK to return to the Properties dialog box.
Click the desired user account.
Click to select the Replicating Directory Changes check box from the list.
Click Apply, and then click OK.
1113 
grep  -f      Print fortinet config context

THTTT1F001-1 (root) # sh sys interface  | grep 172.18 -f
config system interface
    edit "wan1"
        set vdom "root"
        set ip 172.18.76.4 255.255.255.0 <---
        set allowaccess ping https http telnet
        set vlanforward enable
        set type physical
        set role wan
        set snmp-index 3

1112
status:
 http://httpbin.org/status/<code> 


1107
S448DNTF18000273 # diag switch mac-address list

MAC: 00:0c:29:62:9c:ea  VLAN: 811 Port: port24(port-id 24)
  Flags: 0x00010440 [ used ]

MAC: 00:0c:29:09:9a:9c  VLAN: 811 Port: port24(port-id 24)
  Flags: 0x00010440 [ used ]

MAC: 00:0c:29:62:9c:1c  VLAN: 812 Port: port24(port-id 24)
  Flags: 0x00010440 [ used ]

MAC: 00:0c:29:57:56:e6  VLAN: 812 Port: port24(port-id 24)
  Flags: 0x00000000 [ ]

MAC: 70:4c:a5:f2:0d:5c  VLAN: 812 Port: port51(port-id 51)
  Flags: 0x00010440 [ used ]

MAC: 02:00:99:a9:f4:33  VLAN: 812 Port: port51(port-id 51)
  Flags: 0x00010440 [ used ]



1106 
krb user MUST edit "au3@DEVQA.LAB"
        set type ldap
        set ldap-server "ldap166"
    next
	
1105
curl ftp://ftp@172.18.2.169 -x 172.18.76.6:8080 --proxy-user au2:12345678 
from wad debug: 
GET ftp://ftp@172.18.2.169/ HTTP/1.1
Host: 172.18.2.169:21
Proxy-Authorization: Basic YXUyOjEyMzQ1Njc4    ==> base64 decode au2:12345678 
Authorization: Basic ZnRwOg==
User-Agent: curl/7.63.0
Accept: */*
Proxy-Connection: Keep-Alive


1025
aiyan@van-201738-pc:~$curl -x socks5://u1:12345678@172.18.43.38:58080 172.18.43.100 -v
C:\Users\john> curl --socks5 172.18.76.6:8090 172.18.2.169 

1022

FGVM02TM19001723 (http-fgt34) # sh
config user krb-keytab
    edit "http-fgt34"
        set pac-data disable
        set principal "http/fgt34.devqa.lab@DEVQA.LAB"
        set ldap-server "ldap124"
        set keytab "BQIAAAA5AAIACURFVlFBLkxBQgAEaHR0cAAPZmd0MzQuZGV2cWEubGFiAAAAAQAAAAAKAAEACC89XWuSIOwyAAAAOQACAAlERVZRQS5MQUIABGh0dHAAD2ZndDM0LmRldnFhLmxhYgAAAAEAAAAACgADAAgvPV1rkiDsMgAAAEEAAgAJREVWUUEuTEFCAARodHRwAA9mZ3QzNC5kZXZxYS5sYWIAAAABAAAAAAoAFwAQJZdFyxI6UqouaTqqzKLbUgAAAFEAAgAJREVWUUEuTEFCAARodHRwAA9mZ3QzNC5kZXZxYS5sYWIAAAABAAAAAAoAEgAgla8Uw7RL+h+v/IIsa7sq/SrxXkCW18RHSMViX7xAK0QAAABBAAIACURFVlFBLkxBQgAEaHR0cAAPZmd0MzQuZGV2cWEubGFiAAAAAQAAAAAKABEAEBYajv3HS2kxjZaph443Exo="
    next
end


1017
Transfer-Encoding: chunked

Caching of unchanged resources
Another typical use of the ETag header is to cache resources that are unchanged. If a user visits a given URL again (that has an ETag set), and it is stale (too old to be considered usable), the client will send the value of its ETag along in an If-None-Match header field:

If-None-Match: "33a64df551425fcc55e4d42a148795d9f25f89d4"
The server compares the client's ETag (sent with If-None-Match) with the ETag for its current version of the resource, and if both values match (that is, the resource has not changed), the server sends back a 304 Not Modified status, without a body, which tells the client that the cached version of the response is still good to use (fresh).

1016
credential and ticket. In the greater Kerberos world, they are often used interchangeably. Technically, however, a credential is a ticket plus the session key for that session. This difference is explained in more detail in Gaining Access to a Service Using Kerberos.

FG3H1E5818900427 # d de crashlog re
1: 2019-10-08 18:32:27 logdesc="Memory conserve mode entered" service=kernel conserve=on total="7980
2: 2019-10-08 18:32:27 MB" used="7023 MB" red="7023 MB" green="6544 MB" msg="Kernel enters memory
3: 2019-10-08 18:32:27 conserve mode"
4: 2019-10-08 19:15:57 logdesc="Memory conserve mode exited" service=kernel conserve=exit total="7980
5: 2019-10-08 19:15:57 MB" used="6541 MB" red="7023 MB" green="6544 MB" msg="Kernel exits memory
6: 2019-10-08 19:15:57 conserve mode"

1015 

Kerberos Principal: A Kerberos principal is a unique identity to which Kerberos can assign tickets.
principal "host/smb-ubuntu.smb2016.lab@SMB2016.LAB"
By convention, a principal name is divided into three components: the primary, the instance, and the realm. A typical Kerberos principal would be, for example, joe/admin@ENG.EXAMPLE.COM. In this example:       

PAC: Privilege Account Certificate (PAC) is an extension element of the authorization-data field contained in the client's Kerberos ticket.  
The Privilege Account Certificate (PAC) is an extension element of the authorization-data field contained in the client's Kerberos ticket.  The PAC structure is defined in [MS-PAC] and conveys authorization data provided by domain controllers (DCs) in an Active Directory-enabled domain. It contains information such as security identifiers, group membership, user profile information, and password credentials.  The illustration below shows the relationship between a Kerberos ticket and PAC
ips debug: 

d ips de en all
dia de app ipse 0xffeff  

valgrind [valgrind-options] your-prog [your-prog-options]

johns@johns-virtual-machine:~/eh$ valgrind --tool=memcheck  --leak-check=full --show-leak-kinds=all  ls -al
[3124@10563]ips_match_rule: pattern matched 45756,67874: Suricata.TCP.Handshake.Content.Detection.Bypass


 #diagnose waf dump | grep 90300017
  90300017 - This signature prevents attackers from obtaining file and folder names using a tilde character "~" in a get request .


1011

Xerosploit- A Man-In-The-Middle Attack Framework

OWASP Zed Attack Proxy 
“Selenium automates browsers. That's it! What you do with
that power is entirely up to you. Primarily, it is for automating
web applications for testing purposes, but is certainly not
limited to just that. Boring web-based administration tasks
can (and should!) be automated as well.”

 Selenium scripts to drive ZAP to overcome "Web applications have Basic Authentication, User
Logins and Form Validation which stops ZAP in its tracks" 

From Tony Zhang 
diag deb en
1)diag sys top <-- find the wad process id with highest memory usage

2)diag test app wad 1000 <--- list all wad process, find the process id found in the step 1)
                              rememebr the type number(should be 2) and index (for example 3)
3)diag test app wad 22xy <----switch diag context to the highest memory usage wad process
If the index number is 3 found in the step 2, the 22xy should be 2203
after the command, you can found one output "Set diagnosis process: type=worker index=3 pid=188"
then all the following diag commands will be sent to that process.

3)diag test app wad 2
  diag test app wad 3
  diag test app wad 803
  diag test app wad 22
  diag test app wad 123
  diag test app wad 223

some command could have long output, in order to avoid interleaving the output, please input the cmd one by one.

4) diag test app wad 124 ---->clear the current http sessions , break current connections

check if the process's memory usage is lowered via step 1) after clear the http session
and repeate the step 3) to collect the stats again to compare.

5) if most system memeory is used by one wad process, restart the specific process is here
  "diag test app wad 99" (after that, the diag context switched to the wad manager process)

6) if step 5) is not executed, "diag test app wad 2000" to switch diag context to the wad manager process as default.

diag deb dis

tox is a generic virtualenv management and test command line tool you can use ... for this operation the same Python environment will be used as the one tox is ...
egg: 
OWASP Broken Web Applications Project 
1010

#./impacket/setup.py install 
root@johns-virtual-machine:/home/johns/eh/impacket/examples#
Reference Source: https://www.secureauth.com/labs/open-source-tools/impacket 


C:\opt\impacket\examples>lookupsid.py smb2016/u1:12345678@172.18.43.216
Impacket v0.9.21-dev - Copyright 2019 SecureAuth Corporation

[*] Brute forcing SIDs at 172.18.43.216
[*] StringBinding ncacn_np:172.18.43.216[\pipe\lsarpc]
[*] Domain SID is: S-1-5-21-976121073-726319924-1766729609
498: SMB2016\Enterprise Read-only Domain Controllers (SidTypeGroup)
500: SMB2016\Administrator (SidTypeUser)
501: SMB2016\Guest (SidTypeUser)
502: SMB2016\krbtgt (SidTypeUser)
503: SMB2016\DefaultAccount (SidTypeUser)
512: SMB2016\Domain Admins (SidTypeGroup)
513: SMB2016\Domain Users (SidTypeGroup)
514: SMB2016\Domain Guests (SidTypeGroup) 

1009
aiyan@van-201738-pc:~$ ls -al | sort -k 5n
-rw-rw-r--  1 aiyan aiyan  4049971 Jan 21  2019 test.dd
-rw-rw-r--  1 aiyan aiyan  4498189 Jan 22  2019 skype8-webproxy-deep.tra2
-rw-rw-r--  1 aiyan aiyan 17805312 Dec 14  2018 mydoc.tar

 
1008
NO “VLAN ID” Option on some NICs, as some drivers dose not support VLAN ID.

1007
And customer might try to disable "av-optimize" option to see if memory issue still persist.
     config antivirus profile
         edit "test"
             config http
                 set av-optimize disable <----
             end
         next
		 
		 

1003

#curl httpbin.org/status/418 -I
 

Access FCP08:   43308 ..
https://172.18.9.68:44308/ng/page/p/system/interface/?vdom=root

Find the FCP0X :
in MCB: root vdom: capture all traffic, then it's FPC08 : 

FGT6K-NYDC1-N02-U17 (root) # d sniffer  packet  any 'host 8.1.2.217'

interfaces=[any]
filters=[host 8.1.2.217]

[FPC01] 2.581975 8.1.2.217.50433 -> 199.7.83.42.53: udp 53
[FPC01] 2.581995 8.1.2.1 -> 8.1.2.217: icmp: net 199.7.83.42 unreachable
[FPC01] 2.581997 8.1.2.1 -> 8.1.2.217: icmp: net 199.7.83.42 unreachable
[FPC08] 3.412713 8.1.1.107.51518 -> 8.1.2.217.80: syn 1705965946
[FPC08] 3.412767 8.1.2.217.80 -> 8.1.1.107.51518: syn 3602255586 ack 1705965947


1001

Ctrl-T in telnet sessesion to switch FPs

<Current Console: FPC09(9600)>

<Switching to Console: FPC10(9600)>


F6KF50T018900081 login: admin
Password:
Welcome !



F6KF50T018900081 [FPC10] # c g
F6KF50T018900081 [FPC10] (global) # exec factoryreset

diag sys confsync sta | grep in_sy


FGT6K-NYDC1-N02-U17 (global) # exec load-balance slot manage

The following slots are available for management
Chassis:1    Slot:1    Module Serial-Number: FPC6KFT018901832
Chassis:1    Slot:2    Module Serial-Number: FPC6KFT018901831
Chassis:1    Slot:3    Module Serial-Number: FPC6KFT018901835
Chassis:1    Slot:4    Module Serial-Number: FPC6KFT018901850
Chassis:1    Slot:5    Module Serial-Number: FPC6KFT018901849
Chassis:1    Slot:6    Module Serial-Number: FPC6KFT018901834
Chassis:1    Slot:7    Module Serial-Number: FPC6KFT018901837
Chassis:1    Slot:8    Module Serial-Number: FPC6KFT018901840
Chassis:1    Slot:9    Module Serial-Number: FPC6KFT018901839
Chassis:1    Slot:10    Module Serial-Number: FPC6KFT018901833

FGT6K-NYDC1-N02-U17 (global) # con load-balance setting

FGT6K-NYDC1-N02-U17 (setting) # set dp-load-distribution-method
to-master                 to-master
src-ip                    src-ip
dst-ip                    dst-ip
src-dst-ip                src-dst-ip
src-ip-sport              src-ip-sport
dst-ip-dport              dst-ip-dport
src-dst-ip-sport-dport    src-dst-ip-sport-dport



POST with curl hangs unless you disable expect 100 continue via -H 'Expect:'
To disable Expect: 100 Continue 
>curl -X POST -F file=@p.zip 172.18.43.99:8005  -v  -H "Expect:"

0927

curl https://172.18.43.58:8443/remote/fgt_lang?lang=/../../../..//////////////////////////////bin/sh  -k  -I

curl -k -d "ajax=1&username=adu2&realm=&credential=12345678&credential2=pocz&credential3=pocz&magic=x-x&reqid=0&grpid=0" https://172.18.43.58:8443/remote/logincheck


0924

HA:
FGVM02TM19001724 # exec ha
disconnect      Disconnect from HA cluster.
manage          Slave cluster index.
set-priority    Set HA priority.
synchronize     HA synchronize commands.

d sys ha checksum sh 
d de app hatalk -1 
diagnose sys ha reset-uptime 


TerminalServer: 172.18.43.11   cisco/cisco 
#sh running-config
 |_http-title: Site doesn't have a title.
2033/tcp open  telnet  Cisco router telnetd
2034/tcp open  telnet  Cisco router telnetd
2035/tcp open  telnet  Cisco router telnetd
2038/tcp open  telnet  Cisco router telnetd
2041/tcp open  telnet  Cisco router telnetd
2046/tcp open  telnet  Cisco router telnetd
2047/tcp open  telnet  Cisco router telnetd
MAC Address: 00:12:D9:BE:B0:E0 (Cisco Systems)
Device type: WAP|router

0923 

POST-MAN: 
1) bulk edit: direct copy&paste for more headers 
2) to code: change to curl ... java code etc ...
curl -X POST \
  http://172.18.43.58:8443/remote/logincheck \
  -H 'Accept: */*' \
  -H 'Accept-Language: zh-CN,zh;q=0.9' \
  -H 'Cache-Control: no-store, no-cache, must-revalidate' \
  -H 'Connection: close' \
  -H 'Content-Length: 104' \
  -H 'Content-Type: text/plain;charset=UTF-8' \
  -H 'Postman-Token: 21f177b0-4e00-4a3a-9426-4f07a2dee5b0' \
  -H 'Pragma: no-cache' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36' \
  -H 'cache-control: no-cache' \
  -d 'ajax=1&username=guest&realm=&credential=pocz&credential2=pocz&credential3=pocz&magic=x-x&reqid=0&grpid=0'



0920

Memo for 529377:  SSL VPN cve: 
https://172.18.43.58:8443/remote/fgt_lang?lang=en 
on 5.4 CM build: will generate a lot of information 

Prequest:
-1: create 2 explicict web proxy policies: policy-1 for pc1 with fsso, policy-2 for pc2 with ntlm
-2: ensure 2 wad workers  (  # d test app wad 902 Set n_workers=2 n_debug_workers=2 )

curl --proxy-ntlm -U au2:12345678 -x 172.18.43.58:8080 172.18.2.169 

Steps:
1) clear all users 
d fire auth list (clear)
d wad  user list (clear)
2) trigger fsso user au1 by curl at pc1
3) kill the work which holding au1, to create out of sync user status:
sys kill -9  pid-work or 
(fnssyctl kill -9 pid at 5.4 CM build)
4) trigger ntlm auth (by policy-2) at pc2

Expected: 
At CM build, auth fail,
After the fix, auth OK 

NOTES:
enable wad debug at 5.4
#d de application  wad -1


NTLM Terminology
NTLM authentication is a challenge-response scheme, consisting of three messages, commonly referred to as Type 1 (negotiation), Type 2 (challenge) and Type 3 (authentication). It basically works like this:

The client sends a Type 1 message to the server. This primarily contains a list of features supported by the client and requested of the server.
The server responds with a Type 2 message. This contains a list of features supported and agreed upon by the server. Most importantly, however, it contains a challenge generated by the server.
The client replies to the challenge with a Type 3 message. This contains several pieces of information about the client, including the domain and username of the client user. It also contains one or more responses to the Type 2 challenge.
The responses in the Type 3 message are the most critical piece, as they prove to the server that the client user has knowledge of the account password.

The process of authentication establishes a shared context between the two involved parties; this includes a shared session key, used for subsequent signing and sealing operations.

From Mantis 583747: 

CONNECT http://www.cdiscount.com:443 HTTP/1.1
Host: http://www.cdiscount.com:443
Proxy-Connection: keep-alive
User-Agent: Mozilla/5.0 (Linux; Android 8.1.0; SM-T590) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36
Proxy-Authorization: NTLM TlRMTVNTUAABAAAAB4IIAAAAAAAgAAAAAAAAACAAAAA= >> TYPE1

HTTP/1.1 407 Proxy authentication required
Content-Type: text/html
Cache-Control: no-cache
Proxy-Authenticate: NTLM TlRMTVNTUAACAAAADgAOADgAAAAFgokCZcvIZn02KnQAAAAAAAAAANIA0gBGAAAABgGxHQAAAA9HAEwAQgAyADAAMAAwAAIADgBHAEwAQgAyADAAMAAwAAEAFABHAEwAQgBTAFMARABDAFAATAAzAAQAKgBnAGwAYgAuAGkAbgB0AHIAYQAuAGcAcgBvAHUAcABhAG0AYQAuAGYAcgADAEAARwBMAEIAUwBTAEQAQwBQAEwAMwAuAGcAbABiAC4AaQBuAHQAcgBhAC4AZwByAG8AdQBwAGEAbQBhAC4AZgByAAUAIgBpAG4AdAByAGEALgBnAHIAbwB1AHAAYQBtAGEALgBmAHIABwAIAObm1cQJatUBAAAAAA== >> TYPE2
Content-Length: 832

CONNECT http://www.cdiscount.com:443 HTTP/1.1
Host: http://www.cdiscount.com:443
Proxy-Connection: keep-alive
User-Agent: Mozilla/5.0 (Linux; Android 8.1.0; SM-T590) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36
Proxy-Authorization: NTLM TlRMTVNTUAADAAAAGAAYAFgAAABOAU4BcAAAAAAAAAC+AQAAEAAQAL4BAAASABIAzgEAAAAAAABYAAAABYIIAAAAAAAAAAAAR/+T8a2A9F/mwRON14x9pwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHA4/QZZi+zfCmZbSEibNv8BAQAAAAAAAObm1cQJatUBUC24cGqFkIIAAAAAAgAOAEcATABCADIAMAAwADAAAQAUAEcATABCAFMAUwBEAEMAUABMADMABAAqAGcAbABiAC4AaQBuAHQAcgBhAC4AZwByAG8AdQBwAGEAbQBhAC4AZgByAAMAQABHAEwAQgBTAFMARABDAFAATAAzAC4AZwBsAGIALgBpAG4AdAByAGEALgBnAHIAbwB1AHAAYQBtAGEALgBmAHIABQAiAGkAbgB0AHIAYQAuAGcAcgBvAHUAcABhAG0AYQAuAGYAcgAHAAgA5ubVxAlq1QEGAAQAAgAAAAoAEAAAAAAAAAAAAAAAAAAAAAAACQAsAEgAVABUAFAALwAyADEANwAuADEANgA3AC4AMAAuADYAOAA6ADgAMAA4ADAAAAAAAAAAAABzAG0AegAxADIANAAyADgAbABvAGMAYQBsAGgAbwBzAHQA >> TYPE 3


0918

tcpdump -nnSX port 443 
-X 
tcpdump net 1.2.3.0/24
tcpdump port 80 -w capture_file
tcpdump -r capture_file

Advanced:


# tcpdump  'port 8000 and host 172.18.43.184' -C 1 -X
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens192, link-type EN10MB (Ethernet), capture size 262144 bytes
11:21:36.438603 IP 172.18.43.58.20995 > johns-virtual-machine.8000: Flags [S], seq 1112130140, win 65535, options [mss 1460,sackOK,TS val 40729530 ecr 0,nop,wscale 14], length 0
        0x0000:  4500 003c a394 0000 4006 2811 ac12 2b3a  E..<....@.(...+:
        0x0010:  ac12 2bb8 5203 1f40 4249 c25c 0000 0000  ..+.R..@BI.\....
        0x0020:  a002 ffff a4d1 0000 0204 05b4 0402 080a  ................
        0x0030:  026d 7bba 0000 0000 0103 030e            .m{.........
11:21:36.438622 IP johns-virtual-machine.8000 > 172.18.43.58.20995: Flags [S.], seq 1783312934, ack 1112130141, win 65160, options [mss 1460,sackOK,TS val 749635306 ecr 40729530,nop,wscale 7], length 0
        0x0000:  4500 003c 0000 4000 4006 8ba5 ac12 2bb8  E..<..@.@.....+.
        0x0010:  ac12 2b3a 1f40 5203 6a4b 3226 4249 c25d  ..+:.@R.jK2&BI.]
        0x0020:  a012 fe88 af45 0000 0204 05b4 0402 080a  .....E..........
        0x0030:  2cae 86ea 026d 7bba 0103 0307            ,....m{.....
11:21:36.438665 IP 172.18.43.58.20995 > johns-virtual-machine.8000: Flags [.], ack 1, win 11, options [nop,nop,TS val 40729530 ecr 749635306], length 0
        0x0000:  4500 0034 a395 0000 4006 2818 ac12 2b3a  E..4....@.(...+:
        0x0010:  ac12 2bb8 5203 1f40 4249 c25d 6a4b 3227  ..+.R..@BI.]jK2'
        0x0020:  8010 000b 837e 0000 0101 080a 026d 7bba  .....~.......m{.
        0x0030:  2cae 86ea                                ,...

0916

FortiGate-201E # diagnose wad memory ssh | grep ': now [^0]'  ⇒ not 0


config ips sensor   
   set rule 29844  --> EICAR 

 
Content-Encoding: identity
Content-Encoding: br

// Multiple, in the order in which they were applied
Content-Encoding: gzip, identity
Content-Encoding: deflate, gzip

$ openssl s_server -key key.pem -cert cert.pem -accept 443  -www 

0909

testDCagent 172.18.43.166 8002 ubuntu-100 devqa adu1 1 172.18.43.100 1 10000 0
start sending logon events... Ctrl-C to stop
send request:1


3) How to clear users?
#wad 110 to list and wad 111 to clear 
for informer, if not effect,
#diag de authd fsso clear 
# di firewall auth list 
#dia debug  authd  fsso  clear 

0906

0905
https://wrong.host.badssl.com/ 

C:\tmp>curl -X POST -F file=@l.bat 172.18.43.184:8000 

0904

openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes


KerbTicket
Traditionally, a principal is divided into three parts: the primary, the instance, and the realm. The format of a typical Kerberos V5 principal is primary/instance@REALM.

The primary is the first part of the principal. In the case of a user, it's the same as your username. For a host, the primary is the word host.
The instance is an optional string that qualifies the primary. The instance is separated from the primary by a slash (/). In the case of a user, the instance is usually null, but a user might also have an additional principal, with an instance called admin, which he/she uses to administrate a database. The principal jennifer@ATHENA.MIT.EDU is completely separate from the principal jennifer/admin@ATHENA.MIT.EDU, with a separate password, and separate permissions. In the case of a host, the instance is the fully qualified hostname, e.g., daffodil.mit.edu.
The realm is your Kerberos realm. In most cases, your Kerberos realm is your domain name, in upper-case letters. For example, the machine daffodil.example.com would be in the realm EXAMPLE.COM.

0903

0830

GET / HTTP/1.1
Host: httpbin.org  :point_left: on new line
:point_left: then two blank lines

 GET / HTTP/1.1
 Host: <<SUBNET>>.99

 printf "GET /index.html HTTP/1.1\r\nHost: 172.18.2.169\r\n\r\n"|nc <<SUBNET>>.34 8080


netcat: listen to a request and return 200 HTTP response
## test is the program that returns response body
while true; do { echo -e 'HTTP/1.1 200 OK\r\n'} | nc -l 8909; done; 
sh test;  
## test sample
#!/bin/bash

echo "************PRINT SOME TEXT***************\n"
echo "Hello World!!!"
echo "\n"

echo "Resources:"
vmstat -S M
echo "\n"
===> end

POST /upload.php HTTP/1.1
Host: 172.18.13.106:8000
Authorization: Basic bmdpbng6MTIzNA==
User-Agent: curl/7.53.1
Accept: */*
Content-Length: 1079
Content-Type: application/x-www-form-urlencoded
Expect: 100-continue

Content-Disposition: form-data; name="GetKeyCode"

13B22F4EC941C4D9148286B1F5213B3005E806D7A688FCE3585B62BCD013A9B87213B1E89EFA0EE115AF2B9F651A52FAB6470FEB45F5E4D0D8BD8777603179CF3BAF784A6770A4490E892DE2ECCD504B4013AB038DAE6600CDA0584E4029E4C13E591FA72F08494D8D391029146A379B51C778E39525E41AC3AC6D56D79DAC4DD87AE150AB55BBC3B21580AE6412CE639CEA39DFD3EA6AA92FCECA31599B1FDA2E1EFCF19305EB5868B356B5DEE337AC50291C16BC1758DF9C4EE4A5E6DE9CA2388EA12CD8BC3E2F595BE78E8DBCB75A54FB190AFBD81DE192C57A0A4B5F874DEC85CF743C217EB606BB21F7DE1FFCB93ED51CB791E13926A0F1B3E6AB45741D58A8EDF249EEE978FEB406EA1AA5ECF5195F2276D2C12D119BEE2351D69F43E1180816B90B45614C209691BBF9EFD96CBFAABD08B1D2E799F7E5658DB334830D95796523BFB1A694BDCA9336ACB105CB22AC048433EB053F4C06C854D4AC8552CD1CCA1ED448AB607C233BCE863A772B32DC463C05FC5C249AAB9AA2C1182C1F316492A08A93073A1305B96E3358CB8F5C1BA584611A48C8D5974E3F445936BC69BD89BAF25E06FDAD3B9566E7FF053FE1EF749D2C6DA8A800E4CD16FA6829DCF9AC6CF0D55DEE774AFBB616556F8E641E818AE83955657D5655FED5608BC4204B9A66E66C5000BE888C74745B9EEB5C099B0ACA22AF170F55D0E698B13F0C14

How to added to java-code ?
copy&paste to https://www.freeformatter.com/java-dotnet-escape.html#ad-output 
in eclipse to define str and split ( eclipse will reformat it  in multible lines)

0828
Why Are You So Smart? Thank Mom and Your Difficult Birth 

d test app fnbamd -1 
sysctl killall iked 




Why must you use aggressive mode when a local FortiGate IPSec gateway hosts multiple dialup tunnels?
    A. In aggressive mode, the remote peers are able to provide their peer IDs in the first message.
	thus the responder can use the peer-id to identify the security policy 
	
#curl https://securewf.fortiguard.net -k
curl: (35) error:14094410:SSL routines:ssl3_read_bytes:sslv3 alert handshake failure 

CAPWAP (Control and Provisioning of Wireless Access Points) is a protocol that enables an access controller (AC) to manage a collection of wireless termination points. CAPWAP is defined in RFC 5415. 




config firewall vip
    edit "vip7"             ------> canot be in FW policy due to extIntf 
        set uuid c09a9820-bfb4-51e9-0859-b39fc447fc98
        set src-filter "<<SUBNET>>.1" "<<SUBNET>>.0/24"
        set service "FTP" "HTTP" "HTTPS"
        set extip <<SUBNET>>.58
        set extintf "port9"
        set mappedip "7.7.7.58"
    next
    edit "nse-vip"      ------> can be in FW policy 
        set uuid c4801770-c9ce-51e9-2d4a-a26085bb22ef
        set extip 172.21.8.8
        set extintf "any"
        set mappedip "6.11.1.1"
    next
end




0827 

\\172.16.100.80\Images\FortiOS\v6.00\images\NoMainBranch\fg_6-2_wad_cleanup\build_tag_5230 


TCP port 23 ,ether-type 8893 over heatbeat link 


FG3H1E5818900019 # d de flow filter clear
FG3H1E5818900019 # d de flow  filter dport 80
FG3H1E5818900019 # d de fl trace  start 10
FG3H1E5818900019 # d de en

FG3H1E5818900019 # id=20085 trace_id=146 func=print_pkt_detail line=5445 msg="vd-root:0 received a packet(proto=6, 7.1.1.164:43276-><<SUBNET>>.216:80) from port7. flag [S], seq 3955754312, ack 0, win 29200"
id=20085 trace_id=146 func=init_ip_session_common line=5610 msg="allocate a new session-00023b61"
id=20085 trace_id=146 func=vf_ip_route_input_common line=2596 msg="find a route: flag=04000000 gw-<<SUBNET>>.216 via mgmt"
id=20085 trace_id=146 func=fw_forward_handler line=778 msg="Allowed by Policy-4: SNAT"
id=20085 trace_id=146 func=__ip_session_run_tuple line=3239 msg="SNAT 7.1.1.164-><<SUBNET>>.34:43276"

0826

d de authd  fsso  list
----FSSO logons----
IP: <<SUBNET>>.101  User: AU1  Groups: CN=AU1,CN=USERS,DC=DEVQA,DC=LAB+CN=USERS,DC=DEVQA,DC=LAB+CN=DOMAIN USERS,CN=USERS,DC=DEVQA,DC=LAB+CN=ADMINISTRATORS,CN=BUILTIN,DC=DEVQA,DC=LAB+CN=REMOTE DESKTOP USERS,CN=BUILTIN,DC=DEVQA,DC=LAB+CN=USERS,CN=BUILTIN,DC=DEVQA,DC=LAB  Workstation: <<SUBNET>>.101
Total number of logons listed: 1, filtered: 0






FGVM02TM19001723 # d vpn tunnel  list
list all ipsec tunnel in vd 0
------------------------------------------------------
name=nse-site2site ver=1 serial=3 7.1.1.58:0->7.1.1.64:0
bound_if=9 lgwy=static/1 tun=intf/0 mode=auto/1 encap=none/0
proxyid_num=1 child_num=0 refcnt=12 ilast=3 olast=404 ad=/0
stat: rxp=0 txp=0 rxb=0 txb=0
dpd: mode=on-demand on=1 idle=20000ms retry=3 count=0 seqno=0
natt: mode=none draft=0 interval=0 remote_port=0
proxyid=nse-site2site proto=0 sa=1 ref=2 serial=2
  src: 0:0.0.0.0/0.0.0.0:0
  dst: 0:0.0.0.0/0.0.0.0:0
  SA:  ref=3 options=10226 type=00 soft=0 mtu=1438 expire=42827/0B replaywin=2048
       seqno=1 esn=0 replaywin_lastseq=00000000 itn=0
  life: type=01 bytes=0/0 timeout=42931/43200
  dec: spi=bbef25bf esp=aes key=16 1ff477d7a6da97dec737b310ab977b24
       ah=sha1 key=20 29f5c0ee6ab004c969ee6daa46f3d909847f229d
  enc: spi=9b2c926c esp=aes key=16 0108724f5ce91b72edcfe927a7f28ba4
       ah=sha1 key=20 51c9e0daaacddfe2cdf89504a9ae0d78d14ed3a1
  dec:pkts/bytes=0/0, enc:pkts/bytes=0/0

ike 0: comes 7.1.1.64:500->7.1.1.58:500,ifindex=9....
ike 0: IKEv1 exchange=Informational id=d0bd16bd09180b08/5ccfeca6d776178a:fb7fcc84 len=92
ike 0: in D0BD16BD09180B085CCFECA6D776178A08100501FB7FCC840000005CA4A4AE8389A550C33DAB3D4A8F3A99C3A6556E7EAF8055B056799FEE39019975C5D1764BF5B3E3BDCE684ADEDC20B46D4567F86F07C806D31C2C955115E02EAF
ike 0:nse-site2site:16: dec D0BD16BD09180B085CCFECA6D776178A08100501FB7FCC840000005C0C000024F1F547C4B6A2CB556126AF5DD0A905B0F189AFD42EBB21E4F39D6337AFD7D09E0000001000000001030400019B2C926B924EE3330715D9FFFF16500B
ike 0:nse-site2site:16: recv IPsec SA delete, spi count 1
ike 0:nse-site2site: deleting IPsec SA with SPI 9b2c926b
ike 0:nse-site2site:nse-site2site: deleted IPsec SA with SPI 9b2c926b, SA count: 0
ike 0:nse-site2site: sending SNMP tunnel DOWN trap for nse-site2site

ike 0: comes 7.1.1.64:500->7.1.1.58:500,ifindex=9....
ike 0: IKEv1 exchange=Quick id=d0bd16bd09180b08/5ccfeca6d776178a:660eb4d6 len=620
ike 0: in D0BD16BD09180B085CCFECA6D776178A08102001660EB4D60000026C38DCDB7D2A253D9A8F52EB594461EFBCD9931CA732D3EBA653388F9C622161C399E5770BA086F4630C3C0F56481ACF72A777E5E388AD6922379988A70EAFD720DF2D649DA6AEAF4090188439F7864DE942D62718691CEA05EBC45323F071B8DB94E93A860681623EE590A211458A4D5FCB4F7E67AEBE12BC8E55E416F06D407DC3E7DA037CC7C665B0A21A2BA381BE21C8719C1864F85948698C6C84CAE2C29A5CEE1F19C769D251EE7FCE29F2492D24C80E6688F60F571AE4D6BAA9F43A826B82C343B0C9018F7FACB4AC93D726053030791B30866C5B611E56468F592F5F4FD17A27962F04454A9FDEBAB7CF9BDC4A2C89830A9EA6A45D954C2070A1A4056ADA86EF045CBBEF4303802F826CA1D6DDC00E01270C46B3854472655A9DBAE8031325831B860594F5D6A16D161BF837079836E82F4B805CFB30BA0BF8AB06F53709FD83962DF54E8531DE6BF6EF05D113DFC46E967EE4EB802F073408BE8CCF3E1B4B76276CBD6DD877CB1C0F09263C4E319FFCA6AE8248148B7D387C32E90DF65E8C62A2AE47D41103720D6E9D702947ACB7EE4E28A051ED41D83CC605D1A0161BF0E62B3A377BC95613DFC59D4C2674A0D12271C78851917ABE39D960B5CF396ACAA270D0B61E43456EEDD30B65E7460B7D761E3469088C6408C96CCAF0C5AD1605C4D295121ED9D21225E2F4226127E5D99E2FAC085C77486BD601AB1C0C2BA9ED06E0EE878A499975909D49B93F2501C4BA76620758A84F3BC493FF48B779B1F3BBE70610B26A4C64563C8A89FF1E80A37707740C71A4B416E8C627E0F1501E75ADB3505049F4B47A53487499CE37
ike 0:nse-site2site:16:9: responder received first quick-mode message
ike 0:nse-site2site:16: dec D0BD16BD09180B085CCFECA6D776178A08102001660EB4D60000026C01000024541B7D0B50675DFF45F1B10F9A5DC7F50F07089449113A528AAF3EE007DD4CB90A0000EC0000000100000001000000E0010304079B2C926C03000020010C0000800100018002A8C08004000180060080800500028003000E03000020020C0000800100018002A8C08004000180060100800500028003000E03000020030C0000800100018002A8C08004000180060080800500058003000E03000020040C0000800100018002A8C08004000180060100800500058003000E0300001C05140000800100018002A8C080040001800600808003000E0300001C06140000800100018002A8C080040001800601008003000E0000001C071C0000800100018002A8C080040001800601008003000E0400001427FE2813F15FC41812577947DC0B5C15050001049A8E87AC9CF9C42820A5CCB5D7FEB32B90A9BA9F4672469D47837121910A716D207D788EA069CA05F8A725F16D604B8AB7AD4D954A27AC5CB9429F5BABB298B03D4F752081AFE09A737F1EF653ED6552261F5A028198E94C478D0C2964666E481EC20C3B6D6A9006F4BC38F36F8AEA531F01CA54D9C3EA5EE4FAA0B5B825449FE52D3C4DE52526D26C50AAF4B3BD89E0916923A86AFA1CEF4B834CB8EFB64D4AB97CE8092B6B0BBADE6B18CBB6A8671226AE83B57756C9A747509142519D4CB3C084352A8E861B6C3A95FEACBE5CE6F08D17162517F0DB8D23497DCC00544982D8CE459762ED4097F8F2CC51C4D536CA88CB537A4BC84406E2354712BF31C7BC0500001004000000000000000000000000000010040000000000000000000000A19D7FCEE7D70407
ike 0:nse-site2site:16:9: peer proposal is: peer:0:0.0.0.0-255.255.255.255:0, me:0:0.0.0.0-255.255.255.255:0
ike 0:nse-site2site:16:nse-site2site:9: trying
ike 0:nse-site2site:16:nse-site2site:9: matched phase2
ike 0:nse-site2site:16:nse-site2site:9: autokey
ike 0:nse-site2site:16:nse-site2site:9: my proposal:
ike 0:nse-site2site:16:nse-site2site:9: proposal id = 1:
ike 0:nse-site2site:16:nse-site2site:9:   protocol id = IPSEC_ESP:
ike 0:nse-site2site:16:nse-site2site:9:   PFS DH group = 14
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA1
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA1
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA2_256
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA2_256
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_GCM_16 (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=NULL
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_GCM_16 (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=NULL
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_CHACHA20_POLY1305 (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=NULL
ike 0:nse-site2site:16:nse-site2site:9: proposal id = 2:
ike 0:nse-site2site:16:nse-site2site:9:   protocol id = IPSEC_ESP:
ike 0:nse-site2site:16:nse-site2site:9:   PFS DH group = 5
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA1
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA1
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA2_256
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA2_256
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_GCM_16 (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=NULL
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_GCM_16 (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=NULL
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_CHACHA20_POLY1305 (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=NULL
ike 0:nse-site2site:16:nse-site2site:9: incoming proposal:
ike 0:nse-site2site:16:nse-site2site:9: proposal id = 1:
ike 0:nse-site2site:16:nse-site2site:9:   protocol id = IPSEC_ESP:
ike 0:nse-site2site:16:nse-site2site:9:   PFS DH group = 14
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA1
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA1
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA2_256
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA2_256
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_GCM_16 (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=NULL
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_GCM_16 (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=NULL
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_CHACHA20_POLY1305 (key_len = 256)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=NULL
ike 0:nse-site2site:16:nse-site2site:9: negotiation result
ike 0:nse-site2site:16:nse-site2site:9: proposal id = 1:
ike 0:nse-site2site:16:nse-site2site:9:   protocol id = IPSEC_ESP:
ike 0:nse-site2site:16:nse-site2site:9:   PFS DH group = 14
ike 0:nse-site2site:16:nse-site2site:9:      trans_id = ESP_AES_CBC (key_len = 128)
ike 0:nse-site2site:16:nse-site2site:9:      encapsulation = ENCAPSULATION_MODE_TUNNEL
ike 0:nse-site2site:16:nse-site2site:9:         type = AUTH_ALG, val=SHA1
ike 0:nse-site2site:16:nse-site2site:9: set pfs=MODP2048
ike 0:nse-site2site:16:nse-site2site:9: using tunnel mode.
ike 0:nse-site2site: schedule auto-negotiate
ike 0:nse-site2site:16:nse-site2site:9: replay protection enabled
ike 0:nse-site2site:16:nse-site2site:9: SA life soft seconds=42931.
ike 0:nse-site2site:16:nse-site2site:9: SA life hard seconds=43200.
ike 0:nse-site2site:16:nse-site2site:9: IPsec SA selectors #src=1 #dst=1
ike 0:nse-site2site:16:nse-site2site:9: src 0 4 0:0.0.0.0/0.0.0.0:0
ike 0:nse-site2site:16:nse-site2site:9: dst 0 4 0:0.0.0.0/0.0.0.0:0
ike 0:nse-site2site:16:nse-site2site:9: add IPsec SA: SPIs=bbef25bf/9b2c926c
ike 0:nse-site2site:16:nse-site2site:9: IPsec SA dec spi bbef25bf key 16:1FF477D7A6DA97DEC737B310AB977B24 auth 20:29F5C0EE6AB004C969EE6DAA46F3D909847F229D
ike 0:nse-site2site:16:nse-site2site:9: IPsec SA enc spi 9b2c926c key 16:0108724F5CE91B72EDCFE927A7F28BA4 auth 20:51C9E0DAAACDDFE2CDF89504A9AE0D78D14ED3A1
ike 0:nse-site2site:16:nse-site2site:9: added IPsec SA: SPIs=bbef25bf/9b2c926c
ike 0:nse-site2site:16:nse-site2site:9: sending SNMP tunnel UP trap
ike 0:nse-site2site:16: enc D0BD16BD09180B085CCFECA6D776178A08102001660EB4D6000001B001000024B9B395282AEBE59C554DE9F74F098EEE0904531C8D3DF8CA8979F0DBECD45E4F0A00003800000001000000010000002C01030401BBEF25BF00000020010C0000800100018002A8C08004000180060080800500028003000E040000144BF877817E37C446B16667242D88FD5505000104BF750AA7BA5F13664735A4E06F310E7B1297C99033334C50BADD4B6C3EAF5F737A6AF23900C10A90C0DBF6BB7CE50AACD4B995935F6843483F85F0FC2486701757863FE07694A960B831F70663C4780D8766F4D883ABABE78DC09875EA067DA1BD4F34A0098373965D2869DC8B50188CD947CFB77B5B0C96CFC4C1330266192130D50E713AE753177BADB20C9F900F68AF0BBE79FE4A6B2E7284EAC0C6D26B72EF67A130CCF9C60A8BDA483ED29DD6F88BB106A1529A394E0D0945C585A37171C0BBF62D1AD1B59148B9E21B5AA732C8DD87629998FB83CF7926EF2360DCD9BD307F796D0E54F7AA67974AEE7DE395E02F31E6DC716622096EEFBDC0FD7009790500001004000000000000000000000000000010040000000000000000000000
ike 0:nse-site2site:16: out D0BD16BD09180B085CCFECA6D776178A08102001660EB4D6000001BC35A0D0E91C025589A2E711CF74F2B5D0C61C4300AFBAD334D6245F663BE12D4FC83FDF26549F796168F22DC2A25D6650E4D56DE4E0B82DD4582683D5985EE379887BBA9F5C852AD5D1C9B7C67DC968B63D98853BF527AE1B03C6356069B029289AEA73C056500297CF1FC6C4502831A836415532EA5113967ED7733F212759C095213E41E027ADB06996409EBFB8D865906D6484ED611EC6B366C48704402882245D8F92E3F0DBE8F593D61BD3409C30B255B6803E582FD0D4A1F6852CAC3379E79BDDBCD69CC49EC0947F8D9A26AF40E577201B0982517F55E58F8512ED43B6EFC4E90EC79398F448CF61CF527F63CE9E245CA26269989EFAB1310D62010829905FCB2DCCD0BAECADAFCB0C011CE0F2ABD59C27C3DA2ECD4133C4252AA644EA3F57DA8E0F5B072005B550DBAEE45321D11492FE36D63D495EF9F979FE4A8CE0842727F41A9800E332E51B35295ED0D0416393E459B839CC138D3E91C9B82F5A388D5A37C774EEC555CDE6F788EEBCEAA2F07C8CB42AFEE60E5E7D32A459898336758686C942E908EABB47172E05C983A35E062B50AC262087BEDE4482C4FEEF
ike 0:nse-site2site:16: sent IKE msg (quick_r1send): 7.1.1.58:500->7.1.1.64:500, len=444, id=d0bd16bd09180b08/5ccfeca6d776178a:660eb4d6
ike 0: comes 7.1.1.64:500->7.1.1.58:500,ifindex=9....
ike 0: IKEv1 exchange=Quick id=d0bd16bd09180b08/5ccfeca6d776178a:660eb4d6 len=76
ike 0: in D0BD16BD09180B085CCFECA6D776178A08102001660EB4D60000004C4B0F627546EF7746DAF77BF23BDCA0447566B3071475CA2E393ACA0D88AEDFA7F0C1A41FBF1E1BD6895230357D38BD53
ike 0:nse-site2site:16: dec D0BD16BD09180B085CCFECA6D776178A08102001660EB4D60000004C00000024DD9E6BEFE2F915E4AB8C4415C7878B18B7058A15FB56FD6F7E1735CFD2047AD523006EC98D795CEA11E6E90B
ike 0:nse-site2site:nse-site2site:9: send SA_DONE SPI 0x9b2c926c


0823 


 d firewall  proute list  ---> Policy Route 


https://www.oprahmag.com/life/relationships-love/a28552003/i-hate-my-wife/ 
set wad-source-affinity {enable | disable}

Modifies the wad-worker balancing algorithm to also use the source port in addition to source IP when distributing the client to a specific WAD daemon. With this in place, even the connections from one IP address will be balanced over all the WAD processes.

0822

IKE offload: by ipsec tun list --> npu_flag  00 no , 03 both ( ingress+engress)  02 ingress, 01 egress 
SSL VPN  HW acceleration: offload:  fw -policy  set auto-asic offload: en/dis 



https://www.itexams.com/exam/NSE4-FGT-6.0 

Login script: for large scale 
PAC: Proxy Auto Config 
WPAD:  Web proxy Auto Discovery : DNS/DHCP for pac file 
--DHCP: browser send DHCPINFORM query to get the URL 
--DNS: browser resolve wapd.<local-domain> to get the ip of server host pac file 

FGVM02TM19001723 # sh sys dhcp server
config system dhcp server
    edit 1
        set dns-service default
        set default-gateway <<SUBNET>>.58
        set netmask 255.255.255.0
        set interface "port1"
        config ip-range
          .....
        end
        set timezone-option default
        config options
            edit 1
                set code 252           ===> for DHCP WPAD 
                set type string
                set value "http://<<SUBNET>>.58/proxy.pac"
            next
        end
    next


=====DLP

FGVM02TM19001724 # sh dlp sensor 570379-file-name-trim
config dlp sensor
    edit "570379-file-name-trim"
        config filter
            edit 1
                set proto smtp pop3 imap http-get http-post ftp
                set filter-by file-type
                set file-type 3
                set action log-only
            next
            edit 2
                set proto smtp pop3 imap http-get http-post ftp
                set filter-by file-type
                set file-type 5
                set action log-only
            next
  ....
  FGVM02TM19001724 # sh dlp filepattern
*id    ID.
1  builtin-patterns
2  all_executables
3  DLP Test3
4  file-name-encoder
5  570379-file-name-trim5

FGVM02TM19001724 # sh dlp filepattern  3
config dlp filepattern
    edit 3
        set name "DLP Test3"
        config entries
            edit "msoffice"
                set filter-type type
                set file-type msoffice
            next
            edit "msofficex"
                set filter-type type
                set file-type msofficex
            next
            edit "pdf"
                set filter-type type
                set file-type pdf
            next
            edit "bat"
                set filter-type type
                set file-type bat
            next
        end
    next
end

0821 
IPS is not a set-and-forgot implimentation 

ESP dose not support NAT as itr does not have port# 
If NAT-T enabled, it's over UDP 4500 

config ips global
    set fail-open enable   ==> when no buffer, traffic going through.

diag log test 

IKE:
ph-1: =main mode ( vs aggressive mode 3 msgs exchanged)
ph-2: = quick mode 

In dial-up, clientIP is dynamic and FGT can not connect to client ( only client can init ..)
CP: Content processor  
NP: Network Processor  NTurbo 
SoC3: System-on-a-Chip Processor (SOC3)  

diag hardware test 

FG3H1E5818900427 # get hardware status
Model name: FortiGate-301E
ASIC version: CP9              ===> CP 
ASIC SRAM: 64M
CPU: Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz
Number of CPUs: 4
RAM: 7980 MB
Compact Flash: 15331 MB /dev/sdc
Hard disk: 228936 MB /dev/sda
USB Flash: not available
Network Card chipset: Intel(R) Gigabit Ethernet Network Driver (rev.0003)
Network Card chipset: FortiASIC NP6 Adapter (rev.)     ===> NP 


0819
DomainName+URL :
Fortiguard: SDNS-Server IP: 
Block explicit results on Google using SafeSearch:

PCRE Regular expression: 



0814

nc -u host.example.com 53 < /dev/random

echo "GET HTTP/1.1 \r\n HOST:172.18.2.169"  |nc  -u -X 5 -x 172.18.43.33:1080  172.18.2.169 80 

echo "Command=Announce|Address=[2620:101:9005:1100::205]:443" |nc -u 2606:f900:8102:201::33 9443

johns@johns-virtual-machine:~$ echo "Command=Announce|Address=[2620:101:9005:1100::205]:443" |nc -6u 2606:f900:8102:201::33 9443

which IPsec configuration mode can be used for implementing GRE-over-IPsec VPNs?
A. Policy-based only.
B. Route-based only.

启发式算法（heuristicalgorithm)是相对于最优化算法提出的。一个问题的最优算法求得该问题每个实例的最优解。启发式算法可以这样定义：一个基于直观或经验构造的算法，在可接受的花费（指计算时间和空间）下给出待解决组合优化问题每一个实例的一个可行解，该可行解与最优解的偏离程度一般不能被预计

FG3H1E5818900427 (port9) # set device-identification enable

FG3H1E5818900427 (port9) # end

FG3H1E5818900427 # diag user device  list
hosts
  vd root/0  70:4c:a5:c7:a8:9d  gen 1  req OHUS/1e
    created 4s  gen 1  seen 0s  port9  gen 1
  vd root/0  50:9a:4c:17:ab:f8  gen 3  req OHUS/1e
    created 2s  gen 2  seen 0s  port9  gen 2
    ip 172.18.76.118  src ssdp
    hardware vendor 'Dell'  src mac  id  0
    os 'Windows'  src ssdp  id  69

FG3H1E5818900427 # diag autoupdate status
FDN availability:  available at Tue Aug 13 17:30:58 2019

Push update:       enable
Push availability: unavailable
Scheduled update: enable
        Update daily:   at 1 after 60 minutes
Virus definitions update: enable
IPS definitions update: enable
Push address override: disable
Web proxy tunneling: disable


	
{Sys Fortiguard}: almost for rating, with blow also impact udpate;
FG3H1E5818900427 (fortiguard) # set update-server-location
usa    FGD servers in United States.
any    FGD servers in any location.

FG3H1E5818900427 (fortiguard) # set source-ip(6) 



The av update secondary server is 192.168.100.205 and 
its ipv6 address is 2620:101:9005:1100::205.

User	Firewall outside address	Lan subnet
Aiyan Ma	2606:f900:8102:ffff::201	2606:f900:8102:201::59/64



FG3H1E5818900427 # sysctl killall updated 


0811

DNS entry type: 
-A ( AAA for v6),  
-NameServer (NS), 
-CNAME (Cononical Name): In programming, the term "canonical" means "according to the rules."
rove convenient when running multiple services from a single IP address
For example, the CNAME record allows “cloudwards.net” to fetch up “www.cloudwards.net” with the “www” in front.
-MX (mail exchange server)
-PTR ( v4/v6)
0809

PS: 1) need to enable deep-scan for https , otherwise has to triger http for auth first ...
2)  tp proxy, session based, cert scan, kerb auth, https can not put through.

Fortigate telemetry:

FortiClient EMS:(Enterprise Management Server) is a security management solution that enables scalable and centralized management of multiple endpoints (computers). FortiClient EMS provides efficient and effective administration of endpoints running FortiClient.


--- FGT automation 
config system automation-trigger
    edit "test-auto"
        set event-type config-change
    next
end
config system automation-action
    edit "test-auto_email"
        set action-type email
        set email-to "ama@fortinet.com"
        set email-subject "test"
    next
end
config system automation-stitch    ==> main 
    edit "test-auto"
        set trigger "test-auto" 
        set action "test-auto_email"
    next
end

Got the email: 
FGT[FG3H1E5818900427] Automation Stitch:test-auto is triggered.
date=2019-08-09 time=15:16:11 logid="0100032102" type="event" subtype="system" level="information" vd="root" eventtime=1565388973447564807 tz="-0700" logdesc="Configuration changed" user="admin" ui="GUI(<<SUBNET>>.99)" module="system" submodule="update" msg="admin made a change from GUI(<<SUBNET>>.99):Autoupdate settings have been changed" 

==== FDS 


1)IPS, App Control, AV, 
(TCP 443)
For Package update: ( AV and IPS)  update.forgigard.net  

2)WebFilter, Email filtering, DDNS. 
(UDP 53, 8888 or tcp 443 (newly added)
For living query   service.forgigard.net 
diag de rating ..

-->Verify the connection
1) exec ping service.fortiguard.net 
2) diag debug rating :

-->Update 

Manual update:  
 ( download db from website, using GUI: https://<<SUBNET>>.33/ng/system/fortiguard
Auto Update: 
-1) Schedule Update 
FGVM02TM19001724 # sh sys autoupdate schedule
config system autoupdate schedule
    set frequency weekly
    set time 01:00
    set day Sunday
end

-2) Push update 
config system autoupdate push-update
    set status disable
    set override disable
    set address 0.0.0.0
    set port 9443
end


Daemon
 exec update-now: 


update.fortiguard.net: (192.168.100.205) For AV and IPS updates.
service.fortiguard.net:(192.168.100.206) For web filtering and anti-spam updates.

system central-management  --> server-list 

FG3H1E5818900427 (2) # set server-type
update    AV, IPS, and AV-query update server.
rating    Web filter and anti-spam rating server.



To see if the service is visable, open the CLI console and enter the following commands:.

For Web Filtering:
diagnose debug rating    --->  Service/Status and server list 


=== diag 

For Anti-Spam:
diagnose spamfilter fortishield servers   ???

diagnose test update info

d test application  update  1 

# d test update term     ==> gracefull termanate updated

FG3H1E5818900427 # upd_daemon[1365]-Received termination request

diagnose debug application update 255
execute update-ase
execute update-av
execute update-ips

FGVM02TM19001724 # diagnose test application urlfilter 15   ( Sent INIT) 


FG3H1E5818900427 # sh sys dns-database
config system dns-database
    edit "fds-lab"
        set domain "fortiguard.net"
        set authoritative disable
        config dns-entry
            edit 1
                set hostname "update"
                set ip 192.168.100.205
            next


config system autoupdate push-update
    set status enable
    set override enable
    set address "192.168.100.80"
end

config system central-management
    config server-list
        edit 1
            set server-type update rating
            set addr-type ipv6
            set server-address6 2001::123
        next
        edit 2
            set server-type update update     
            set server-address <<SUBNET>>.1
        next
    end
    set include-default-servers disable
end


==== Diag 
#d autoupdate status 
#d test update info

Logs: idx=46
Thu Aug 15 15:30:26 2019 doInstallUpdatePackage

#d test app updated 1
2019-08-15 16:08:16 FDS List:
2019-08-15 16:08:16
2019-08-15 16:08:16 Local Server List:
2019-08-15 16:08:16     [2606:f900:8102:201::59]:8890 tz=128, type=4, stat=S, pkts=8, lost=0, weight=956744762, tmsp=1565908495


0807
Heuristic Scan : 

0806
swaks --server 172.16.200.56 --from emailuser1@qa.fortinet.com --to emailuser2@qa.fortinet.com --header "Subject: Bug Test" --body "Test" --attach /home/uploaduser/space\ file.docx 

The ABNF given in RFC 2047 for encoded-words is:
encoded-word := "=?" charset "?" encoding "?" encoded-text "?="
RFC 2184 changes this ABNF to:
encoded-word := "=?" charset ["*" language] "?" encoded-text "?="

### email server:   by iis-6: 
swaks --server <<SUBNET>>.124 --from u1@devqa.lab --to u2@devqa.lab --header "Subject: Bug Test" --body "Test" --attach  /etc/hosts 

0802

FGT: not suppport AH
IKE: NAT-T using UDP  4500, not 500 

boardcast strom and MAC flapping ---> Virtual Wire Paire

Automate troubleshooting to focus on fixing problems, not finding them

On high-end FortiGate models you can increase the number of VDOMs to 25, 50, 100, 250, or 500 by purchasing a license key from Fortinet. 
====
d test app urlfilter 15 

config system central-management
    set type fortimanager
    config server-list
        edit 1
            set server-type rating
            set server-address 172.18.37.149   --> FortiMGR server location.
        next
    end
    set include-default-servers disable    ---> if enable, will check fortiguard from dns 
end

FG3H1E5818900427 # d de rating
Locale       : english

Service      : Web-filter
Status       : Enable
License      : Contract

Service      : Antispam
Status       : Disable

Service      : Virus Outbreak Prevention
Status       : Disable

-=- Server List (Fri Aug  2 10:49:44 2019) -=-

IP                     Weight    RTT Flags  TZ    Packets  Curr Lost Total Lost             Updated Time
172.18.37.149               0      1         0          2          0          0 Fri Aug  2 10:49:33 2019
192.168.100.185 -> default 10      1 DI     -8          5          0          0 Fri Aug  2 10:49:33 2019



0801 
微服务架构 = 80% 的 SOA 服务架构思想 + 100% 的组件化架构思想 + 80% 的领域建模思想 

0731 

java-server: <<SUBNET>>.99 ( desktop-pc)
client: U1804-gm 184 (with eclispe+SuperClient)

C:\Users\john>curl -x <<SUBNET>>.33:8080 172.18.2.169 --proxy-user adu1:12345678 
asymmetric routing : disable support of stateful inspection ( unware of session and treat each packet individual 
enable distance, with link health monitor, to impliment route failover 
config system link-monitor
    edit "1"
        set srcintf "port1"
        set server "8.8.8.8"
        set protocol http
        set update-static-route disable
    next


net user Tom P@ssword123 /domain  ## not working..
#d ip route list
#get router info routing-table all

RPF: Reverse Path Forwading,to avoid ip address spoof 
( check if there is route back to the packet source. on the first packet of any new session or route change)

Routing table for VRF=0
Codes: K - kernel, C - connected, S - static, R - RIP, B - BGP
       O - OSPF, IA - OSPF inter area
       N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
       E1 - OSPF external type 1, E2 - OSPF external type 2
       i - IS-IS, L1 - IS-IS level-1, L2 - IS-IS level-2, ia - IS-IS inter area
       * - candidate default

S*      0.0.0.0/0 [10/0] via <<SUBNET>>.1, port1
                  [10/0] is a summary, Null
C       7.1.1.0/24 is directly connected, port7
C       <<SUBNET>>.0/24 is directly connected, port1
C       172.20.51.0/24 is directly connected, port2
 

0725
 mantis for me to try; https://mantis.fortinet.com/bug_view_page.php?bug_id=0572133 

Dispatching traffic to WAD worker based on source affinity
The wad-worker balancing algorithm supports a more balanced dispersal of traffic to the wad processes even, if the bulk of the traffic is coming from a small set of, or single source.

By default, dispatching traffic to WAD workers is based on source affinity. This may negatively affect performance when users have another explicit proxy in front of the FortiGate. Source affinity causes the FortiGate to process the traffic as if it originated from the single (or small set of ) ip address of the outside proxy. This results in the use of one, or a small number, of WAD processes.

By disabling wad-source-affinity the traffic is balanced over all of the WAD processes. When the wad-source-affinity is disabled, the WAD dispatcher will not assign the traffic based on the source IP, but will assign the traffic to available workers in a round-robin fashion.

caution icon	
Handling the traffic by different WAD workers results in losing some of the benefits of using source affinity, as is explained by the warning message that appears when it is disabled:

"WARNING: Disabling this option results in some features to be unsupported. IP-based user authentication, disclaimer messages, security profile override, authentication cookies, MAPI scanning, and some video caches such as YouTube are not supported.

Do you want to continue? (y/n)"


0724
If no ssl-server in wonopt-server side: 
ad_tunnel_msg_read_header(4296): tunnel=0x7fddf8136660 cmd = 26
wad_tunnel_check_policy(2846): tunnel check policy 0x7fddfa97a6f0 out_if=17 7.1.1.164:60022 -> <<SUBNET>>.216:443
wad_tunnel_msg_on_ssl_handshake(4161): made tunnel port: tp=0x7fddf80ec1d0 proto=1 shared=0 remote-sid=99952800 sid=273225441
wad_ssl_port_open(18412): making SSL port type=0 port=0x7fddf80ec1d0
__wad_ssl_server_get_by_addr(87): searching SSL server vd=0 svr=<<SUBNET>>.216:443
wad_ssl_port_open(18483): failed to find SSL server for vd=0 svr=<<SUBNET>>.216:443
wad_ssl_port_close(18306): sp=0x7fddf809e050/0 state=0, half=0
wad_tunnel_msg_on_ssl_handshake(4175): make SSL server handshaker failed
0723
$repl_account = Get-ADReplAccount -Domain $Domain -Server $DomainController -Credential $admincred -SamAccountName "$CompName$"
$krb_keys = $repl_account.SupplementalCredentials.KerberosNew.Credentials
PS C:\keytab_generator_script> .\GrabADCreds.ps1 -CompName smb-ubuntu
 mmm: $repl_account DSInternals.Common.Data.DSAccount
 mmm: $krb_keys keys: Type: AES256_CTS_HMAC_SHA1_96, Iterations: 4096, Key: 7ce9222a9fa504b1ad593b42fecbe498a16a83dba4336ee957ac9dbd594441ac Type: AES128_CTS_HMAC_SHA1_96, Iterations: 4096, Key: 2527c3b86e63fd2f4c83baa32be8741c Type: DES_CBC_MD5, Iterations: 4096, Key: 4c26e319520d3192
host/smb-ubuntu@SMB2016

=== FSSO 

FGVM02TM19001724 # d wad u l

ID: 766, IP: <<SUBNET>>.101, VDOM: root
  user name   : AU1
  duration    : 7
  auth_type   : 1
  auth_method : 5
  pol_id      : 1
  g_id        : 2
  user_based  : 0
  expire      : no
  LAN:
    bytes_in=9400 bytes_out=20571
  WAN:
    bytes_in=21172 bytes_out=7758

FGVM02TM19001724 # d firewall  auth  list

<<SUBNET>>.101, AU1
        type: fsso, id: 0, duration: 9018, idled: 9018
        server: fsso-166
        packets: in 0 out 0, bytes: in 0 out 0
        group_id: 2
        group_name: fsso_grp

----- 1 listed, 0 filtered ------


FGVM02TM19001724 # d de authd fsso list
----FSSO logons----
IP: <<SUBNET>>.101  User: AU1  Groups: CN=AU1,CN=USERS,DC=DEVQA,DC=LAB+CN=USERS,DC=DEVQA,DC=LAB+CN=DOMAIN USERS,CN=USERS,DC=DEVQA,DC=LAB+CN=ADMINISTRATORS,CN=BUILTIN,DC=DEVQA,DC=LAB+CN=REMOTE DESKTOP USERS,CN=BUILTIN,DC=DEVQA,DC=LAB+CN=USERS,CN=BUILTIN,DC=DEVQA,DC=LAB  Workstation: <<SUBNET>>.101 MemberOf: fsso_grp
Total number of logons listed: 1, filtered: 0
----end of FSSO logons----



0719
 d sniffer  packet  any 'tcp[13]&2==2 and port 443' 4 

 eap_proxy 
FG3H1E5818900427 # sh sys global
config system global
    set admin-console-timeout 300
   ...
    set wifi-ca-certificate "Fortinet_CA"
    set wifi-certificate "aiyan3"

 
 

C:\opt\curl\bin>curl -x 7.1.1.33:8080 -H "test: test"  https://www.google.com -v
  -U adu1:12345678
*   Trying 7.1.1.33...
* TCP_NODELAY set
* Connected to 7.1.1.33 (7.1.1.33) port 8080 (#0)
* allocate connect buffer!
* Establish HTTP proxy tunnel to www.google.com:443
* Proxy auth using Basic with user 'adu1'
> CONNECT www.google.com:443 HTTP/1.1
> Host: www.google.com:443
> Proxy-Authorization: Basic YWR1MToxMjM0NTY3OA==
> User-Agent: curl/7.63.0
> Proxy-Connection: Keep-Alive
>
< HTTP/1.1 200 Connection established
< Proxy-Agent: Fortinet-Proxy/1.0
<
* Proxy replied 200 to CONNECT request
* CONNECT phase completed!
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: C:\opt\curl\bin\curl-ca-bundle.crt
  CApath: none
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* CONNECT phase completed!
* CONNECT phase completed!
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (OUT), TLS alert, unknown CA (560):
* SSL certificate problem: self signed certificate in certificate chain
* Closing connection 0
curl: (60) SSL certificate problem: self signed certificate in certificate chain
0717
wiundows:  systeminfo 


43.34 -->  build: 0930  web-explicit kerbooer auth, cifs, user info 


0715:

 set cfg-save revert
    set hostname "test"
    set management-vdom "vdom1"
    set switch-controller enable
    set timezone 04
    set vdom-mode multi-vdom
    set cfg-revert-timeout 20



SMB:
NTLM and the older LAN Manager (LM) encryption are supported by Microsoft SMB Protocol. Both encryption methods use challenge-response authentication, where the server sends the client a random string and the client returns a computed response string that proves the client has sufficient credentials for access.

Exchange: 
e following steps are an overview of the process:

The client and server establish a NetBIOS session.
The client and server negotiate the Microsoft SMB Protocol dialect.
The client logs on to the server.
The client connects to a share on the server.
The client opens a file on the share.
The client reads from the file.

<73> Section 3.1.3: By default, Windows-based servers set the RequireMessageSigning value to TRUE for domain controllers and FALSE for all other machines.

<74> Section 3.1.3: Windows 8 and later and Windows Server 2012 and later set IsEncryptionSupported to TRUE.

<75> Section 3.1.3: Windows 10 v1903 operating system and later and Windows Server v1903 operating system and later set IsCompressionSupported to TRUE.

check sync issue:  

when 
DC    FGT   BLK
1-8   1-8    ok
1-4   1-8    ok  ?


0712:
IPS fail-open ( when IPS socke buffer is full and new packet can't be appended for inspection )
conf ips global --> set fail-open en/dis , if enable, new packet pass through, if disable, drop .)

Update.fortiguard.net --> IPS get update .. 




0709


Ticket Grant Ticket : 
The security principal name used by the KDC in any domain is "krbtgt", as specified by RFC 4120. An account for this security principal is created automatically when a new domain is created. The account cannot be deleted, nor can the name be changed. A random password value is assigned to the account automatically by the system during the creation of the domain. The password for the KDC's account is used to derive a cryptographic key for encrypting and decrypting the TGTs that it issues. The password for a domain trust account is used to derive an inter-realm key for encrypting referral tickets.

0704 
wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz

wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin 

install 
install:

    $ curl -s -L -o /bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
    $ curl -s -L -o /bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
    $ curl -s -L -o /bin/cfssl-certinfo https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
    $ chmod +x /bin/cfssl*



ip route del 172.16.0.0/24 via 192.168.122.1 dev ens3
ip route show 

0703 

C:\Users\john>curl http://120.27.68.214:8080/ejbca/ejbcaws/ejbcaws?wsdl -k 


Generate CA key & certificate :
openssl genrsa -out ANrootCA.key 2048
openssl req -x509 -new -nodes -key ANrootCA.key -sha256 -days 1024 -out ANrootCA.pem

#Generate client key & certificate signing request 
openssl genrsa -out MyClient1.key 2048
openssl req -new -key MyClient1.key -out MyClient1.csr     

#Generate client certificate based on our own CA certificate
openssl x509 -req -in MyClient1.csr -CA ANrootCA.pem -CAkey ANrootCA.key -CAcreateserial -out MyClient1.pem -days 1024 -sha256

# openssl x509 -req    -days 1024 -in self.csr -signkey self.key -sha256 -out self.pem

[root@iZm5efkb6pplha8x1bystzZ ANCA]# openssl x509 -req -in MyClient1.csr -CA ANrootCA.pem -CAkey ANrootCA.key -CAcreateserial -out MyClient1.pem -days 1024 -sha256
Signature ok
subject=C = CN, ST = BJ, L = HAIDIAN, O = AN Corp. Ltd, OU = RND, CN = MyClient1, emailAddress = client1@anroot.com
Getting CA Private Key



0702 

Industry scope: EA 19.1, NACE 1993 30, EA 33.2, NACE 1993 72.6
Fortigate certificate: ISO9001 

19 Electrical and Optical Equipment DL
High-risk NACE codes are labeled based on technically complex processes
(manufacturing and design) with-in the specific NACE codes.
Manufacture of office machinery and computers DL 30.0 


PS C:\share\keytab_generator_script> Get-ADComputer -Filter *
PS C:\share\keytab_generator_script> Expand-Archive .\DSInternals_v3.5.zip 

PS C:\share\keytab_generator_script\DSInternals_v3.5> Import-Module .\DSInternals\DSInternals
PS C:\share\keytab_generator_script\DSInternals_v3.5> Get-ADReplAccount
>> ^C
PS C:\share\keytab_generator_script\DSInternals_v3.5> Remove-Module DSInternals
PS C:\share\keytab_generator_script\DSInternals_v3.0> Get-Module
PS C:\share\keytab_generator_script\DSInternals_v3.0> Import-Module .\DSInternals\DSInternals
PS C:\share\keytab_generator_script\DSInternals_v3.0> Get-ADReplAccount -Domain $env:USERDOMAIN


> Set-ExecutionPolicy -ExecutionPolicy Unrestricted


0628 
aiyan@kali:~$ smbmap -H <<SUBNET>>.216 -u smbreplicate  -p 12345678 -d smb2016.lab -R

# fsutil file createnew 1.txt 10000000000   ==>10G 
/tmp # dd if=/dev/random of=300m count=300 bs=1M

4. Mount the Disk C on the server to the client host.
5. Run the command on the client (from the folder diskspd.exe is located)
#.\diskspd -d15 -F1 -w0 -r -b4k -o10 \\192.168.1.2\C\Server1\1.txt 

0625 


201906@Fortinet
Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Account Policies -> Password Policy,
#gpupdate /force 

edit "ldap166"
     ....
        set username "cn=ldapadmin,cn=users,dc=devqa,dc=lab"



0621


FG3H1E5818900427 # d sys virtual-wan-link  member
Member(1): interface: port9, gateway: 204.50.6.65, priority: 0, weight: 0
  Config volume ratio: 1, last reading: 61523639B, volume room 0MB
Member(2): interface: mgmt, gateway: <<SUBNET>>.1, priority: 0, weight: 71
  Config volume ratio: 90, last reading: 109048835B, volume room 71MB

  

user principalname
ldifde /f keytab_user.ldf /d "CN=Keytab User,OU=UserAccounts,DC=contoso,DC=corp,DC=microsoft,DC=com" /p base /l samaccountname,userprincipalname

diagnose sys virtual-wan-link member 

0620



204.50.6.87/255.255.255.224
set gateway 204.50.6.65
        set device "port9"

sys.global--> set vdom-admin enable


PS C:\Users\Administrator> ktpass /out adu1.keytab /princ http/adu1@DEVQA.LAB /mapuser adu1 /crypto AES256-SHA1 /ptype K
RB5_NT_PRINCIPAL /pass 12345678
Targeting domain controller: WIN-2012.devqa.lab
Using legacy password setting method
Successfully mapped http/adu1 to adu1.
Key created.
Output keytab to adu1.keytab:
Keytab version: 0x502
keysize 70 http/adu1@DEVQA.LAB ptype 1 (KRB5_NT_PRINCIPAL) vno 3 etype 0x12 (AES256-SHA1) keylength 32 (0x71439b7eb04515
03a76b161324e11c3fa000b692cac9b81fdc41cbb57d1794c7)



set principal "http/fgt34.devqa.lab@DEVQA.LAB"
BQIAAAA5AAIACURFVlFBLkxBQgAEaHR0cAAPZmd0MzQuZGV2cWEubGFiAAAAAQAAAAAKAAEACC89XWuSIOwyAAAAOQACAAlERVZRQS5MQUIABGh0dHAAD2ZndDM0LmRldnFhLmxhYgAAAAEAAAAACgADAAgvPV1rkiDsMgAAAEEAAgAJREVWUUEuTEFCAARodHRwAA9mZ3QzNC5kZXZxYS5sYWIAAAABAAAAAAoAFwAQJZdFyxI6UqouaTqqzKLbUgAAAFEAAgAJREVWUUEuTEFCAARodHRwAA9mZ3QzNC5kZXZxYS5sYWIAAAABAAAAAAoAEgAgla8Uw7RL+h+v/IIsa7sq/SrxXkCW18RHSMViX7xAK0QAAABBAAIACURFVlFBLkxBQgAEaHR0cAAPZmd0MzQuZGV2cWEubGFiAAAAAQAAAAAKABEAEBYajv3HS2kxjZaph443Exo=


0619:
Ma Foi 
openssl s_client -connect theservername:443 -msg -debug 
0618

# diag sys kill 11 21862   --->  send 11 to pid 21862
Signal <11> was sent to process <21855> by user <RadiusUser>

diag 156  fast match

For fortitester 
curl -d'{"name":"<username>":"password":"<user password>")' -c cookies.txt -H "Content-Type: application/json" http://10.220.64/api/user/login
curl -b cookies.txt http://10.220.64.6/api/case/test2/rerun 


0613 
diag debug enable
diag debug flow filter add <PC1>    or    diag debug flow filter add <PC2>
diag debug flow show console enable
diag debug flow trace start 100          <== this will display 100 packets for this flow
diag debug enable
 
 d de console timestamp enable

 smbclient //smb-ubuntu.smb2016.lab/share -m SMB3 -k -e    < -k|--kerberos >  only useful in an Active Directory environment. 
 smb@smb-vm:~$ smbclient //smb-ubuntu.smb2016.lab/share -m SMB3  -e  -W smb2016 -U u2 12345678 
 smbclient //www.example.com/myshare -U hnelson -W EXAMPLE.COM -R host -k -d 3  
 smbclient -t 10 //172.16.200.44/share1 -U Server:Username%Server:Password -c "cd sample; lcd /tmp; get clean1"    
 smbclient -t 10 //<<SUBNET>>.216\share -W smb2016 -U u2:12345678 -c " lcd /tmp; get loop.bat "
 smbclient //.. -W <workgroup> -U  ( user)  -c "cd sample; lcd /tmp; get clean1" 
  
 smbclient //<<SUBNET>>.216/share -W smb2016 -U u2 12345678 -c " lcd /tmp; get loop.bat"
  
  
 
SUMMARY:
When I ship Juniper equipment internationally, the carrier forms require a CCATS number. What does CCATS stand for, what is it and how do I obtain one?
SOLUTION:
CCATS stands for: Commodity Classification Automated Tracking System
 
0612

OFTP - Optimized Fabric Transfer Protocol:  Optimized Fabric Transfer Protocol (OFTP) is used when information is synchronized between FortiAnalyzer and FortiGate. Remote logging and archiving can be configured on the FortiGate to send logs to a FortiAnalyzer (and/or FortiManager) unit.

OFTP listens on ports TCP/514 and UDP/514.
diag log test 

FG100D3G14819995 # d log kernel-stats
fgtlog: 2
fgtlog 0: total-log=783, failed-log=0 log-in-queue=0
fgtlog 1: total-log=324, failed-log=0 log-in-queue=0

FG100D3G14819995 # d test application miglogd  6
mem=848, disk=752, alert=0, alarm=0, sys=0, faz=0, webt=0, fds=0
interface-missed=0
Queues in all miglogds: cur:0  total-so-far:0



0610: 
https://www.aventra.fi/front-page/ 

route add  <<SUBNET>>.2 mask 


1
$ sudo ip route del 172.16.0.0/24 via 192.168.122.1 dev ens3

0608

usermod -aG sudo username
usermode -aG wheel aiyan 


easypki: google by go, 
vm122: 

SimpleAuthority:  tools for  certs 

WebServiceRA ( Ejbra..) .jar 


0607

su 237 job 11 request info:
su 237 job 11   client 10.1.1.101:61594 server <<SUBNET>>.216:445
su 237 job 11   object_name 'notes.txt'
su 237 enable databases 07 (core mmdb extended)
su 237 cifs: beginning Filefilter file scan
su 237 scan file 'notes.txt' bytes 2335
su 237 AV engine file info results for '(null)'
su 237     state: 1 ftypeCount: 0 encrypted: 0
su 237     scanunit filtype:    0 : unknown
su 237     engine file-types: 0
su 237 file_filter match: 'NONE' d 1 p 16
su 237 scan return status 0
su 237 cifs: finished file scan
su 237 not wanted for analytics: analytics submission is disabled (m 0 r 0)
su 237 job 11 send result
su 237 job 11 close
su 237 job 12 open
su 237 req vfid 0 id 12 ep 0 new request, size 113, policy id 1, policy type 0
su 237 req vfid 0 id 12 ep 0 received; ack 12, data type: 2
su 237 job 12 request info:
su 237 job 12   client 10.1.1.101:61594 server <<SUBNET>>.216:445
su 237 job 12   object_name 'admin-interface.bat'
su 237 enable databases 07 (core mmdb extended)
su 237 cifs: beginning Filefilter file scan
su 237 scan file 'admin-interface.bat' bytes 113
su 237 AV engine file info results for 'admin-interface.bat'
su 237     state: 3 ftypeCount: 1 encrypted: 0
su 237     scanunit filtype:   -1 : [UNKNOWN]
su 237     engine file-types: 1
su 237        0 =>    5 : bat
su 237 file_filter match: '1' ft 5 d 1 p 16
su 237 scan return status 0
su 237 cifs: finished file scan
su 237 not wanted for analytics: analytics submission is disabled (m 0 r 0)
su 237 report FILE_FILTER infection priority 1
su 237 insert infection FILE_FILTER SUCCEEDED loc (nil) off 0 sz 0 at index 0 total infections 1 error 0
su 237 job 12 send result
su 237 job 12 close



0606

https://www.alienvault-demo-usm-anywhere.com/#/dashboard/ 
User Name:	user@alienvault.com
Password:	AVDemo2016!


disable client cert auth, 
>JBWEB000124: The requested resource is not available.

curl -X GET "https://localhost/ejbca/ejbca-rest-api/v1/ca"
JBWEB000124: The requested resource is not available.


 keytool -list  -
 
 Administrator Web > System Configuration > Protocol Configuration and select Enable for REST. ???
 
d sys kill 
d sys top   
Run Time:  0 days, 0 hours and 31 minutes
1U, 0N, 0S, 99I, 0WA, 0HI, 0SI, 0ST; 3039T, 1886F
             wad      180      R       4.5     0.7
3039T: Memory
1886F Free
4.5 CPU %
0.7 meme 
 

Fortigate_internet # d de application  update -1
Debug messages will be on for 30 minutes.

Fortigate_internet # d de en

Fortigate_internet # exec update-now

Fortigate_internet # upd_daemon[1264]-Received update now request
do_update[398]-Starting now UPDATE (final try)
upd_comm_connect_fds[429]-Trying FDS 192.168.100.205:443
tcp_connect_fds[254]-Failed connecting after sock writable
upd_comm_connect_fds[443]-Failed TCP connect
upd_comm_connect_fds[429]-Trying FDS 192.168.100.205:443
tcp_connect_fds[254]-Failed connecting after sock writable
upd_comm_connect_fds[443]-Failed TCP connect
do_update[410]-UPDATE failed

0605

If you are using OpenSSL 1.1.0 or earlier version, use openssl s_client -connect $ip:$port, and OpenSSL wouldn't enable the SNI extension
If you are using OpenSSL 1.1.1, you need add -noservername flag to openssl s_client.
openssl s_client -connect domain.com:443 command serves very well to test SSL connection from client side. It doesn't support SNI by default. You can append -servername domain.com argument to enable SNI.

curl https://120.27.68.214:8443/ejbca/ejbca-rest-api/v1/ca/status -k --cert ./superadmin.p12 --cert-type p12 --pass ejb

curl https://localhost:8443/ejbca/ejbca-rest-api/v1/ca/status -k --cert ./superadmin.p12 --cert-type p12 --pass ejb

 edit "smb-win2012"
        set domain-name "SMB2012.LAB"
        set username "smbreplicate"
        set password ENC YG0sKNKz5q/myCBR8fo+Y9CLEYebFbTjDtXxadWhbu1OZoNPAZ6YLYY9k+hJYzyOmFgG7SZ/IUn4Sbasx90OfQET1fWkzKFpIWA4M46CQj11WUcCSjZxSB37P1LTmPdjMzwrjnBXXstg4fCFRf8hCKLyu36B96oRDnaTs369OTDNkDHsgA0nM9DdNtcjwq5g/vUQoQ==
        set ip <<SUBNET>>.212
    next
    edit "win2016"
        set domain-name "SMB2016.LAB"
        set username "smbreplicate"
        set password ENC IfdWOrqOlUb8RbuA40u7+l1lOogyrAmf6EfqRrydT0XuzizLA/dfeHL5qoe+HWkKEa5NlqXaNlBYTbno7uUGb2NtD3QS6zGmHHAQie538MMys3hpgUzudm36YJtaSuDUn4pSnE8RU7wiUlCRLFF4aRbM2vkkjFHQqLsuQZUF9ZgNw+mmmjMvj2XX7z4vsUPlYxOynA==
        set ip <<SUBNET>>.216
    next


0603

https://kb.fortinet.com/kb/documentLink.do?externalID=FD40058

EAP TLS uses Public Key Infrastructure (PKI) digital certificates to provide mutual authentication between the EAP client and the RADIUS server. A PKI certificate is a file created by a program called a Certificate Authority. The certificate contains the name of the server or user that has been issued to. The EAP client and RADIUS server use the certificates to verify that the other party is indeed who it claims to be. In EAP TLS, a PKI certificate is required for the Radiator RADIUS server and for each and every EAP TLS client. EAP TLS does support dynamic WEP keys.
You can obtain certificates from a Public Certificate authority such as Thawte Opens in new window. The advantage of Public Certificates is that they will generally be recognised by any client or server without taking any special steps. A disadvantage of Public certificates is that you usually have to pay an annual fee for each one. With a Private Certificate Authority, you can generate your own server and client certificates for free, but you will generally have to install the ‘Root Certificate’ from your Certificate Authority on each client before it will recognise a private server certificate. Private Certificates are considered by many to be more secure that Public Certificates.
The basic steps of EAP TLS authentication are:
The EAP TLS client and RADIUS server establish a communications channel via the RADIUS protocol.
The RADIUS server sends its Server PKI Certificate to the client.
The client verifies that the server certificate is valid and is the correct certificate for the RADIUS server it is communicating with. It uses the Root Certificate of the Certificate Authority that issued the Server Certificate to validate the Server Certificate. (Root Certificates for most Public Certificate Authorities are built in to most clients. If the Server Certificate was issued by a Private Certificate Authority, the client requires a copy of the Root Certificate to be installed in order to validate the Server Certificate.)
If the client validates the server certificate, it then sends the user's PKI certificate to the RADIUS server.
The RADIUS server verifies that the client certificate is valid and is the correct certificate for the user name that is being authenticated. The RADIUS server can be configured to validate Private Client Certificates using a locally installed copy of the Root Certificate of the Certificate Authority that issued the client certificate.
If the RADIUS server validates the client certificate then the authentication is successful, and the client is permitted to be connected to the network.
EAP TLS does not use or exchange any passwords, but you can use AuthBy methods in Radiator to enable or disable EAP TLS users based on their user name, time of day etc



Upstream proxy mode
In this mode, mitmproxy accepts proxy requests and unconditionally forwards all requests to a specified upstream proxy server. This is in contrast to Reverse Proxy, in which mitmproxy forwards ordinary HTTP requests to an upstream server.

Transparent web proxy
upstream proxy without requiring the users to reconfigure their browsers or publish a proxy auto-reconfiguration (PAC) file.


0531;

 exe files conruppted by 8005( myweb.py) 
 client issue:  when sent by --
C:\ft\tmp> curl --data-binary @wget.exe http://<<SUBNET>>.184:8005 -v  -x <<SUBNET>>.203:8080  -o 11.exe

C:\ft\tmp> curl -X POST -F file=@header.txt http://<<SUBNET>>.184:8005 -v  -x <<SUBNET>>.203:8080
Note: Unnecessary use of -X or --request, POST is already inferred.
* Rebuilt URL to: http://<<SUBNET>>.184:8005/
*   Trying <<SUBNET>>.203...
* TCP_NODELAY set
* Connected to <<SUBNET>>.203 (<<SUBNET>>.203) port 8080 (#0)
> POST http://<<SUBNET>>.184:8005/ HTTP/1.1
> Host: <<SUBNET>>.184:8005
> User-Agent: curl/7.55.1
> Accept: */*
> Proxy-Connection: Keep-Alive
> Content-Length: 322
> Expect: 100-continue
> Content-Type: multipart/form-data; boundary=------------------------3be97507b6659cda
>
* Done waiting for 100-continue
< HTTP/1.1 200 OK
< Server: BaseHTTP/0.6 Python/3.6.7
< Date: Fri, 31 May 2019 16:50:13 GMT
* no chunk, no close, no size. Assume close to signal end
<
--------------------------3be97507b6659cda
Content-Disposition: form-data; name="file"; filename="header.txt"
Content-Type: text/plain

POST /post HTTP/1.1
Content-Length: 422670
Host: httpbin.org
Connection: Keep-Alive
User-Agent: Apache-HttpClient/4.1.1 (java 1.5)
--------------------------3be97507b6659cda--
* Closing connection 0



C:\ft\tmp> curl -d @header.txt http://<<SUBNET>>.184:8005 -v  -x <<SUBNET>>.203:8080
..
* upload completely sent off: 126 out of 126 bytes
< HTTP/1.1 200 OK
< Server: BaseHTTP/0.6 Python/3.6.7
< Date: Fri, 31 May 2019 16:51:07 GMT
* no chunk, no close, no size. Assume close to signal end
<
POST /post HTTP/1.1Content-Length: 422670Host: httpbin.orgConnection: Keep-AliveUser-Agent: Apache-HttpClient/4.1.1 (java 1.5)* Closing connection 0

C:\ft\tmp>more header.txt
POST /post HTTP/1.1
Content-Length: 422670
Host: httpbin.org
Connection: Keep-Alive
User-Agent: Apache-HttpClient/4.1.1 (java 1.5)


aiyan@van-201738-pc:~$ curl -x 172.18.43.38:8080 172.18.43.100  -v  -X post -F file=@memo
.....
> Content-Type: multipart/form-data; boundary=------------------------40e62377664ca529
> Expect: 100-continue
>
< HTTP/1.1 100 Continue

C:\ft\tmp> curl --data-bin @header.txt http://<<SUBNET>>.184:8005  -x <<SUBNET>>.203:8080
POST /post HTTP/1.1
Content-Length: 422670
Host: httpbin.org
Connection: Keep-Alive
User-Agent: Apache-HttpClient/4.1.1 (java 1.5)




0530:

http post to save to a file : 

at <<SUBNET>>.184:  ( Johns/sa ) 
johns@johns-virtual-machine:~/post$ python3 httpserver.py



C:\ft\tmp>curl -X POST -F file=@wget.exe http://<<SUBNET>>.184:8000 -v  -x <<SUBNET>>.203:8080
Note: Unnecessary use of -X or --request, POST is already inferred.
* Rebuilt URL to: http://<<SUBNET>>.184:8000/
*   Trying <<SUBNET>>.203...
* TCP_NODELAY set
* Connected to <<SUBNET>>.203 (<<SUBNET>>.203) port 8080 (#0)
> POST http://<<SUBNET>>.184:8000/ HTTP/1.1
> Host: <<SUBNET>>.184:8000
> User-Agent: curl/7.55.1
> Accept: */*
> Proxy-Connection: Keep-Alive
> Content-Length: 4923480
> Expect: 100-continue
> Content-Type: multipart/form-data; boundary=------------------------10cd46bfc247ab25
>
* Done waiting for 100-continue




0529:

FOH:
http--<FGT>---ftpserver 
FGT: 
curl ftp://ftp@172.18.2.169/upload/ama/xmltest -x <<SUBNET>>.203:8080 -v

FGT: 

config web-proxy explicit
    set status enable
    set ftp-over-http enable
    set http-incoming-port 8080
end



4.826031 <<SUBNET>>.99.64079 -> <<SUBNET>>.203.8080: psh 724790450 ack 3801166770
0x0000   0000 0000 0001 8cec 4b59 187f 0800 4500        ........KY....E.
0x0010   00de 032f 4000 8006 4798 ac12 2b63 ac12        .../@...G...+c..
0x0020   2bcb fa4f 1f90 2b33 6cb2 e291 33b2 5018        +..O..+3l...3.P.
0x0030   0805 fefd 0000 4745 5420 6674 703a 2f2f        ......GET.ftp://
0x0040   6674 7040 3137 322e 3138 2e32 2e31 3639        ftp@172.18.2.169
0x0050   2f75 706c 6f61 642f 616d 612f 7465 7374        /upload/ama/test
0x0060   2d75 726c 7320 4854 5450 2f31 2e31 0d0a        -urls.HTTP/1.1..
0x0070   486f 7374 3a20 3137 322e 3138 2e32 2e31        Host:.172.18.2.1
0x0080   3639 3a32 310d 0a41 7574 686f 7269 7a61        69:21..Authoriza
0x0090   7469 6f6e 3a20 4261 7369 6320 5a6e 5277        tion:.Basic.ZnRw
0x00a0   4f67 3d3d 0d0a 5573 6572 2d41 6765 6e74        Og==..User-Agent
0x00b0   3a20 6375 726c 2f37 2e35 352e 310d 0a41        :.curl/7.55.1..A
0x00c0   6363 6570 743a 58a 2f2a 0d0a 5072 6f78        ccept:.*/*..Prox
0x00d0   792d 436f 6e6e 6563 7469 6f6e 3a20 4b65        y-Connection:.Ke
0x00e0   6570 2d41 6c69 7665 0d0a 0d0a                  ep-Alive....


13.157021 172.18.2.169.21 -> <<SUBNET>>.203.16437: psh 672811689 ack 3028242889
0x0000   0000 0000 0001 0009 0f09 0717 0800 4500        ..............E.
0x0010   0051 c46d 4000 3e06 f1a0 ac12 02a9 ac12        .Q.m@.>.........
0x0020   2bcb 0015 4035 281a 4aa9 b47f 51c9 8018        +...@5(.J...Q...
0x0030   0072 4e49 0000 0101 080a 1d6f 8ec4 0086        .rNI.......o....
0x0040   bfc3 3232 3020 5765 6c63 6f6d 6520 746f        ..220.Welcome.to
0x0050   2046 5450 2073 6572 7669 6365 2e0d 0a          .FTP.service...


Proxy ftp

aiyan@aiyan-OptiPlex-3050:~$ ftp <<SUBNET>>.33 

Connected to <<SUBNET>>.33.

220 Welcome to Fortigate FTP proxy

Name (<<SUBNET>>.33:aiyan): admin::ftp@172.18.2.169

331-Please provide password information according to the following format:

331-               [[proxy-passwd:[proxy-token:]]remote_passwd

331-Please note that if you have provided a proxy-user as part of the user-name, 

331-you must also provide a proxy-passwd as part of the password. Furthermore, 

331 proxy-token can only be provided in the password if proxy-user has been provided.

Password:

230 Login successful.



0528

Jim_Xiong	2019-03-18 16:07
can you run below commands when memory usage is high?

get sys status
get sy performance st
dia har sys memory
dia har sys slab
dia sys process sock-mem 
dia sys session full
dia sys session6 full

Tony:
Please run the below diag cmd to collect more memory stats:
diag test app wad 2
diag test app wad 3
diag test app wad 21
diag test app wad 22
diag test app wad 23
diag test app wad 25
diag test app wad 27
diag test app wad 33
diag test app wad 70
diag test app wad 120
diag test app wad 123
diag test app wad 130
diag test app wad 132
diag test app wad 150

0527 
whitelist+blacklist: (https://mantis.fortinet.com/bug_view_page.php?bug_id=0285216)

image
=====
ftp 172.18.2.169:/upload/hyu/sandbox-url>


list file
=========
1. whitelist, 
updated download the zip file /data2/uwdb, [data/uwdb]
  and unzip to /tmp/wad_uwdb_[01]

2. blacklist, 
quarantined download the zip file /tmp/fsa_urldb
  and unzip to /tmp/wad_fsa_url_[01]


urlfilter priority
==================
  local-url > blacklist > forgigard > whitelist.

  So we can use local-url bypass the blacklist/whitelist.


config:
======

VM64 (default) # show
config webfilter profile
    edit "default"
            config web
                set whitelist exempt-av exempt-webcontent exempt-activex-java-cookie exempt-dlp exempt-rangeblock extended-log-others
            end

VM64 # show firewall ssl-ssh-profile deep-inspection 
config firewall ssl-ssh-profile
    edit "deep-inspection"
        set whitelist enable


Update:
======

1. FortiGuard
---------------
VM64 # exec update_now

2. (t)ftp server
----------------
VM64 # exec restore uwdb tftp uwdb 192.168.1.121

Please unpack the attached tgz file, and copy swl_release_1.00018.pkg to tftp dir as file 'uwdb'.


debug keyword:
=============
balcklist result
whitelist result
fsa load
uwdb load


wget https://www.openssl.org/source/openssl-1.1.1.tar.gz
tar xvf openssl-1.1.1.tar.gz
cd openssl-1.1.1
sudo ./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)'
sudo make
sudo make install

root@vm-122:/home/aiyan/gm/openssl-1.1.1# openssl version
OpenSSL 1.1.1  11 Sep 2018
 
 
 
 wget https://www.openssl.org/source/openssl-1.1.0e.tar.gz
tar xzvf openssl-1.1.0e.tar.gz
cd openssl-1.1.0e
./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)'
make
sudo make install
To verify it is working:
Code:
$ openssl version
OpenSSL 1.1.0  25 Aug 2016




0518

echo start.
:start 
curl https://18.213.95.172 -x <<SUBNET>>.2:8080 -k
timeout 1 
goto start 




0516

config system interface
    edit "ha"
        set vdom "root"
        set ip 10.1.1.1 255.255.255.0
        set allowaccess ping https ssh
        set type physical
        set inbandwidth 200
        set snmp-index 2
        config ipv6
            set ip6-address 2010:1:1::1/64
            set ip6-allowaccess ping https
        end
    next



https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Domain_Member 

0515

 IP address of an infected file to the quarantine or list of banned source IP addresses in the CLI:

config antivirus profile

edit <name of profile>

config nac-quar

set infected quar-src-ip

set expiry 5m

end

0514

curl -X POST "http://httpbin.org/post" -H "accept: application/json"  -x http://adu1:12345678@<<SUBNET>>.201:8080
waf-sql:             
http://172.18.2.169/index.php?username=1'%20or%20'1'%20=%20'1&password=1'%20or%20'1'%20=%20'1 
URI, Query 

ips sensor:    set rule 29844    -->  eicar      

  


0513

1: date=2019-05-13 time=12:13:51 logid="0102043025" type="event" subtype="user" level="notice" vd="root" eventtime=1557774831690403589 logdesc="Explicit proxy authentication successful" srcip=<<SUBNET>>.99 dstip=172.18.2.169 authid="1" user="Adu1" group="N/A" authproto="HTTP(<<SUBNET>>.99)" action="authentication" status="success" reason="Authentication succeeded" msg="User Adu1 succeeded in authentication"



0510
Although certificate-based authentication addresses security, it does not address issues related to the physical access of individual workstations or passwords. Public key cryptography only verifies that a private key that is used to sign some information corresponds to the public key in a certificate.

0508:
#winbindd
root@smb-virtual-machine:/home/smb# net ads testjoin
Join is OK


smb@smb-virtual-machine:~$ smbd -b  | grep conf
   CONFIGFILE: /etc/samba/smb.conf
   
sudo ktutil
ktutil:  rkt /etc/krb5.keytab
ktutil:  l
slot KVNO Principal

sudo base64 /etc/krb5.keytab
BQIAAABKAAIAC1NNQjIwMTYuTEFCAARob3N0ABZzbWItdWJ1bnR1LnNtYjIwMTYubGFiAAAAAVxv
UjMDAAEACEP9dvJ6rr8TAAAAAwAAAAAAAAA+AAIAC1NNQjIwMTYuTEFCAARob3N0AApTTUItVUJV
TlRVAAAAAVxvUjMDAAEACEP9dvJ6rr8TAAAAAwAAAAAAAABKAAIAC1NNQjIwMTYuTEFCAARob3N0
ABZzbWItdWJ1bnR1LnNtYjIwMTYubGFiAAAAAVxvUjMDAAMACEP9dvJ6rr8TAAAAAwAAAAAAAAA+ 


Krb:

Client:
Cached Tickets: (4)

#0>     Client: u3 @ SMB2016.LAB
        Server: krbtgt/SMB2016.LAB @ SMB2016.LAB
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x60a10000 -> forwardable forwarded renewable pre_authent name_canonicalize
        Start Time: 5/8/2019 11:20:56 (local)
        End Time:   5/8/2019 21:20:51 (local)
        Renew Time: 5/15/2019 11:20:51 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x2 -> DELEGATION
        Kdc Called: WIN2016.SMB2016.LAB

#1>     Client: u3 @ SMB2016.LAB
        Server: krbtgt/SMB2016.LAB @ SMB2016.LAB
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40e10000 -> forwardable renewable initial pre_authent name_canonicalize
        Start Time: 5/8/2019 11:20:51 (local)
        End Time:   5/8/2019 21:20:51 (local)
        Renew Time: 5/15/2019 11:20:51 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x1 -> PRIMARY
        Kdc Called: WIN2016.SMB2016.LAB

#2>     Client: u3 @ SMB2016.LAB
        Server: cifs/win2016 @ SMB2016.LAB
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40a50000 -> forwardable renewable pre_authent ok_as_delegate name_canonicalize
        Start Time: 5/8/2019 11:20:56 (local)
        End Time:   5/8/2019 21:20:51 (local)
        Renew Time: 5/15/2019 11:20:51 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0
        Kdc Called: WIN2016.SMB2016.LAB

#3>     Client: u3 @ SMB2016.LAB
        Server: cifs/smb-ubuntu @ SMB2016.LAB
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40a10000 -> forwardable renewable pre_authent name_canonicalize
        Start Time: 5/8/2019 11:20:55 (local)
        End Time:   5/8/2019 21:20:51 (local)
        Renew Time: 5/15/2019 11:20:51 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0
        Kdc Called: WIN2016.SMB2016.LAB


0507:

ftp not in the stat, ( d wad stat tu list , ftp stat always 0 ) 
due to ftp not in the wanop tunnel 
due to av enabled in firewall policy ( of wanopt )
--> solution: 
disable av at both client/server side then OK


https://wiki.freeradius.org/guide/Active-Directory-direct-via-winbind 


config user krb-keytab
    edit "smb2016.lab"
        set pac-data disable
        set principal "host/smb-ubuntu.smb2016.lab@SMB2016.LAB"
        set ldap-server "ldap216"
        set keytab "BQIAAABKAAIAC1NNQjIwMTYuTEFCAARob3N0ABZzbWItdWJ1bnR1LnNtYjIwMTYubGFiAAAAAVxvUjMDAAEACEP9dvJ6rr8TAAAAAwAAAAAAAAA+AAIAC1NNQjIwMTYuTEFCAARob3N0AApTTUItVUJVTlRVAAAAAVxvUjMDAAEACEP9dvJ6rr8TAAAAAwAAAAAAAABKAAIAC1NNQjIwMTYuTEFCAARob3N0ABZzbWItdWJ1bnR1LnNtYjIwMTYubGFiAAAAAVxvUjMDAAMACEP9dvJ6rr8TAAAAAwAAAAAAAAA+AAIAC1NNQjIwMTYuTEFCAARob3N0AApTTUItVUJVTlRVAAAAAVxvUjMDAAMACEP9dvJ6rr8TAAAAAwAAAAAAAABSAAIAC1NNQjIwMTYuTEFCAARob3N0ABZzbWItdWJ1bnR1LnNtYjIwMTYubGFiAAAAAVxvUjMDABEAECUnw7huY/0vTIO6oyvodBwAAAADAAAAAAAAAEYAAgALU01CMjAxNi5MQUIABGhvc3QAClNNQi1VQlVOVFUAAAABXG9SMwMAEQAQJSfDuG5j/S9Mg7qjK+h0HAAAAAMAAAAAAAAAYgACAAtTTUIyMDE2LkxBQgAEaG9zdAAWc21iLXVidW50dS5zbWIyMDE2LmxhYgAAAAFcb1IzAwASACB86SIqn6UEsa1ZO0L+y+SYoWqD26QzbulXrJ29WURBrAAAAAMAAAAAAAAAVgACAAtTTUIyMDE2LkxBQgAEaG9zdAAKU01CLVVCVU5UVQAAAAFcb1IzAwASACB86SIqn6UEsa1ZO0L+y+SYoWqD26QzbulXrJ29WURBrAAAAAMAAAAAAAAAUgACAAtTTUIyMDE2LkxBQgAEaG9zdAAWc21iLXVidW50dS5zbWIyMDE2LmxhYgAAAAFcb1IzAwAXABB/jDd1Kp8KSJw6jWIO9T7aAAAAAwAAAAAAAABGAAIAC1NNQjIwMTYuTEFCAARob3N0AApTTUItVUJVTlRVAAAAAVxvUjMDABcAEH+MN3UqnwpInDqNYg71PtoAAAADAAAAAAAAADkAAQALU01CMjAxNi5MQUIAC1NNQi1VQlVOVFUkAAAAAVxvUjMDAAEACEP9dvJ6rr8TAAAAAwAAAAAAAAA5AAEAC1NNQjIwMTYuTEFCAAtTTUItVUJVTlRVJAAAAAFcb1IzAwADAAhD/Xbyeq6/EwAAAAMAAAAAAAAAQQABAAtTTUIyMDE2LkxBQgALU01CLVVCVU5UVSQAAAABXG9SMwMAEQAQJSfDuG5j/S9Mg7qjK+h0HAAAAAMAAAAAAAAAUQABAAtTTUIyMDE2LkxBQgALU01CLVVCVU5UVSQAAAABXG9SMwMAEgAgfOkiKp+lBLGtWTtC/svkmKFqg9ukM27pV6ydvVlEQawAAAADAAAAAAAAAEEAAQALU01CMjAxNi5MQUIAC1NNQi1VQlVOVFUkAAAAAVxvUjMDABcAEH+MN3UqnwpInDqNYg71PtoAAAADAAAAAA=="
    next
end


wad_cifs_domain_controller_update_vd(318): Network server configuration done
wad_cifs_keytab_cred_alloc(102): Allocated host/smb-ubuntu.smb2016.lab@SMB2016.LAB keytab cred(0x7fd3da5cfbb8)
wad_cifs_profile_keytab_alloc_one(220): Created cred for host/smb-ubuntu.smb2016.lab@SMB2016.LAB
wad_cifs_profile_alloc(437): CIFS Profile 0x7fd3dbb65b50 [keytab] of type 2 created


/tmp/wad # ls
296.krb5.conf  419.krb5.conf  420.krb5.conf  persistent     user_info
volatile


/tmp/cifs_kt # ls
1.0.379.cifskeytab  1.0.420.cifskeytab


/tmp/kt # ls
1.0.190.keytab

/tmp/wad # ls
189.krb5.conf  190.krb5.conf  persistent     user_info      volatile

/tmp/wad # more 190.krb5.conf

[libdefaults]
 allow_weak_crypto = true
 default_tgs_enctypes = rc4
 default_tkt_enctypes = rc4

[realms]

0506
wad_negotiate_keyfile(141): keytab base64 decoding error
wad_negotiate_add_cred(122): create krb cred ldap216 0x7f55623e6208
wad_negotiate_create_cred(237): Create keyfile /tmp/kt/1.0.226.keytab
wad_krb_err_print(40): Error returned by gss_canonicalize_name: major:d0000 Hex minor:2529639136 Dec
wad_krb_err_print(46): major error <1> Unspecified GSS failure.  Minor code may provide more information
wad_krb_err_print(58): minor error <1> Configuration file does not specify default realm
__wad_fmem_open(539): fmem=0xb20f318, fmem_name='cmem 380 bucket', elm_sz=380, block_sz=73728, overhead=0, type=advanced

0504

di sys csf --> Security Frabic Diag 
di sys last-modify-files 
 

 set name "wanopt-server"
        set uuid d03c5ba2-5640-51e9-a0fd-a4232902b542
        set srcintf "port5"
        set dstintf "wan1" "port8"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set utm-status enable
        set inspection-mode proxy
        set wanopt enable
        set av-profile "default"
        set ssl-ssh-profile "certificate-inspection"
        set wanopt-detection off
        set wanopt-profile "cifs"
        set wanopt-peer "client"
        set nat enable


cifs_nbss_identify_protocol(581): nbss detected ecapsulated smb3 message
smb3_decrypt_gcm(5692): smb3 payload of 124 bytes decrypted using AES-128-GCM
smb2_nbss_alloc(1595): smb2 nbss 0x7f5ffcedd8c0 allocated
smb2_nbss_set_encryption_info(1632): smb3 read encryption information
smb2_nbss_set_encryption_info(1633): smb3       session id 79176983904293
smb2_nbss_set_encryption_info(1634): smb3       nOnce 26a49f5faa6453c4 0000000000000000
smb2_parse_stream(5560): smb2 parsing 124 plain-text bytes
smb2_parsing_alloc(1944): smb2 parsing 0x7f5ff46f2ba8 allocated
smb2_payload_alloc(1513): smb2 payload 0x7f5ff462e1c0 allocated
smb2_msg_alloc(2005): smb2 message 0x7f5ffcedd9a0 allocated
smb2_hdr_print(2092): smb2 CLO Response [mid 14, sid 79176983904293, tid 1, st 0, r 0]
smb2_parse_message(5486): smb2 processing 124 message bytes
smb2_parse_close_response(4743): smb2 successfully closed file Empty [77310323483 77309411337]
smb2_file_print(831): smb2 file Del 0x7f5ff49c34f0, 'Empty' [s 4096, fid 1200000009, 6]
smb2_file_free(902): smb2 file 0x7f5ff49c34f0 freed
smb2_msg_free(2034): smb2 message 0x7f5ffcedd930 freed
smb2_parsing_free(1959): smb2 parsing 0x7f5ff46f2ba8 freed
smb2_msg_free(2034): smb2 message 0x7f5ffcedd9a0 freed
smb2_parse_stream(5569): smb2 parsed 124 byte message, 0 remaining
smb2_nbss_forward(1820): smb2 forwarding payload 0x7f5ff462e1c0 [124]
smb2_payload_free(1533): smb2 payload 0x7f5ff462e1c0 freed
smb2_nbss_generate_header(1741): smb3 generated decrypted information
smb2_nbss_generate_header(1742): smb3   session id 79176983904293
smb2_nbss_generate_header(1743): smb3   nOnce 26a49f5faa6453c4 0000000000000000
smb2_nbss_forward(1875): smb2 forwarding nbss 0x7f5ffcedd8c0 [172]
cifs_stream_forward_nbss(505): nbss attempting to forward 172 bytes of data
cifs_stream_forward_br_length(401): wad cifs succeeded to forward list of 172 bytes
smb2_nbss_free(1620): smb2 nbss 0x7f5ffcedd8c0 freed

		
		
		
0503 
crash backtrace: 
http://gerrit.fortinet.com/crash/  
https://192.168.100.17/ 
root@van-201738-pc:/home/aiyan/ft/crash_work# ruby addrmapsearch.rb -f crash.txt  -m init.map 

Application: wad
Signal: 11 Segmentation fault
Backtrace:
[0x01b963b8] wad_user_node_stats_put [0x0000000001b96393] [0x25]
[0x01cda8d2] wad_tcp_port_end_event [0x0000000001cda73d] [0x195]
[0x01cdab00] wad_tcp_port_proc_end [0x0000000001cda990] [0x170]
[0x01cdd92f] wad_tcp_port_on_event [0x0000000001cdd436] [0x4f9]
[0x01c93426] wad_sched_process_events [0x0000000001c93362] [0xc4]

Or 
 root@van-201738-pc:/tmp# gdb init  
GNU gdb (Ubuntu 7.11.1-0ubuntu1~16.5) 7.11.1 Copyright (C) 2016 Free Software Foundation, Inc.
……….
Reading symbols from init...done.
(gdb) info line *0x0042ef00
Line 677 of "/code/FortiOS/fortinet/sysinit/fortiexec.c" starts at address 0x42eeea <fortiexec_call_main+131>
   and ends at 0x42ef03 <fortiexec_call_main+156>.

\


$ craddr.pl crash.txt init 
init from the map file, craddr.pl from wiki <James Ladan).

i="0"
while [ $i -lt 400000 ]  do
curl -x <<SUBNET>>.34:8080 http://172.18.27.184/virus/interactiveform_enabled.pdf  >>/dev/null
i=$[$i+1]
 

0502
with firefox:
about:config --> 
network.negotiate.auth.trust-uris: fgt67.devqa2.net
network.proxy.http : fgt67.devqa2.net

FGT user auth: active ( user input) Passive ( fetch from system, sso )
session based 
ip based 

config user krb-keytab
    edit "http_devqa2"
        set pac-data disable 
        set principal "HTTP/fgt67.devqa2.net@DEVQA2.NET"
        set ldap-server "ldap216"
        set keytab "BQIAAAA7AAIACkRFVlFBMi5ORVQABEhUVFAAEGZndDY3LmRldnFhMi5uZXQAAAABAAAAAA8AAQAI1enCiQhdQOUAAAA7AAIACkRFVlFBMi5ORVQABEhUVFAAEGZndDY3LmRldnFhMi5uZXQAAAABAAAAAA8AAwAI1enCiQhdQOUAAABDAAIACkRFVlFBMi5ORVQABEhUVFAAEGZndDY3LmRldnFhMi5uZXQAAAABAAAAAA8AFwAQxzmIsIkyDFP/QTA/TnkwkgAAAFMAAgAKREVWUUEyLk5FVAAESFRUUAAQZmd0NjcuZGV2cWEyLm5ldAAAAAEAAAAADwASACAcisZ5Yp1mwyIdDG0kYeBJWI7+FI9SxZ1yM1PdPAc47wAAAEMAAgAKREVWUUEyLk5FVAAESFRUUAAQZmd0NjcuZGV2cWEyLm5ldAAAAAEAAAAADwARABBOrXY1bbt1JsmMAdJ02h+D"
    next
end

config cifs profile
  edit "smb_keytab"
        set server-credential-type credential-keytab 
  config server-keytab
            edit "host/smb-ubuntu.smb2016.lab@SMB2016.LAB"
                set keytab "BQIAAABGAAIAC1NNQjIwMTYuTEFCAARob3N0ABZzbWItdWJ1bnR1LnNtYjIwMTYubGFiAAAAAVx3G/4DAAEACEP9dvJ6rr8TAAAAAwAAADoAAgALU01CMjAxNi5MQUIABGhvc3QAClNNQi1VQlVOVFUAAAABXHcb/gMAAQAIQ/128nquvxMAAAADAAAARgACAAtTTUIyMDE2LkxBQgAEaG9zdAAWc21iLXVidW50dS5zbWIyMDE2LmxhYgAAAAFcdxv+AwADAAhD/Xbyeq6/EwAAAAMAAAA6AAIAC1NNQjIwMTYuTEFCAARob3N0AApTTUItVUJVTlRVAAAAAVx3G/4DAAMACEP9dvJ6rr8TAAAAAwAAAE4AAgALU01CMjAxNi5MQUIABGhvc3QAFnNtYi11YnVudHUuc21iMjAxNi5sYWIAAAABXHcb/gMAEQAQJSfDuG5j/S9Mg7qjK+h0HAAAAAMAAABCAAIAC1NNQjIwMTYuTEFCAARob3N0AApTTUItVUJVTlRVAAAAAVx3G/4DABEAECUnw7huY/0vTIO6oyvodBwAAAADAAAAXgACAAtTTUIyMDE2LkxBQgAEaG9zdAAWc21iLXVidW50dS5zbWIyMDE2LmxhYgAAAAFcdxv+AwASACB86SIqn6UEsa1ZO0L+y+SYoWqD26QzbulXrJ29WURBrAAAAAMAAABSAAIAC1NNQjIwMTYuTEFCAARob3N0AApTTUItVUJVTlRVAAAAAVx3G/4DABIAIHzpIiqfpQSxrVk7Qv7L5JihaoPbpDNu6Vesnb1ZREGsAAAAAwAAAE4AAgALU01CMjAxNi5MQUIABGhvc3QAFnNtYi11YnVudHUuc21iMjAxNi5sYWIAAAABXHcb/gMAFwAQf4w3dSqfCkicOo1iDvU+2gAAAAMAAABCAAIAC1NNQjIwMTYuTEFCAARob3N0AApTTUItVUJVTlRVAAAAAVx3G/4DABcAEH+MN3UqnwpInDqNYg71PtoAAAADAAAANQABAAtTTUIyMDE2LkxBQgALU01CLVVCVU5UVSQAAAABXHcb/gMAAQAIQ/128nquvxMAAAADAAAANQABAAtTTUIyMDE2LkxBQgALU01CLVVCVU5UVSQAAAABXHcb/gMAAwAIQ/128nquvxMAAAADAAAAPQABAAtTTUIyMDE2LkxBQgALU01CLVVCVU5UVSQAAAABXHcb/gMAEQAQJSfDuG5j/S9Mg7qjK+h0HAAAAAMAAABNAAEAC1NNQjIwMTYuTEFCAAtTTUItVUJVTlRVJAAAAAFcdxv+AwASACB86SIqn6UEsa1ZO0L+y+SYoWqD26QzbulXrJ29WURBrAAAAAMAAAA9AAEAC1NNQjIwMTYuTEFCAAtTTUItVUJVTlRVJAAAAAFcdxv+AwAXABB/jDd1Kp8KSJw6jWIO9T7aAAAAAw=="
            next




FG201E4Q17902940 # d wad tu l

Tunnel: id=1 type=auto
    vd=0 shared=no uses=1 state=2
    peer name=client id=2876 ip=5.1.1.201 (best guess)
    SSL-secured-tunnel=no auth-grp=psk1-8
    bytes_in=81691 bytes_out=93538

Tunnel: id=37 type=auto
    vd=0 shared=no uses=1 state=2
    peer name=client id=2947 ip=5.1.1.201 (best guess)
    SSL-secured-tunnel=yes auth-grp=psk1-8
    bytes_in=807 bytes_out=1010

Tunnels total=2 manual=0 auto=2

FG201E4Q17902940 # d wad tu l

Tunnel: id=1 type=auto
    vd=0 shared=no uses=1 state=2
    peer name=client id=2876 ip=5.1.1.201 (best guess)
    SSL-secured-tunnel=no auth-grp=psk1-8
    bytes_in=88220 bytes_out=100926

Tunnels total=1 manual=0 auto=1

FG201E4Q17902940 # d wad tu l


0430
decryption:
smb2_hdr_print(2092): smb2 SES Response [mid 2, sid 79167118901353, tid 0, st 0, r 0]
smb2_session_derive_keys(1381): smb session key derived! for version ??

0429

FortiGate-201E login: b2-0 wdb_init_validate:0793       ERROR: Parsing - Partition size mismatch E/R 40034818048/40038291456



c:>fsutil file createnew fakefile.txt 1073741824 

C:\test3>ptime copy a.mp4 y: /Y

ptime 1.0 for Win32, Freeware - http://www.pc-tools.net/
Copyright(C) 2002, Jem Berkes <jberkes@pc-tools.net>

===  copy a.mp4 y: /Y ===
        1 file(s) copied.

Execution time: 6.718 s



0426
curl -p - --insecure  "ftp://82.45.34.23:21/CurlPutTest/" --user "testuser:testpassword" -T "C:\test\testfile.xml" --ftp-create-dirs 

curl ftp://ftp@172.18.2.169 

403 Forbidden vs 401 Unauthorized HTTP responses 
rror 403: "The server understood the request, but is refusing to fulfill it. Authorization will not help and the request SHOULD NOT be repeated."
Error 401: "The request requires user authentication. The response MUST include a WWW-Authenticate header field (section 14.47) containing a challenge applicable to the requested resource. The client MAY repeat the request with a suitable Authorization header field (section 14.8). If the request 

#d wad tu l 
#d wad stat tu l
#d wadbd restart 
FG201E4Q17902940 # diag wad history list CIFS 10min

stats history vd=0 proto=cifs period=last 10min
               --- LAN ---                               --- WAN ---
      bytes_in             bytes_out            bytes_in             bytes_out
    ------------         -------------        ------------         -------------
           0                     0                   0                    0
           0                     0                   0                    0
           0                     0                   0                    0
           0                     0                   0                    0
           0                     0                   0                    0
           0                     0                   0                    0
           0                     0                   0                    0

0425
 FortiGate-VM # get router info6 routing-table connected
C       ::1/128 via ::, root, 18:47:30
C       7::/64 via ::, port7, 18:47:30
C       172::/64 via ::, port1, 18:47:30
C       fe80::/64 via ::, port7, 18:47:30

 / # ps -eo | grep /bin/wa
3866      0       0       S       /bin/wad
3868      0       0       S       /bin/wa_dbd 0
3869      0       0       S       /bin/wad_csvc_db 7 0
3870      0       0       S       /bin/wad 4
3871      0       0       S       /bin/wad 3
3872      0       0       S       /bin/wad 5
3873      0       0       S       /bin/wad 1
6994      0       0       S       /bin/wad 2 1
7011      0       0       S       /bin/wad 2 0
7072      0       0       S       grep /bin/wa

0424 
 CertUtil -hashfile <path to file> MD5 
 


 
 Crash log interval is 3600 seconds
wad crashed 106 times. The last crash was at 2019-04-25 10:21:52

FG201E4Q17902940 # d test app wad 1000
Process [0]: WAD manager type=manager(0) pid=3866 diagnosis=yes.
Process [1]: type=dispatcher(1) index=0 pid=3873 state=running
              diagnosis=no debug=enable valgrind=unsupported/disabled
Process [2]: type=worker(2) index=0 pid=7011 state=running
              diagnosis=no debug=enable valgrind=supported/disabled
Process [3]: type=worker(2) index=1 pid=6994 state=running
              diagnosis=no debug=enable valgrind=supported/disabled
Process [4]: type=algo(3) index=0 pid=3871 state=running
              diagnosis=no debug=enable valgrind=unsupported/disabled
Process [5]: type=informer(4) index=0 pid=3870 state=running
              diagnosis=no debug=enable valgrind=unsupported/disabled
Process [6]: type=user info(5) index=0 pid=3872 state=running
              diagnosis=no debug=enable valgrind=unsupported/disabled
Process [7]: type=cache-service-db(7) index=0 pid=3869 state=running
              diagnosis=no debug=enable valgrind=supported/disabled
Process [8]: type=byte-cache(9) index=0 pid=3868 state=running
              diagnosis=no debug=disable valgrind=unsupported/disabled



0423: 

ortiGate-VM (explicit) # set ipv6-status enable 
 

FG201E4Q17902940 # diag wad history list CIFS 10min

stats history vd=0 proto=cifs period=last 10min
               --- LAN ---                               --- WAN ---
      bytes_in             bytes_out            bytes_in             bytes_out
    ------------         -------------        ------------         -------------
           0                      0                    0                   0
           0                      0                    0                   0
           0                      0                    0                   0
           0                      0                    0                   0
           0                      0                    0                   0
           0                      0                    0                   0
           0                      0                    0                   0
           0                      0                    0                   0
           0                      0                    0                   0
         504                    212                  672                 656
        2215                   2283                 2507                2511
           0                      0                    0                   0
        5904                3640622                13671                7508
           0                      0                    0                   0
           0                      0                    0                   0
        3131                   3072                 3300                3371
           0                      0                    0                   0
       21229              143311601            141209040              488815
       40214              279649864              2323950               81790
        2834                6972920                67534                4118





net use:

net use * \\<<SUBNET>>.212\share_enc 


netsh interface show interface 
netsh interface set interface "ethernet0" admin=disable
0418:

PAC-LDAP:
Policy Authentication Control (PAC) daemon.  

pac.conf
The pac.conf file specifies the LDAP server with which the PAC daemon attempts to connect.


FortiGate-VM # sh user  krb-keytab  smb2016
config user krb-keytab
    edit "smb2016"
	    [set pac-data enable ] ===>  need ldap  group-search-base  
		( Privileged Attribute Certificate (PAC) is an extension to Kerberos tickets that contains useful information about a user’s privileges.  This information is added to Kerberos tickets by a domain controller when a user authenticates within an Active Directory domain)
        set principal "host/smb-ubuntu.smb2016.lab@SMB2016.LAB"
        set ldap-server "ldap216"    
        set keytab "...."
    next
end

FortiGate-VM # sh user ldap ldap216
config user ldap
    edit "ldap216"
        set server "<<SUBNET>>.216"
        set cnid "cn"
        set dn "cn=domainupdates,cn=system,dc=smb2016,dc=lab"
        set type regular
        set username "u1"
        set password ENC YmplY+XBqQwno0fgSWJmS+47S/Vi+N66nJ3pXFsd+glt+L4DDn+gq+F//3IXl6rnnpNbM1o0AhZzQhZogzmekTee7G8OdS5mIofw3wZ0lprh1GOKNAqOI3t/tv72GEzo+YS/+bq+AR4QukbHFJ0/6BWZApke5B32DUOgqd8cM5+/qC6c8+s374ut6Y20kgKVaGA9gg==
        set group-search-base "NULL"
    next
end


FortiGate-VM # sh user exchange
config user exchange
    edit "exchangeU1"
        set server-name "WIN2008R2-163"
        set domain-name "EXCHANGE2010.NET"
        set username "mail1"
        set password ENC e7AkvevP2a8IqvTY2puo/QZjAz+yF2a31odWDEkO0snnaoX1h3QGP8GrHMYmzsODEooJBIQrVaseLzM6ZB7KJwfXUvPupddfW7TWS3l2YDlhMRjI84aKrEI2zNvfNFK2Lo6395M7P6dye0GKtHxSwA7JIfofleqD5f6QJLl0UkrLjT770cqkB40VxE4o+VwjLJk+4w==
        set ip 172.18.13.163
    next
end


[PAC_MAN_SERVER]
hostname:                    # name of PAC daemon
port:                        # port pacd is listening on
conn_type:ssl                # comment out if you do not use SSL
authentication_sequence: [primary|secondary|none]
authorization_sequence:  [primary|secondary|none]

[LDAP_SERVER]
hostname:                    # LDAP Server hostname
port:389                     # Port LDAP is listening on
ssl_port:636                 # SSL port used by the LDAP server
admin_dn:                    # User with permission to access the LDAP server
                             # specify admin_dn:NULL to enable anonymous binding
search_base:                 # Portion of LDAP tree to search for policy info
                             # If not required, specify search_base:NULL
search_key:                  # ID field to search

[CACHE]
cred_cache_enabled [TRUE|FALSE] # turn credentials cache on
cred_cache_min_size:100      # minimum number of credentials to cache in pacd
cred_cache_max_size:64000    # maximum number of credentials to cache in pacd
cred_cache_expiration:86400  # when a credential expires
policy_cache_enabled:[TRUE|FALSE] # turns policy cache on/off
policy_cache_min_size:100    # min. number of policy related items to cache
policy_cache_max_size:64000  # max. number of policy related items to cache
policy_cache_expiration:86400 # when a policy related item expires
0415

curl -x socks5://[user:password@]proxyhost[:port]/ ur
C:\Users\john>curl -x socks5://\devqa\adu1:12345678@<<SUBNET>>.64:8090 172.18.2.169 
C:\Users\john>curl -x \devqa\adu1:12345678@<<SUBNET>>.64:8080 172.18.2.169

C:\Users\john>ftp <<SUBNET>>.64 
Connected to <<SUBNET>>.64.
220 Welcome to Fortigate FTP proxy
500 Syntax error or command unrecognized.
User (<<SUBNET>>.64:(none)): \devqa\adu1:ftp@172.18.2.169
331-Please provide password information according to the following format:
331-               [[proxy-passwd:[proxy-token:]]remote_passwd
331-
331-Please note that if you have provided a proxy-user as part of the user-name,
331-you must also provide a proxy-passwd as part of the password. Furthermore,
331 proxy-token can only be provided in the password if proxy-user has been provided.
Password:
230 Login successful.
ftp>

form-based auth




diag debug enable
diag debug flow filter add <PC1>    or    diag debug flow filter add <PC2>
diag debug flow show console enable
diag debug flow trace start 100          <== this will display 100 packets for this flow
diag debug enable


0412

ssh -Q kex  ==> key exchange algos
ssh- Q key 
 

ssh -vvv -oKexAlgorithms=diffie-hellman-group1-sha1 ...
ssh -vvv -oHostKeyAlgorithms=ssh-dss ...


0408

The env of vm3;
Mg--> port1 
HA1->7
LAN-->3 
The FGT: 100D


runas /user:Administrator "netsh.exe interface ip set address name="Local Area Connection" static 10.1.1.99 255.255.255.0 10.1.1.1"

netsh.exe interface ip set address name="Network2" static <<SUBNET>>.99 255.255.255.0 <<SUBNET>>.1"


0406
Kerboers:

At Client: 


principle:
fgt67.devqa2.net@DEVQA2.NET 


win-7 client configuration:

- add pc client to domain ( devqa2.net), u1/12345678  ( logoff domain   JOHN-PC\john  password sa)
- edit ip: 172.18.13.193 as dns server 
- edit hosts, add 172.18.13.69 fgt67.devqa2.net 

with firefox:
about:config --> 
network.negotiate.auth.trust-uris: fgt67.devqa2.net




Zaq1234.
docker

docker run -it  -p 80:8080 -p 443:8443 -h johns-virtual-machine -e TLS_SETUP_ENABLED="simple" primekey/ejbca-ce 


network.proxy.http : fgt67.devqa2.net
