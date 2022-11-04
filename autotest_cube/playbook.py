 




from datetime import time
from logging import Logger


def whoami():
    import sys
    return sys._getframe(1).f_code.co_name + '(.)@'+sys._getframe( ).f_code.co_filename+' line#: ' +str(sys._getframe(1).f_lineno)+' '

def runClientCmd(cmd):
    import subprocess
    #from subprocess import Popen, PIPE
    mlog('@@@@@@@@@@ '+whoami()+'@@@@@@@@@@ ')
    p = subprocess.Popen([cmd], stdout=subprocess.PIPE, stderr = subprocess.PIPE)
    res = p.communicate()[0]
    return res

def mlog (obj):
    print (obj)

# Python program to illustrate use of exec to
# execute a given code as string.
 
# function illustrating how exec() functions.
def exec_code():
    LOC = """
def factorial(num):
    fact=1
    for i in range(1,num+1):
        fact = fact*i
    return fact
print(factorial(10))
"""
    exec(LOC)
     
def __run_test(obj, cls, pid, ident):
    caselist = 'test_case_list' #globaldic.get_value(constants.TEST_CASE_LIST)
    print(caselist)
    for name, func in cls.__dict__.items():
        if name.startswith('test_'):
            try:
                if caselist is not None:
                    if name in caselist:
                        getattr(obj, name)()
                else:
                    getattr(obj, name)()
            except Exception as e:
                import traceback, logging
                traceback.print_exc()
                logger = logging.getLogger(cls.__name__)
                logger.error('PID %s - TID %s : case ending exception: ' % (pid, ident) + str(e))


####============= For test purpose 
def auto_name():
    import sys
    mlog("\n\n__name__ is: "+auto_name.__name__)
    mlog('this_function_name is:: '+ sys._getframe(  ).f_code.co_name)
    mlog('this_line_number ' + str(sys._getframe(  ).f_lineno )
        +'\n this_filename '+ sys._getframe(  ).f_code.co_filename)
    mlog(whoami())  

'''
@@error: /usr/lib/python3/dist-packages/requests/__init__.py:89: RequestsDependencyWarning: urllib3 (1.26.8) or chardet (3.0.4) doesn't match a supported version!
  warnings.warn("urllib3 ({}) or chardet ({}) doesn't match a supported "
@@fix:  
pip uninstall urllib3
pip install urllib3==1.22 
'''
vFGT = None # fortigate device

def getPolicy():
    import pyfortiapi
    mlog('@@@@@@@@@@ '+whoami()+'@@@@@@@@@@ ')
    global vFGT
    vFGT = pyfortiapi.FortiGate(ipaddr="172.18.43.72",
                                  username="admin",password="123",
                                  vdom = 'autotest')  
    policies = vFGT.get_firewall_policy()
    mlog(policies)
    my_policy = vFGT.get_firewall_policy(1)

    return my_policy
    
def demo_api():
    import pyfortiapi
    mlog('@@@@@@@@@@ '+whoami()+'@@@@@@@@@@ ')
    before = vFGT.get_firewall_address('Test')
    address_payload = "{'name': 'Test', 'type': 'subnet', 'subnet': '192.168.0.0 255.255.255.0'}"
    vFGT.create_firewall_address('Test', address_payload)
    after = vFGT.get_firewall_address('Test')
    vFGT.delete_firewall_address('Test')
    return before,after

def update_policy():
    mlog('@@@@@@@@@@ '+whoami()+'@@@@@@@@@@ ') 
    vFGT.update_firewall_policy(1,"{'utm-status': 'enable'}")
    vFGT.update_firewall_policy(1,"{'av-profile':'g-default'}")
    return vFGT.get_firewall_policy(1)
        
def assertContain(self, msg, a, b):
    if b in a:
        Logger.warning(msg + '---' + b + ': pass')
    else:
        Logger.warning(msg + '---' + b + ': fail')

import paramiko
output_file = 'paramiko.org'


def paramiko_GKG(hostname, command):
	print('running')
	try:
		port = '22'
		
		# created client using paramiko
		client = paramiko.SSHClient()
		
		# here we are loading the system
		# host keys
		client.load_system_host_keys()
        #client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
		
		# connecting paramiko using host
		# name and password
		client.connect(hostname, port=22, username='admin',
					password='')
		
		# below line command will actually
		# execute in your remote machine
		(stdin, stdout, stderr) = client.exec_command(command)
		
		# redirecting all the output in cmd_output
		# variable
		cmd_output = stdout.read()
		print('log printing: ', command, cmd_output)
		
		# we are creating file which will read our
		# cmd_output and write it in output_file
		with open(output_file, "w+") as file:
			file.write(str(cmd_output))
			
		# we are returning the output
		return output_file
	finally:
		client.close()


def cmdformat(policytype,policyid):
    cmds = """
    config firewall {}
    edit {}
    unset webfilter-profile
    end
    """ .format(policytype,policyid)

    return cmds 

if __name__ == '__main__':   
    
    res = runClientCmd('ls')
    mlog(res)
    #res = runLocalCmd('/bin/ping 8.8.8.8')    
   
    res = runClientCmd('curl')
    mlog(res)
    #res = runLocalCmd('ping  -c 4 8.8.8.8')
    mlog(res)
    mlog (getPolicy())
    mlog(demo_api())
    mlog(update_policy())

    # Driver Code
    exec_code()
    cmds=['config webfilter profile', 'edit web_category', 'set feature-set proxy', 'config ftgd-wf', 'config filters', 'edit 41', 'set category 41', 
            'set action block', 'next', 'edit 31', 'set category 31', 'set action monitor', 'next', 'edit 51', 'set category 51', 'set action warning', 'end','end', 'end']
        
    for cmd in cmds:
        paramiko_GKG('172.18.43.64', cmd)
    
    mlog(cmdformat('proxy-policy','200'))





    