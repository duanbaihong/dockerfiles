#!/usr/bin/python
#-*- coding: UTF-8 -*-
import os
import sys
import yaml
import commands


class iptables():
    """docstring for iptables"""

    def __init__(self, config={}, username='', ip=''):
        self.config = config
        self.ipaddr = ip
        self.username = username

    def runExec(self):
        if self.username != "":
            parent = os.path.dirname(
                os.path.dirname(os.path.abspath(__file__)))
            with open("%s/run/%s" % (parent, self.username), 'r') as user_file:
                user_group = user_file.read().split("||")
                permiss = user_group[0]
            if permiss != "":
                comment = "-m comment --comment '用户[{}->{}]的策略！".format(
                    self.username, permiss)
                if len(user_group) > 1:
                    comment = "{}{}'".format(comment, user_group[1])
                cmd = "sudo -u root /sbin/iptables -I FORWARD -s {}/32 -j {} {}".format(
                    self.ipaddr, permiss, comment)
                status, results = commands.getstatusoutput(cmd)
                if status != 0:
                    print "策略[\033[33m{}\033[0m]添加\033[31m失败\033[0m！\n{}".format(cmd.replace('sudo -u root /sbin/', ''), results)
                else:
                    print "策略[\033[33m{}\033[0m]添加\033[31m成功\033[0m！".format(cmd.replace('sudo -u root /sbin/', ''))

    def add(self):
        self.runExec()
        return self

    def delete(self):
        cmd = "for i in `seq 1 $(sudo -u root /sbin/iptables -L FORWARD -n |awk '{print $4}'|egrep \"^%s$\" -c)`; do sudo -u root /sbin/iptables -L FORWARD --line-number |awk '{print $1\":\"$5}'|egrep \"^[0-9]+:%s$\"|head -1|awk -F\":\" '{print $1}'|xargs sudo -u root /sbin/iptables -w -D FORWARD; done" % (
            self.ipaddr, self.ipaddr)
        print "DELETE: \033[31m%s\033[0m" % cmd.replace('sudo -u root /sbin/', '')
        status, results = commands.getstatusoutput(cmd)
        print "删除策略成功！"
        return self

    def update(self):
        self.delete().add()
        return self

    def reloadacl(self):
        for chain in self.config:
            createChaincmd = "sudo -u root /sbin/iptables -N {} || sudo -u root /sbin/iptables -F {}".format(
                chain, chain)
            status, results = commands.getstatusoutput(createChaincmd)
            for rule in self.config[chain]:
                comment = "-m comment --comment '组[{}]的策略！'".format(chain)
                cmd = "sudo -u root /sbin/iptables -A {} {} {}".format(
                    chain, rule, comment)
                status, results = commands.getstatusoutput(cmd)
                if status != 0:
                    print "添加策略[\033[33m{}\033[0m]添加\033[31m失败\033[0m！\n{}".format(cmd.replace('sudo -u root /sbin/', ''), results)
                else:
                    print "添加策略[\033[33m{}\033[0m]添加\033[31m成功\033[0m！".format(cmd.replace('sudo -u root /sbin/', ''))
            commoncmd = "sudo -u root /sbin/iptables -A {} -p tcp --dport 53 -j ACCEPT -m comment --comment '通用DNS策略';\
            sudo -u root /sbin/iptables -A {} -p udp --dport 53 -j ACCEPT -m comment --comment '通用DNS策略';\
            sudo -u root /sbin/iptables -A {} -p all -j DROP -m comment --comment '通用拒绝策略'".format(
                chain, chain, chain)
            status, results = commands.getstatusoutput(commoncmd)
            print "添加通用拒绝策略成功！"


if __name__ == '__main__':
    argvs = sys.argv
    print argvs
    if len(argvs) < 2:
        sys.exit(1)
    # 获取父目录,并读取配置文件里的内容
    argcmd = argvs[1]
    username = argvs[3] if len(argvs) > 3 else ""
    local_ip = argvs[2] if len(argvs) > 2 else ""

    curPath = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    yamlConfig = os.path.join(curPath, 'etc', "config.yml")
    with open(yamlConfig, 'r') as filecfg:
        cfg = filecfg.read()
    config = yaml.load(cfg)
    ipt = iptables(config['iptablerules'], username, local_ip)
    file = os.path.join(curPath, 'run', "reloadacl")
    if not os.path.exists(file):
        os.mknod(file)
        ipt.reloadacl()

    if argcmd in ["add", "update", "delete", "reloadacl"]:
        getattr(ipt, argcmd)()
