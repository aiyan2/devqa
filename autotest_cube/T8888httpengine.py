
from T8888httpengine_conf import T88888HTTPENGINE_CONF as TASKCONF
import innovator as inv
from innovator import mlog, whoami
from httpcube import HTTPCUBE


class T88888HTTPENGINE:
    
    #logger = logging.getLogger(inv.whoami())   
    client, fgt, server = None, None,None
     
    def __init__(self,vfgt,vserver=None) -> None:
        mlog(inv.whoami()+'and creating test cube') 
        global fgt,  server, testcube
        fgt= vfgt
        fgt.lanIntf ='port8'
        fgt.wanIntf = 'port1'
        
        server = vserver
        testcube= HTTPCUBE(fgt,server)         
   
    def test_setup(self):        
        mlog (inv.whoami()+'Adding Test case specified config to test fgt '+fgt.fgtip)  
       
        if fgt.proxy:                  
            cmds =TASKCONF.web_proxy(lan=fgt.lanIntf,wan=fgt.wanIntf,policyid='1',port='8080')           
        else:           
            cmds = TASKCONF.trans_proxy(lan='port8',wan='port1',policyid='20')
        cmdlog = fgt.fgtconfig(cmds.split('\n'))  
        mlog(whoami()+cmdlog)
    
    # Nice to have, to test basic traffic flow OK , otherwise, env error and stops 
        mlog(whoami()+'test basic traffic flow ')       
        res = testcube.GET(server.ip,fgt.proxy)
        ll= len(res)
        mlog (whoami()+ res[ll-200:ll])  # get the last 200 characters in case more, to show imprtant mesg only
        inv.assertContain (res, 'Hello')                     
    
    def test_cic(self):
        mlog('\n\n\n\t'+whoami())
        testcube.ssl_inspection_cube(policyid='1',proxy=fgt.proxy,teardown='no')
        #TestCube.av_cube()
        testcube.webfilter_cube(policyid='1',proxy=fgt.proxy)
        testcube.basic_auth('1',fgt.proxy)

    def test_dpi(self):
        mlog('\n\n\n\t'+whoami())
        testcube.ssl_inspection_cube(policyid='1',proxy=fgt.proxy, inspection_type ='deep-inspection',teardown='no')
        testcube.av_cube(policyid='1')
        testcube.webfilter_cube('1',fgt.proxy)
        testcube.basic_auth('1',fgt.proxy)
        #testcube.fwdserver_cube('1',fgt.proxy,teardown='yes')
    def test_teardown(self):
        mlog(whoami()+'revert config of '+fgt.fgtip)
        #initfgt = 'exec factoryreset keepvmlicense'
        initfgt = TASKCONF.revert('1','20') 
        
        cmdlog = fgt.fgtconfig(initfgt.split('\n'))  
        mlog(whoami()+cmdlog)
        
    
if __name__ == '__main__': 
    import argparse
    cmd_parser = argparse.ArgumentParser(description="Test Cube demo")
    cmd_parser.add_argument("--fgtip", required=True, help="test fgt mgmt IP")      
    cmd_parser.add_argument("--adminpasswd", required=False, help=" FGT admin Password")
    cmd_parser.add_argument("--proxy", required=False, help="proxy ip:port")
    cmd_parser.add_argument("--serverip", required=False,default="172.18.43.100",help="test server ip")
     
    args = cmd_parser.parse_args()
 # python3 T8888httpengine.py --fgtip 172.18.43.72 --adminpasswd '123' --serverip 172.18.43.100 --proxy 172.18.43.72:8080
    
    fgt = inv.vFGT(fgtip=args.fgtip, admin='admin',adminpasswd= args.adminpasswd,proxy=args.proxy)
    server = inv.vServer(serverip=args.serverip)
    mlog(whoami()+'Creating vfgt {}, vserver {}.....'.format(fgt.fgtip,server.ip))
   
    tt = T88888HTTPENGINE(fgt,server)
    tt.test_teardown()
    tt.test_setup()

    tt.test_cic()
    
    tt.test_dpi()