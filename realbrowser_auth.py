# from smbprotocol.exceptions import SMBResponseException
# from smbprotocol.connection import Connection
# from smbprotocol.create_contexts import CreateContextName, \
#     SMB2CreateContextRequest, SMB2CreateQueryMaximalAccessRequest
# from smbprotocol.security_descriptor import AccessAllowedAce, AccessMask, \
#     AclPacket, SDControl, SIDPacket, SMB2CreateSDBuffer
# from smbprotocol.session import Session
# from smbprotocol.open import CreateDisposition, CreateOptions, \
#     FileAttributes, FilePipePrinterAccessMask, ImpersonationLevel, Open, \
#     ShareAccess
# from smbprotocol.tree import TreeConnect
# from smbprotocol.connection import CompressionAlgorithms

from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.firefox_binary import FirefoxBinary
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

import random
import string
import uuid
import time
import argparse
import os
import json
import sys
import requests

import logging
from os import getenv as os_getenv


class RealBrowser(Object):
    """
    This is the abstract  class which should be subclassed.
    """
    client = None
    timeout = 30
    screen_width = None
    screen_height = None

    def __init__(self):
        super(RealBrowser, self).__init__()
        if self.screen_width is None:
            raise LocustError("You must specify a screen_width "
                              "for the browser")
        if self.screen_height is None:
            raise LocustError("You must specify a screen_height "
                              "for the browser")
        self.proxy_server = os_getenv("BROWSER_PROXY", None)


class RBChrome(RealBrowser):
    """
    Provides a Chrome webdriver  
    """
    def __init__(self):
        super(RBChrome, self).__init__()
        options = webdriver.ChromeOptions()
        if self.proxy_server:
            _LOGGER.info('Using proxy: ' + self.proxy_server)
            options.add_argument('proxy-server={}'.format(self.proxy_server))
        self.client = RealBrowserClient(
            webdriver.Chrome(chrome_options=options),
            self.timeout,
            self.screen_width,
            self.screen_height
        )


class HeadlessChrome(RealBrowser):
    """
    Provides a headless Chrome webdriver  
    """
    def __init__(self):
        super(HeadlessChrome, self).__init__()
        options = webdriver.ChromeOptions()
        options.add_argument('headless')
        options.add_argument('window-size={}x{}'.format(
            self.screen_width, self.screen_height
        ))
        options.add_argument('disable-gpu')
        if self.proxy_server:
            _LOGGER.info('Using proxy: ' + self.proxy_server)
            options.add_argument('proxy-server={}'.format(self.proxy_server))
        driver = webdriver.Chrome(chrome_options=options)
        _LOGGER.info('Actually trying to run headless Chrome')
        self.client = RealBrowserClient(
            driver,
            self.timeout,
            self.screen_width,
            self.screen_height,
            set_window=False
        )


class RBFirefox(RealBrowser):
    """
    Provides a Firefox webdriver  
    """
    def __init__(self):
        super(RBFirefox, self).__init__()
      
        op = Options()
        op.set_preference('intl.accept_languages', 'en-GB')
        op.headless = False

        profile = webdriver.FirefoxProfile()       
        profile.accept_untrusted_certs = True
        profile.set_preference('intl.accept_languages','en-US, en')    
        profile.set_preference("browser.link.open_newwindow.restriction", 0)

        binary = FirefoxBinary("/home/smb/ama/driver/firefox/firefox")
        driver = webdriver.Firefox(executable_path='/home/smb/ama/driver/geckodriver', firefox_binary=binary, \
            options=op, firefox_profile=profile)

        self.client = RealBrowserClient(
        driver,
        self.timeout,
        self.screen_width,
        self.screen_height )
       

class RealBrowserClient(object):
    """
    Web Driver client with Locust functionality, return self.client as webdriver 
    """

    def __init__(self, driver, wait_time_to_finish, screen_width,
                 screen_height, set_window=True):
        self.driver = driver
        if set_window:
            self.driver.set_window_size(screen_width, screen_height)
        self.wait = WebDriverWait(self.driver, wait_time_to_finish)

    def __getattr__(self, attr):
        """
        Forward all messages this client doesn't understand to it's webdriver
        """
        return getattr(self.driver, attr)


