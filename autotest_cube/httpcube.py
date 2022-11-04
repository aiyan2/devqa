
import innovator as inv
from innovator import mlog, whoami

class HTTPCUBE:

    vfgt, vserver = None, None
    def __init__(self,fgt,vserver=None) -> None:
        global vfgt
        vfgt= fgt
        vserver = vserver 

    class POW: ## could be a list 
        result = True # pass/fail
        fgtconfig_summary= None # summary of config added 
        trafficline = None # clientTool+paramers+server 
        teardown =False # config removed after work done
        expect =None
        actural = None
        def __init__(self,result,fgtconfig_summary, trafficline,teardonw,expect,actural) -> None:
            self.result =    result
            self.fgtconfig_summary = fgtconfig_summary
            self.trafficline = trafficline
            self.teardown = teardonw
            self.expect = expect 
            self.actural = actural                 

    ## Proxy includes: web-proxy, trans-proxy and ztna (access-proxy)  
    def get_policytype(self,proxy):
        policytype = 'policy'
        if proxy:
            policytype = 'proxy-policy' 
        return policytype    

    def webfilter_cube(self, policyid,proxy=None,teardown='y'):
        testserver ='www.fortinet.com'
        testserverF = 'www.ubc.ca'
        profile_name = 'webfilter-profile'
        wbf_name = 'block-it'

        mlog(whoami()+"creating wbf profle block-it at test fgt.....")
        cmds = """
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
        """  .format(wbf_name)    

        cmdlog = vfgt.fgtconfig(cmds.split('\n'))
        mlog(whoami()+cmdlog)
                
        policytype = self.get_policytype(proxy)
        inv.mlog(whoami()+"setting firewal {}:{}:{}:{}".format(policytype,policyid,profile_name,wbf_name))              
        
        cmds = update_policy_set(policytype,policyid,profile_name,wbf_name)        
        cmdlog=vfgt.fgtconfig(cmds.split('\n')) 
        mlog(whoami()+'cmds as'+cmdlog)  
             
        # test block 
        res = self.GET(testserver,proxy)
        inv.mlog(whoami()+'accessing '+testserver)
        inv.assertContain(res, 'Web Page Blocked')
        
        ##@@res = self.POST('/etc/hosts', testserver,proxy)
        #inv.assertContain(res, 'Web Page Blocked') 
                
        inv.mlog(whoami()+"testing allow on"+testserverF)
        resf = self.GET(testserverF,proxy)
        inv.assertNotContain(res, 'Web Page Blocked')

        if (teardown =='y'):
            inv.mlog(whoami()+"unset  {} of {} ".format(policyid,profile_name))
            cmds = update_policy_unset(policytype,policyid,profile_name)
            vfgt.fgtconfig(cmds)  

        return HTTPCUBE.POW(result=True,fgtconfig_summary='create webfiter-profile'+wbf_name,\
             trafficline='curl '+testserver+' '+testserverF, expect='BLOCK/PASS', \
                actural= res + '//' +resf, teardonw=teardown)
            
    def av_cube(self, policyid):
        pass
    
    def ssl_inspection_cube(self,policyid,proxy=None,inspection_type='certificate-inspection',teardown='no'):
        profile_name ='ssl-ssh-profile'
        profile_value = inspection_type #certificate-inspection, deep-insepction, inspect_all 
        policytype = self.get_policytype(proxy)    

        mlog(whoami()+" attaching the {} to {}".format(profile_name,policyid))       
        
        cmds = update_policy_set(policytype,policyid,profile_name,profile_value)   
        cmdslog = vfgt.fgtconfig(cmds.split('\n'))  
        mlog (whoami()+cmdslog)

        ## @todo
        # res = self.GET('www.bing.com',proxy)
        # inv.mlog(res)
        # inv.assertContain('@todo', res) 

        if (teardown =='y'):
            inv.mlog(whoami()+"unset  {} of {} ",policyid,profile_name)

            cmds = update_policy_unset(policytype,policyid,profile_name)
            cmdslog = vfgt.fgtconfig(cmds.split('\n'))  
            mlog (whoami()+cmdslog)

    def basic_auth(self,policyid,proxy=None,vServer=None,teardown='yes'):

        username = 'lu1'    
        password = '12345678'  
        grp = 'local_group'      

        cmds = """
       config user local
            edit {uid}
                set type password
                set passwd {password}
            next
            end

        config user group
            edit {group}
                set member {uid}
            next
            end

        config authentication scheme
            edit "basic"
                set method basic
                set user-database "local-user-db"
            next
            end

        config authentication rule
            edit "1"
                set srcaddr "all"
                set ip-based disable
                set active-auth-method "basic"
            next
            end
       """.format (uid= username,password= password,group=grp)
       
        inv.mlog(whoami()+'config auth user,group,scheme and rule')
        cmdslog = vfgt.fgtconfig(cmds.split('\n'))  
        mlog (whoami()+cmdslog) 
        
        inv.mlog(whoami()+'attach to policy')
        policytype = self.get_policytype(proxy)
        cmds=update_policy_set(policytype,policyid,'groups',grp)
        cmdslog = vfgt.fgtconfig(cmds.split('\n'))  
        mlog (whoami()+cmdslog)
        
        self.testserver = 'www.httpbin.org'

        def auth(password):
            if proxy:
                cmd=' -I -x {0} https://{1} --proxy-user {2}:{3}'.format(proxy,self.testserver,username,password)
            else:
                cmd=' -I https://{1} --user {2}:{3}'.format(proxy,self.testserver,username,password) 
            mlog(whoami()+' curl '+cmd)       
            res = inv.vClient.curl(cmd.split(' '))
            return res

        #postive test: correct passwd
        mlog(whoami()+'postive test: correct password')
        res= auth(password=password)
        mlog (whoami()+res)
        inv.assertContain (res,'200 Connection established')

        # negtive test: wrong passwd  
        mlog(whoami()+'negtive test: wrong password')
        res = auth(password='wrongpasswd')
        mlog (whoami()+res)
        inv.assertContain (res,'authentication required')

    def fwdserver_cube(elf,policyid,proxy=None,vServer=None,teardown='yes'):
        pass 
    
    def GET(self,url,proxy=None):
        import subprocess
        if proxy and ':' in proxy:  # exp web proxy, not trans/accee proxy
            inv.mlog(whoami()+'proxy:'+proxy)
            url +=" -x " +str(proxy)             
        inv.mlog (whoami()+" cmd as: curl -k "+ url)

        p = subprocess.Popen("curl -k  "+url + " 2>&1", stdout=subprocess.PIPE, shell=True)
        stdout, err = p.communicate()
        p.terminate()
        if err:
            raise Exception ('curl err:'+err)
        return stdout.decode ('ascii').strip()

    
    def POST(self,file,url, proxy=None):
        url += '-F "file=@'+file 
        HTTPCUBE.GET(url,proxy)

