##############################################################################################
'''
Library for SSH connection.
SSH (secure shell) to remotely managing machines using a secure connection.
Log in to a server using the command-line tool over SSH using Paramiko package.

Name    : ssh.py
Company : Fortinet
Time    : July 20, 2021
Author  : Jerry Liu (ljerry@fortinet.com)
'''
##############################################################################################

import os
import sys
import time
import socket
import paramiko
import traceback
import threading


class SSH():

    def __init__(self, logger, host_ip, port=22, username='', password='', key='',
                 jump_host_ip='', jump_port=22, jump_usr='', jump_pwd='', jump_key='', jump_client=None,
                 timeout=300):
        '''
        logger: logger()
            logger class
        host_ip: str
            IP address of device
        port: int
            SSH port of client
        username: str
            SSH client username
        password: str
            SSH client password
        key: str
            id_rsa key of SSH client
        jump_host_ip: str
            SSH IP of jump host client
        jump_port: int
            SSH port of jump host client
        jump_usr: str
            SSH username of jump host client
        jump_pwd: str
            SSH password of jump host client
        jump_key: str
            id_rsa key of jump host client

        timeout: int
            Socket timeout in seconds (Default timeout 300s)
        '''
        try:
            socket.inet_aton(host_ip)
        except socket.error:
            raise Exception('Invalid Host IP')

        if port < 1 or port > 65535:
            raise Exception('Invalid SSH PORT')

        self.logger = logger

        self.host_ip = host_ip
        self.port = port
        self.usr = username
        self.pwd = password
        self.key = key

        self.jump_client = jump_client
        self.jump_host_ip = jump_host_ip
        self.jump_port = jump_port
        self.jump_usr = jump_usr
        self.jump_pwd = jump_pwd
        self.jump_key = jump_key

        self.timeout = timeout
        self.channel = None
        self.transport = None
        self.client = None

        self._create_connection()

    def _create_connection(self):
        '''
        create ssh connection.

        Returns
        ----------
        None
        '''
        if self.jump_client != None:
            self.client = self._create_connection_via_jump_host_ip(self.jump_client)
            self._create_channel()
        elif self.jump_host_ip != '' and self.jump_client == None:
            self.jump_client = self._create_client(self.jump_host_ip, self.jump_port, self.jump_usr, self.pwd, self.jump_key)
            self.client = self._create_connection_via_jump_host_ip(self.jump_client)
            self._create_channel()
        else:
            self.client = self._create_client(self.host_ip, self.port, self.usr, self.pwd, self.key)
            self._create_channel()

    def _create_connection_via_jump_host_ip(self, jump_host_ip):
        '''
        create ssh connection using a jump host client

        Parameters
        ----------
        jump_host_ip: SSH()
            SSH jump host client

        Returns
        ----------
        None
        '''
        try:
            jump_host_ip_transport = jump_host_ip.get_transport()
            jump_ip, jump_port = jump_host_ip_transport.getpeername()
            src_addr = (jump_ip, 22)
            dst_addr = (self.host_ip, 22)
            jump_host_ip_channel = jump_host_ip_transport.open_channel('direct-tcpip', dst_addr, src_addr)
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(hostname=self.host_ip, port=self.port, username=self.usr, password=self.pwd, sock=jump_host_ip_channel)
            return client
        except Exception as e:
            traceback.print_tb(e.__traceback__)
            raise e

    def _create_client(self, ip, port, usr, pwd, key=''):
        '''
        Create paramiko SSH client using key or password

        Parameters
        ----------
        ip: string
            SSH host ip
        port: int
            SSH host port
        usr: string
            SSH login username
        pwd: string
            SSH login password
        key: string
            SSH login rsd key file

        Returns
        ----------
        client: SSH()
            SSH client object
        '''
        try:
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            if key == '':
                client.connect(hostname=ip, port=port, username=usr, password=pwd, timeout=self.timeout)
            else:
                client.connect(hostname=ip, port=port, username=usr, key_filename=key, timeout=self.timeout)
            return client
        except Exception as e:
            traceback.print_tb(e.__traceback__)
            raise e

    def _create_channel(self):
        '''
        Create paramiko channel class

        Returns
        ----------
        None
        '''
        try:
            self.transport = self.client.get_transport()
            self.channel = self.transport.open_session()
            self.channel.settimeout(self.timeout)
            self.channel.get_pty()
            self.channel.invoke_shell()
        except Exception as e:
            traceback.print_tb(e.__traceback__)
            raise e

    def close(self):
        '''
        End paramiko ssh session and close SSH channel and transport

        Returns
        ----------
        None
        '''
        try:
            self.channel.close()
            self.transport.close()
            self.client.close()
        except Exception as e:
            traceback.print_tb(e.__traceback__)
            raise e

    def exec_cmd(self, cmd, sleep=0, queue=None, verbose=False):
        '''
        Run CMD on SSH client

        Parameters
        ----------
        cmd: string
            CMD to be run
        sleep: int
            Sleep in seconds after cmd is executed
        queue: queue
            Queue for getting multi-thread results and/or error outputs

        Returns
        ----------
        stdout: string
            Output of command
        '''
        try:
            stdin, stdout, stderr = self.client.exec_command(cmd)
            out = stdout.read().decode('utf-8')
            err = stderr.read().decode('utf-8')

            if verbose:
                self.logger.info('CMD: ' + repr(cmd))
                self.logger.info('OUT: ' + repr(out))
                self.logger.error('ERR: ' + repr(err))

            time.sleep(sleep)

            if queue != None:
                queue.put(out)
                queue.put(err)

            return out, err
        except Exception as e:
            self.close()
            traceback.print_tb(e.__traceback__)
            raise e

    def exec_cmd_listen(self, cmd, io=None, timeout=60, expect_str='', queue=None, verbose=False):
        '''
        Run SSH command and listen to output

        Parameters
        ----------
        cmd: string
            Command to be run
        io: list
            list of receive and send tuples
        timeout: int
            shell time out, will end shell session when time out is reached
        expect_str: string
            expected string to be searched, will end shell session when found
        queue: queue
            queue for getting multi-thread results
        verbose: boolean
            print debug info

        Returns
        ----------
        stdout: string
            output of command
        '''
        data = ''
        io_list = io
        channel = self.client.invoke_shell()
        channel.timeout = timeout
        channel.send(cmd + '\n')
        while not channel.recv_ready(): time.sleep(5)
        current_time = time.time()
        try:
            while time.time() - current_time < timeout:
                if channel.recv_ready():
                    stdout = channel.recv(9999)
                    data = data + stdout.decode('ascii')

                    if io_list and len(io_list) > 0:
                        for receive, send in io_list:
                            if receive in stdout.decode('ascii'):
                                channel.send(send + '\n')

                    if verbose:
                        sys.stdout.write('[' + str(threading.get_ident()) + ']')
                        sys.stdout.write(stdout.decode('ascii') + '\n')
                    if expect_str in data and expect_str != '': break
            if queue != None: queue.put(data)
            return data
        except socket.timeout:
            return data
        except Exception as e:
            self.close()
            traceback.print_tb(e.__traceback__)
            raise e

    def send(self, cmd):
        '''
        send the command via ssh channel.

        Parameters
        ----------
        cmd: string
            command content

        Returns
        ----------
        None
        '''
        try:
            self.channel.send(cmd + '\n')
        except Exception as e:
            self.close()
            traceback.print_tb(e.__traceback__)
            raise e

    def receive(self, timeout=60, expect_str='', queue=None, verbose=False):
        '''
        Receive SSH output

        Parameters
        ----------
        timeout: int
            socket timeout
        expect_str: string
             Stop reading from socket if expected string is found
        queue: queue
            Queue for output
        verbose: boolean
            print to logger if True

        Returns
        ----------
        data: string
            Command output
        '''
        data = ''
        self.channel.settimeout(timeout)
        current_time = time.time()
        try:
            while time.time() - current_time < timeout:
                if self.channel.recv_ready():
                    stdout = self.channel.recv(9999)
                    data += stdout.decode('utf-8')
                    if verbose: sys.stdout.write(stdout.decode('ascii'))
                    if expect_str in data and expect_str != '': break
            if queue != None: queue.put(data)
            return data
        except socket.timeout:
            return data
        except Exception as e:
            self.close()
            traceback.print_tb(e.__traceback__)
            raise e



if __name__ == '__main__': 
    from logging import Logger
    logger = Logger
    ssh = SSH(logger=logger, host_ip='172.18.43.72', username='admin', password='123')
    cmds = ['config vdom', 'edit autotest2', 'next', 'end']
    for cmd in cmds:
        ssh.send(cmd)
    time.sleep(1)
    ssh.close()

   
