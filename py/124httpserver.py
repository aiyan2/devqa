#!/usr/bin/env python3

import sys
import http.server
import socketserver
from urllib.parse import urlparse
from urllib.parse import parse_qs
import argparse
import logging

FORMAT = '%(asctime)-15s %(message)s'
REDIRECT_LINK="https://httpbin.org/ip"

class RedirReqHandler(http.server.SimpleHTTPRequestHandler):
   

    def do_case1(self):    # null-body-chunked
        query_components = parse_qs(urlparse(self.path).query)
        logging.debug("Got query: {}".format(query_components))
        self.send_response(307)
        self.send_header('Location', REDIRECT_LINK)
        self.send_header('Transfer-Encoding', 'chunked')
        self.send_header('Connecion', 'keep-alive')
        self.end_headers()
        self.wfile.write(b'0\r\n\r\n')

    def do_case2(self):    # half of the chunked data
        query_components = parse_qs(urlparse(self.path).query)
        logging.debug("Got query: {}".format(query_components))
        self.send_response(200)
        self.send_header('Transfer-Encoding', 'chunked')
        self.send_header('Connecion', 'keep-alive')
        self.end_headers()
        self.wfile.write(b'3\r\nlab\r\n')
        #self.close()
        httpd.shutdown()
        #self.wfile.write(b'0\r\n\r\n')

    def do_case3(self):  # handle post data: multi-part  
        boundary = self.headers.plisttext.split("=")[1]
        remainbytes = int(self.headers['content-length'])
        line = self.rfile.readline()
        remainbytes -= len(line)
        if not boundary in line:
            return (False, "Content NOT begin with boundary")
        line = self.rfile.readline()
        remainbytes -= len(line)
        fn = re.findall(r'Content-Disposition.*name="file"; filename="(.*)"', line)
        if not fn:
            return (False, "Can't find out file name...")
        path = self.translate_path(self.path)
        fn = os.path.join(path, fn[0])
        line = self.rfile.readline()
        remainbytes -= len(line)
        line = self.rfile.readline()
        remainbytes -= len(line)
        try:
            out = open(fn, 'wb')
        except IOError:
            return (False, "Can't create file to write, do you have permission to write?")
                
        preline = self.rfile.readline()
        remainbytes -= len(preline)
        while remainbytes > 0:
            line = self.rfile.readline()
            remainbytes -= len(line)
            if boundary in line:
                preline = preline[0:-1]
                if preline.endswith('\r'):
                    preline = preline[0:-1]
                out.write(preline)
                out.close()
                return (True, "File '%s' upload success!" % fn)
            else:
                out.write(preline)
                preline = line
        return (False, "Unexpect Ends of data.")


    def do_case4(self):  # TE: duplicated Transfer-Encoding: chunked  
        query_components = parse_qs(urlparse(self.path).query)
        logging.debug("Got query: {}".format(query_components))
        self.send_response(200)
        self.send_header('Transfer-Encoding', 'chunked')
        self.send_header('Transfer-Encoding', 'chunked')
        self.send_header('Connecion', 'keep-alive')
        self.end_headers()
        self.wfile.write(b'3\r\nlab\r\n')
        self.wfile.write(b'0\r\n\r\n')

    def do_GET(self):
        if self.path == '/case1':
            RedirReqHandler.do_case1(self)
        if self.path == '/case2':
            RedirReqHandler.do_case2(self)  
        if self.path == '/case3':
            RedirReqHandler.do_case3(self)
        if self.path == '/case4':
            RedirReqHandler.do_case4(self)     

if __name__ == "__main__":
    logging.basicConfig(
        level=logging.DEBUG,
        format='%(asctime)s: [%(module)s %(lineno)d] : %(message)s'
    )
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--redirurl", required=False, default=REDIRECT_LINK, help="URL link to run")
        parser.add_argument("--port", required=False, default=8000, help="Listening port number")

        args = parser.parse_args(sys.argv[1:])
        REDIRECT_LINK = args.__getattribute__("redirurl")
        listen_port = args.__getattribute__("port")
        logging.debug("Start HTTP server at: '%s'", listen_port)
        logging.debug("Redir URL: '%s'", REDIRECT_LINK)
    except Exception as ex:
        logging.error("Parsing arg error %s", ex)
        sys.exit(1)

    try:
        # Create an object of the above class
        HandleClass = RedirReqHandler
        HandleClass.protocol_version = "HTTP/1.1"
        socketserver.TCPServer.allow_reuse_address = True
        httpd = socketserver.TCPServer(("", int(listen_port)), RedirReqHandler)
        httpd.serve_forever()
    except Exception as ex:
        logging.error("Fail to start http server: %s", ex)

