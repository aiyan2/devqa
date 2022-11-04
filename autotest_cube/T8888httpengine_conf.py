class T88888HTTPENGINE_CONF :
    @classmethod 
    def web_proxy(self,lan, wan='port1', policyid='1',port='8080'):
        cmds ="""
        config web-proxy explicit
            set status enable
            set http-incoming-port {port}
            set https-incoming-port {port}
            end

        config system interface
        edit {lan}          
            set explicit-web-proxy enable
        next
        edit {wan}
            set explicit-web-proxy enable
        next
        end

        config firewall proxy-policy
        edit {policyid}    
            set name {policyid}
            set proxy explicit-web
            set dstintf {wan}
            set srcaddr "all"
            set dstaddr "all"
            set service "webproxy"
            set action accept
            set utm enable
            set schedule "always"
        next
        end

        """.format(port=port,policyid=policyid,lan=lan,wan=wan)

        return cmds

    @classmethod
    def trans_proxy(self,lan, wan='port1', policyid='20'):
        cmds = """      
config firewall policy
    edit {policyid}
        set name {policyid}
        set srcintf {lan}
        set dstintf {wan}
        set action accept
        set srcaddr "all"
        set dstaddr "all"
        set schedule "always"
        set service "ALL"
        set inspection-mode proxy
        set http-policy-redirect enable
        set nat enable
    next
end

config firewall proxy-policy
    edit {policyid}
        set proxy transparent-web
        set name {policyid}
        set srcintf {lan}
        set dstintf {wan}
        set srcaddr "all"
        set dstaddr "all"
        set service "webproxy"
        set action accept
        set schedule "always"
        set utm enable
    next
end
        """.format(policyid=policyid,lan=lan,wan=wan)
        return cmds

    @classmethod
    def revert(self,webproxyid='1',transproxyid='20'):
        cmds = """ 
        
        config firewall policy
        del 1 
        del {transproxyid}       
        purge \ny
        end

        config firewall proxy-policy
        del {webproxyid}
        del {transproxyid}   
        purge \ny
        end

        config  webfilter profile
            del block-it
        end
        
        """.format(webproxyid=webproxyid,transproxyid=transproxyid)
        return cmds


   