class Configurations(object):

    def __init__(self):
        self.connections = []
        self.sessions = []
        self.trees = []

    def add_connection(self, connection):
        self.connections.append(connection)

    def add_session(self, session):
        self.sessions.append(session)

    def add_tree(self, tree):
        self.trees.append(tree)

def generate_random_data(length_range):
    def random_string(length):
        alphabet = string.ascii_letters
        data = ''.join(random.choice(alphabet) for i in range(length))
        return data

    length = random.randint(length_range[0], length_range[1])
    return random_string(length)


def sequential_ranges(begin, end, max_length):
    ranges = []
    curr = begin
    while curr != end:
        len = random.randint(1, min(end - curr, max_length))
        ranges.append([curr, curr + len])
        curr += len
    return ranges


def overlapping_ranges_simple(begin, end, max_length):
    n = random.randint(1, min((end - begin) / 4, max_length))
    return [[i, i + n] for i in range(0, max(max_length, end - begin), n)]


def overlapping_ranges_heavy(begin, end, max_length):
    ranges = sequential_ranges(begin, end, max_length)
    limit = len(ranges)
    for i in range(limit):
        x = random.randint(begin, end-1)
        l = random.randint(1, max_length)
        if x + l > end:
            l = end - x
        ranges.append([x, x + l])

    random.shuffle(ranges)
    return ranges


def whole_range(begin, end, max_length):
    if end - begin <= max_length:
        return [[begin, end]]

    ranges = []
    start = begin
    for i in range(max_length - 1, end, max_length - 1):
        ranges.append([start, i])
        start = i
    if start != end:
        ranges.append([start, end])
    return ranges

def process_data_tuple(conf, tuple):
    type = tuple['type']
    if type == DataTuple.RANDOMLY_GENERATED:
        print(f"Generating Random files")
        handle_random_data_query(conf, tuple)
    elif type == DataTuple.ACTUAL_FILE:
        print(f"Reading actual file")
        handle_actual_data_query(conf, tuple)


if __name__ == '__main__':
    cmd_parser = argparse.ArgumentParser(description="Real Brower Auth")
    cmd_parser.add_argument("--url", required=True, help="web server url ", default="http://172.18.2.169")
    cmd_parser.add_argument("--port", type=int, required=True, help="Server Port", default=80)
    cmd_parser.add_argument("--username", required=True, help="Username")
    cmd_parser.add_argument("--password", required=True, help="Password")
    cmd_parser.add_argument("--scheme", type=str, default="ldap", help=" auth scheme "
                                                                          "0x0202 = ldap"
                                                                          "0x0210 = ntlm"
                                                                          "0x0300 = form"
                                                                          "0x0302 = kerb"
                                                                          "0x0311 = saml"
                                                                          "0x02FF = radius")
    cmd_parser.add_argument("--share", required=True, help="Share name")
    cmd_parser.add_argument("--encrypt", required=True, type=int, help="Enable encryption")
    cmd_parser.add_argument("--compress", required=True, type=int,
                            help="Compression type [0-3] 0 => NONE, 1 => LZNT1, 2 => LZ77, 3 => LZ77+Huffman")
    cmd_parser.add_argument("--data-tuples", required=True, help="The data tuples themselves")
    cmd_parser.add_argument("--seed", type=int, default=0, help="Seed set for reproducablity")

    args = cmd_parser.parse_args()
    url = args.url
    port = args.port
    username = args.username
    password = args.password
    #share = r"\\%s\%s" % (server, args.share) # treated as raw string 
 
    #driver = self.__init_firefox_driver()
    driver = RBFirefox.client  ####????? ok????
    try:
        if __name__ == "__main__":
            driver.maximize_window()


        
        driver.get("http://adu3:12345678@172.18.2.169")

        driver.get("http://172.18.2.169")
        driver.find_element_by_id("ft_un").send_keys(self.user)
        time.sleep(0.2)
        driver.find_element_by_id("ft_pd").send_keys(self.passwd)
        time.sleep(0.4)
        #driver.find_element_by_type("submit").send_keys()
        driver.find_element_by_class_name("primary").click()   

           


