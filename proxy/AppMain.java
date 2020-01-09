package easycomm.proxy;

import com.fortinet.devqa.Util;

/**
 * 2020-01-08: Added to support both side( left and right, or A, B) proxy
 * 
 * cmd example: At right side: root@johns-virtual-machine:/home/aiyan/jproxy#
 * java -jar wirecat.jar 445 172.18.43.124 445 1 B
 * 
 * 
 * 2019-12-24: added the RST at Proxy to support when ( at which round to send
 * reset)
 * 
 * @author john
 * 
 *
 */
public class AppMain {

	public static int localPort = 4450;
	public static String remoteIP = "172.18.43.100";
	public static int remotePort = 8080;

	public static int midReset = 3; // the flow round to send the RST

	public static boolean isLeft = false; // by default is Right (back side), used for 2 proxies .

	public static void main(String args[]) {

		if (args.length == 5) {
			localPort = Integer.valueOf(args[0]);
			remoteIP = (args[1]);
			remotePort = new Integer(args[2]);
			midReset = new Integer(args[3]);

			if (args[4] == "A")
				isLeft = true;

		} else {
			LOGGER.info("Usage: {LocalPort} {RemoteIP} {RemotePORT} {midReset} {A/B left or right");
			LOGGER.info("No IP and port defined, continue with: lPort " + localPort + " " + "rIP and Port " + remoteIP
					+ ":" + remotePort + " midReset " + midReset);
			// return;
		}

		TcpProxy tcpProxy = new TcpProxy(remoteIP, remotePort, localPort);
		tcpProxy.listen();
	}

}
