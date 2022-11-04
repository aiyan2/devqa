 
from asyncio.log import logger
import sys, time
from logging import Logger

from SSH import SSH

class innovator:

    vfgt,vclient = None,None

    def __init__(self, logger, *args):
        mlog('NOTHING TO DO NOW!!! to be called by platform which has the **kwargs')
        mlog('parse the **kwargs, and assign them to create_env')
        
        vfgt = vFGT()
        vfgt.fgtip = args.fgtip
        vfgt.serverip = args.serverip
        vfgt.proxy = args.proxy
        vfgt.fgtadmin='admin'
        vfgt.adminpasswd = args.adminpasswd
        
    def create_env(self, vfgt):
        mlog('setup the xDevices and networking <vlan,ip,gateway>')
        ## doing the setup


class vFGT:

    lanIP,wanIP,lanIntf,wanIntf = None,None, None,None
    fgtip,admin,adminpassword = '172.18.43.72','admin','123'
    proxy = None # proxy=None means disable proxy or no proxy at FGT, used for Test-Cube
    
    
    def __init__(self,fgtip,admin='admin',adminpasswd = '123',proxy=None):  
        self.fgtip = fgtip
        self.admin= admin
        self.adminpassword=adminpasswd
        self.proxy = proxy

    def fgtconfig(self,cmds):
        from logging import Logger
        from SSH import SSH
        logger = Logger
        ssh = SSH(logger=logger, host_ip=self.fgtip, username=self.admin, password=self.adminpassword)
   
        cmdlog =''
        for cmd in cmds:
            ssh.send(cmd)
            cmdlog+=cmd.strip()+'/'
        time.sleep(1)
        ssh.close()
        return cmdlog

    def configure_by_ssh(self,cmd):
        import paramiko    
        ssh = paramiko.SSHClient()        
        # AutoAddPolicy for missing host key to be set before connection setup.
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        mlog ('to be connect')
        ssh.connect(self.lanIP, port=22, username='admin',
                    password='123', timeout=3)
        
        # Execute command on SSH terminal
        # using exec_command
        stdin, stdout, stderr = ssh.exec_command(cmd)
        mlog(stdout)

    def monitor(self,cmd):
        pass 

class vClient:
    ip,ostype,mac,hostname = None,None, None,None 

    @classmethod 
    def curl(self, params,TLS=None):   ###@from william test_tls.py
        params.insert(0, '-ksv')
        params.insert(0, 'curl')
        # move out proxy as it impacts the auth-method
        # params.extend (['-x ' + proxy]) if proxy else ''
        params.extend(['-tlsv' + TLS, '--tls-max', TLS]) if TLS else ''
        #mlog(whoami()+' '.join(params))
        import subprocess, inspect
        p = subprocess.Popen(params, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = p.communicate()
        p.terminate()
        caller_function_name = inspect.stack()[1][3]
        res = stdout.decode('ascii').strip()
        if not res:
            verbose = stderr.decode('ascii')
            self.logger.error(caller_function_name + " response is empty. curl verbose:")
            self.logger.error(verbose)
        return res

    def control(cmd):  ## reboot, change-ip etc.
        pass

class vServer:
    type = 'webserver'
    ip = '172.18.43.100'
    def __init__(self, serverip):
        self.ip = serverip
  
def whoami():        
        t = time.localtime()
        current_time = time.strftime("%H:%M:%S", t)
        return str(current_time)+sys._getframe(1).f_code.co_name + '(.)@' \
            +sys._getframe(1).f_code.co_filename+'line#:' \
            +str(sys._getframe(1).f_lineno)+' ' 
def mlog (obj):
    print (obj)


def runClientCmd(cmd):
    import subprocess
    #from subprocess import Popen, PIPE
    mlog('@@@@@@@@@@ '+whoami()+'@@@@@@@@@@ ')
    p = subprocess.Popen([cmd], stdout=subprocess.PIPE, stderr = subprocess.PIPE)
    res = p.communicate()[0]
    return res

def assertContain(full,part):
    #removing newlines    
    if part.strip() in full:
        mlog("\n@@@@@@@@PASSPASS@@@@@@\n")
    else:
        mlog("\n@@@@@@@@FAILFAIL@@@@@@\n")

def assertNotContain(full,part):
    #removing newlines    
    if part.strip() not in full:
        mlog("\n@@@@@@@@PASSPASS@@@@@@\n")
    else:
        mlog("\n@@@@@@@@FAILFAIL@@@@@@\n")
'''
@@error: /usr/lib/python3/dist-packages/requests/__init__.py:89: RequestsDependencyWarning: urllib3 (1.26.8) or chardet (3.0.4) doesn't match a supported version!
  warnings.warn("urllib3 ({}) or chardet ({}) doesn't match a supported "
@@fix:  
pip uninstall urllib3
pip install urllib3==1.22 
'''
device = None # fortigate device

def pyftapi():
    import next2del.pyfortiapi as pyfortiapi
    mlog('@@@@@@@@@@ '+whoami()+'@@@@@@@@@@ ')
    global device
    device = pyfortiapi.FortiGate(ipaddr="172.18.43.72",
                                  username="admin",password="123",
                                  vdom = 'autotest')  
    policies = device.get_firewall_policy()
    mlog(policies)
    my_policy = device.get_firewall_policy(1)

    return my_policy
def demo_api():
    import next2del.pyfortiapi as pyfortiapi
    mlog('@@@@@@@@@@ '+whoami()+'@@@@@@@@@@ ')
    before = device.get_firewall_address('Test')
    address_payload = "{'name': 'Test', 'type': 'subnet', 'subnet': '192.168.0.0 255.255.255.0'}"
    device.create_firewall_address('Test', address_payload)
    after = device.get_firewall_address('Test')
    device.delete_firewall_address('Test')
    return before,after

def test_update_policy():
    mlog('@@@@@@@@@@ '+whoami()+'@@@@@@@@@@ ') 
    device.update_firewall_policy(1,"{'utm-status': 'enable'}")
    device.update_firewall_policy(1,"{'av-profile':'g-default'}")
    return device.get_firewall_policy(1)

def test_fgt_config():
    cmds = """
        config vdom
        # edit autotest
        config webfilter profile
    edit {}
        set feature-set proxy
        config ftgd-wf
            unset options
            config filters
                edit 51
                    set category 51
                    set action block
                next
            end
        end
    next
end      
        """  .format('bb-wbf')
    mlog(cmds.split('\n'))  

    cmd2 = """
    config firewall proxy-policy
        del 1 
        purge \ny
        end"""

    cmd2 =  'exe reboot \ny'

    myfgt = vFGT(fgtip='172.18.43.72',admin='admin',adminpasswd='123',proxy=None)
    myfgt.fgtconfig(cmds.split('\n'))   
    myfgt.fgtconfig(cmd2.split('\n') )

    cmds = 'exe reboot \ny'
    fgt_ssh = SSH(logger=logger, host_ip=myfgt.fgtip, username=myfgt.admin, password=myfgt.adminpassword)
    #fgt_ssh.exec_cmd_listen(cmds, timeout=5)
    fgt_ssh.exec_cmd_listen('get sys status')

    fgt_ssh.close()
    


if __name__ == '__main__':   
    
    res =runClientCmd('ls')
    
    mlog(res)
    #res = runLocalCmd('/bin/ping 8.8.8.8')  
    #res = runLocalCmdArgs('cat','/etc/hosts')
    mlog(res)
    #res = runLocalCmd('ping  -c 4 8.8.8.8')
    mlog(res)
    mlog (pyftapi())
    mlog(demo_api())
    mlog(test_update_policy())

    test_fgt_config()




    