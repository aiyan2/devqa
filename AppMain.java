package easycomm.proxy;

public class AppMain {



    public static void main(String args[]) {


        String remoteHost = "172.18.43.124" ; //System.getProperty("remoteHost");
        int remotePort = 445; //Integer.parseInt(System.getProperty("remotePort"));
        int port = 4440; //Integer.parseInt(System.getProperty("port"));

        LOGGER.info("Starting proxy server on port {} for remote {}:{}", port, remoteHost);
        
               	 
        TcpProxy tcpProxy = new TcpProxy(remoteHost, remotePort, port);
        tcpProxy.listen();
    }


    
}
