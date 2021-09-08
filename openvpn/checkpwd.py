#!/usr/bin/python
#-*- coding: UTF-8 -*-
import sys,os
import re
import ldap
import yaml

class LDAPTool:
    def __init__(self,config=dict()):
        self.ldap_config = {
            'LDAP_HOST'                 : 'ldap://127.0.0.1',
            'LDAP_BIND_USER'            : 'cn=admin,ou=xxxx,dc=xxx,dc=xx',
            'LDAP_BIND_PASS'            : 'xxxxxxx',
            'LDAP_BASE_DN'              : 'dc=xxx,dc=xx',
            'LDAP_USER_OU'              : 'ou=Users',
            'LDAP_USER_FIELD'           : 'uid',
            'LDAP_GROUP_OU'             : 'ou=OpenVPN,ou=Groups',
            'LDAP_GROUP_FILTER_EXTR'    : '(|(objectclass=groupOfNames)(objectclass=groupOfUniqueNames)(objectclass=posixGroup))',
            'LDAP_GROUP_FILTER_FIELD'   : 'uniqueMember',
            'LDAP_GROUP_FIELD'          : 'cn,description',
            'LDAP_USERNAME'             : 'test1',
            'LDAP_PASSWORD'             : '123456'
        }
        if type(config) == dict:
            self.ldap_config.update(config)
            self.user_dn = "%s=%s,%s,%s"%(
                self.ldap_config['LDAP_USER_FIELD'],
                self.ldap_config['LDAP_USERNAME'],
                self.ldap_config['LDAP_USER_OU'],
                self.ldap_config['LDAP_BASE_DN'])
            self.ldap_config['LDAP_GROUP_FILTER']="(&(%s=%s)%s)"%(
                self.ldap_config['LDAP_GROUP_FILTER_FIELD'],
                self.user_dn,
                self.ldap_config['LDAP_GROUP_FILTER_EXTR'])
            pattern=r'^ldap://(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
            if not re.match(pattern,self.ldap_config['LDAP_HOST']):
                raise "LDAP HOST 格式不正确。"
            try:
                self.ldapconn= ldap.initialize(self.ldap_config['LDAP_HOST'])
            except ldap.LDAPError,e:
                print e
        else:
            raise "config is not dict!"
 
    def ldap_get_group(self):
        try:
            self.ldapconn.simple_bind(self.ldap_config['LDAP_BIND_USER'],self.ldap_config['LDAP_BIND_PASS'])
        except ldap.LDAPError,e:
            return e
        obj = self.ldapconn
        obj.protocal_version = ldap.VERSION3
        searchScope = ldap.SCOPE_SUBTREE
        groupAttributes = self.ldap_config['LDAP_GROUP_FIELD'].split(',')
        searchFilter = "%s"%(self.ldap_config['LDAP_GROUP_FILTER'])
        try:
            ldap_result_id = obj.search(
                "%s,%s"%(self.ldap_config['LDAP_GROUP_OU'],self.ldap_config['LDAP_BASE_DN']), 
                searchScope, 
                searchFilter, 
                groupAttributes)
            result_type, result_data = obj.result(ldap_result_id,0)
            groups=[]
            if result_type == ldap.RES_SEARCH_ENTRY and len(result_data)>0:
                for field in groupAttributes:
                    groups.append(result_data[0][1][field][0])
                parent = os.path.dirname(os.path.dirname(__file__))
                with open("%s/run/%s"%(parent,self.ldap_config['LDAP_USERNAME']),'w') as user_file:
                    user_file.write('||'.join(groups))
                return True
            else:
                return None
        except ldap.LDAPError, e:
            return e
         
    #用户验证，根据传递来的用户名和密码，搜索LDAP，返回boolean值
    def ldap_identify_user(self):
        obj = self.ldapconn
        try:
            if obj.simple_bind_s(self.user_dn,self.ldap_config['LDAP_PASSWORD']):
                return True
            else:
                return False
        except ldap.LDAPError,e:
            return e

if __name__ == '__main__':
    username=os.getenv('username')
    password=os.getenv('password')
    if username != "" and password != "":
        # 获取父目录,并读取配置文件里的内容
        curPath = os.path.dirname(os.path.dirname(__file__))
        yamlConfig = os.path.join(curPath,'etc', "auth-ldap.yml")
        with open(yamlConfig,'r') as filecfg:
            cfg=filecfg.read()
        baseCfg=yaml.load(cfg)
        config={
            'LDAP_USERNAME'     : username,
            'LDAP_PASSWORD'     : password
            }
        config.update(baseCfg['ldap_config'])
        ldap_obj=LDAPTool(config)
        check_group=ldap_obj.ldap_get_group()
        if check_group==True:
            check_user=ldap_obj.ldap_identify_user()
            if check_user == True:
                sys.exit(0)
            else:
                print check_user
                sys.exit(1)
        else:
            print check_group
            sys.exit(1)
    else:
        print "username or password error"
        sys.exit(1) 