def update_policy_set(policytype,policyid,field,value):
    cmds = """
        config firewall {}
            edit {}
            set {} {}
        next
        end
    """ .format(policytype,policyid,field,value)

    return cmds 
def update_policy_unset(policytype,policyid,field):
    cmds = """
        config firewall {}
            edit {}
            unset {} 
        next
        end
    """ .format(policytype,policyid,field)

    return cmds 

if __name__ == '__main__':   
   inv.mlog ('start')

   fgt = inv.vFGT(fgtip='172.18.43.72', admin='admin',adminpasswd= '123')
   server = inv.vServer(serverip='172.18.43.100')

   tc = HTTPCUBE(fgt,server)
   ##tc.__getattribute__ 
   tc.GET('172.18.43.100')
   inv.mlog(tc.GET('172.18.43.100','172.18.43.67:8080'))
   tc.GET('172.18.43.100',proxy = 'ztna')

   tc.webfilter_cube('1')
   tc.webfilter_cube('1','172.18.43.72:8080')

   lcmd='curl -k -I https://www.httpbin.org --user lu1:12345678'
   #tc.runLocalcmd(lcmd) 
   # err: [Errno 2] No such file or directory: 'curl -k -I https://www.httpbin.org --user lu1:12345678'
   mlog(inv.vClient.curl('-I https://www.httpbin.org --user lu1:12345678'.split(' ')))