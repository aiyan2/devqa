package easycomm;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Calendar;
import java.util.Date;

import org.apache.http.client.utils.DateUtils;

import com.fortinet.devqa.Util;

import easycomm.data.MessageC;

/**
 * 2018-10-31: reproduced the issues of 2nd post blocked by FGT if av enabled
 *
 * Client: SuperClient + EditfromWireShark.java ( for mesgs)
 * 
 * src-location:
 * https://github.com/aiyan2/EasyComm/tree/master/HttpClient/src/easycomm
 * 
 */
public class EZServer2 {

	static int port = 80;
	static String countinue_100 = "HTTP/1.1 100 Continue\r\n" + "\r\n";

	static String eicar = "X5O!P%@AP[4\\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*";

	static String content = "<html><head></head>\r\n" + "<body><p align=\"left\">Expire\r\n" + "</body></html> ";
	static String OK_eicar = "HTTP/1.1 200 OK\r\n" + "Content-Type: text/html; charset=UTF-8\r\n" + "Content-Length: "
			+ eicar.length() + "\r\n" + "\r\n" // MUST BE for content
			+ eicar;
//    				 +"\r\n";	 // MUST NOT 
	static String ok_200 = "HTTP/1.1 200 OK\r\n" + "Content-Length: 0\r\n" +
//     		"Server: nginx/1.13.8\r\n" + 
//     		"Date: Tue, 30 Oct 2018 01:00:52 GMT\r\n" + 
//     		"Content-Type: text/html; charset=UTF-8\r\n" + 
//     		"Transfer-Encoding: chunked\r\n" + 
//     		"Connection: keep-alive\r\n" + 																																																																																																																							
//     		"Content-Encoding: gzip\r\n" + 
//     		"\r\n" + 
//     		"The script being executed is /usr/local/nginx/html/upload.php\r\n" + 
//     		"-------------taget_file is test-url.txt\r\n" + 
//     		"-------------taget_file is Array\r\n" + 
//     		"-------------taget_file is /var/www/html/uploads/test-url.txt\r\n" + 
//     		"File is not an image.Sorry, file already exists.The file test-url.txt has been uploaded. \r\n"+
			"\r\n";
	static String ok_200_welcome = "\r\n" + "<html><body><h1>It works!</h1>\r\n"
			+ "<p>This is the default web page for this server.</p>\r\n"
			+ "<p>The web server software is running but no content has been added, yet.</p>\r\n"
			+ "<a href=/upload>Browsing the /upload directory in this file server</a><p>\r\n" + "</body></html>" +

			"\r\n";
	static String auth_401 = "HTTP/1.1 401 Unauthorized\r\n" + "Server: nginx/1.13.8\r\n"
			+ "Date: Tue, 30 Oct 2018 17:00:02 GMT\r\n" + "Content-Type: text/html\r\n" + "Content-Length: 0\r\n" + // 597
			"Connection: keep-alive\r\n" + "WWW-Authenticate: Basic realm=\"Restricted Content\"\r\n"
////     		+ 	// too long to send ..
////     		"<html>\r\n" + 
////     		"<head><title>401 Authorization Required</title></head>\r\n" + 
////     		"<body bgcolor=\"white\">\r\n" + 
////     		"<center><h1>401 Authorization Required</h1></center>\r\n" + 
////     		"<hr><center>nginx/1.13.8</center>\r\n" + 
////     		"</body>\r\n" + 
////     		"</html>\r\n" + 
////     		"<!-- a padding to disable MSIE and Chrome friendly error page -->\r\n" + 
////     		"<!-- a padding to disable MSIE and Chrome friendly error page -->\r\n" + 
////     		"<!-- a padding to disable MSIE and Chrome friendly error page -->\r\n" + 
////     		"<!-- a padding to disable MSIE and Chrome friendly error page -->\r\n" + 
////     		"<!-- a padding to disable MSIE and Chrome friendly error page -->\r\n" + 
////     		"<!-- a padding to disable MSIE and Chrome friendly error page -->"

			+ "\r\n";

	static OutputStream os;

	public static void main(String args[]) throws IOException {

		ServerSocket server = new ServerSocket(port);

		System.out.println("Listening for connection on port " + port + "..." + server.getInetAddress());

		while (true) {
			try (Socket socket = server.accept()) {

				String request;
				BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
				os = socket.getOutputStream();

//				boolean step1 = false; // flag for 2 steps to handle auth-request ( pattern in the middle, not in end).
				try {
					while ((request = br.readLine()) != null) {

						System.out.println("Rvd:" + request);
						
//						testLocations(request);
						sendWebFilter(); // sendEicar for ipv6 test ...

//						if (request.contains("GET")||request.contains("Conn"))
//						sendUnknownHttp();

//					flowOfReproduce(request);
//						flowOfVerify_190731(request);

//						flowOfVerify(request);	
//						sendHttpResponse(os, String.valueOf(MessageC.pkt871), "eicar of ftp non-stard port");						
//						 os.close();
//					        break;			
					}

				} catch (java.net.SocketException e) {
					e.printStackTrace();
				}

			}
		} // end-while
	}

	static void sendUnknownHttp() throws IOException {

		String content = "Hello Mars!!";
		String unKnownHttp = "HTTP/0.8 200 OK\r\n" + "Content-Length: " + content.length() + "K" + " \r\n\r\n" + content
				+ "\r\n\r\n";

		sendHttpResponse(os, unKnownHttp, "unKnownHttp");

	}

	static void flowOfVerify_190731(String request) throws IOException {

		if (request.matches("Expect: 100-continue")) // response to the first POST
			sendHttpResponse(os, auth_401, "401-auth");

		if (request.startsWith("Authorization: ")) // 2nd post, with auth-header
			sendHttpResponse(os, ok_200, "200-OK");
	}

	static void flowOfReproduce(String request) throws IOException {

		if (request.matches("Expect: 100-continue")) // get the first POST
			sendHttpResponse(os, auth_401, "401-auth");

		if (request.startsWith("Authorization: "))
//			step1 = true;
//		if (request.startsWith("Accept-Language:") // end of auth-mesg
//				&& step1)
			sendHttpResponse(os, countinue_100, "100-continue");

		if (request.matches("------WebKitFormBoundarydRcL8NeqnnjYDT3i--")) // ending of payload
			sendHttpResponse(os, ok_200, "200-OK");

//	 else 
//		 System.out.println("Unknown request-line");
	}

	// FGT dis-connect the first round, start a new one:
	static void flowOfVerify(String request) throws IOException {

		if (request.startsWith("Authorization: "))
			sendHttpResponse(os, countinue_100, "100-continue");

		if (request.matches("------WebKitFormBoundarydRcL8NeqnnjYDT3i--")) // ending of payload
			sendHttpResponse(os, ok_200, "200-OK");
	}

	static void send200OK_EICAR() throws IOException {
		String myOK_OK = "HTTP/1.1 200 OK\r\n" +
//				"Date: Mon, 10 Dec 2018 23:42:18 GMT\r\n" + 
//				"Server: Apache/2.2.17 (Ubuntu)\r\n" + 
//				"Last-Modified: Wed, 01 Apr 2015 20:54:50 GMT\r\n" + 
//				"ETag: \"31c01f4-44-512afed197a80\"\r\n" + 
//				"Accept-Ranges: bytes\r\n" + 
//				"Vary: Accept-Encoding\r\n" + 
//				"Content-Encoding: gzip\r\n" + 
				"Content-Length: 68\r\n" +
//				"Keep-Alive: timeout=15, max=100\r\n" + 
//				"Connection: Keep-Alive\r\n" + 
				"Content-Type: text/plain\r\n" + "\r\n" + eicar
//				"X5O!P%@AP[4\\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*"
		;

		Calendar calendar = Calendar.getInstance();
		String dateGMT = calendar.getTime().toGMTString();

		// Add 3 minutes to the calendar time
		calendar.add(Calendar.MINUTE, 3);
		String targetDate = calendar.getTime().toGMTString();
		String cache_OK = "HTTP/1.1 200 OK\r\n" + "Date: " + dateGMT + " \r\n" + "Server: Apache/2.2.17 (Ubuntu)\r\n" +
//				"Last-Modified: Wed, 12 Dec 2018 19:23:00 GMT\r\n" + 
//				"ETag: \"5f80033-51-57cd820529d45\"\r\n" + 
				"Accept-Ranges: bytes\r\n" + "Content-Length: " + content.length() + "\r\n"
				+ "Keep-Alive: timeout=15, max=100\r\n" + "Connection: Keep-Alive\r\n" + "Expires: " + targetDate
				+ " \r\n" + // added from wad-debug-mantis
//				"Content-Type: text/plain\r\n" + 
				"\r\n" + content;

		String cache_206_cust = // composed based on mantis_wad_debug
				"HTTP/1.1 206 Partial Content\r\n" + "Date: " + dateGMT + " \r\n" + "Server: Apache/2.2.22 (Ubuntu)\r\n"
						+ "Accept-Ranges: bytes\r\n" +
//				"Content-Length: "+content.length()+"\r\n" + 
						"Content-Length: " + 67 + "\r\n" + "Expires: " + targetDate + " \r\n" + // added from
																								// wad-debug-mantis
						"Content-Range: bytes 10-66/67" + "\r\n" + content.substring(9, content.length());
		String cache_206 = "HTTP/1.1 206 Partial Content\r\n" + "Content-Length: 57\r\n"
				+ "Content-Range: bytes 10-66/67\r\n" + "Date: Fri, 19 Oct 2018 01:25:18 GMT\r\n"
				+ "Server: Apache/2.2.22 (Ubuntu)\r\n" + "Accept-Ranges: bytes\r\n"
				+ "Expires: Fri, 19 Oct 2018 01:28:18 GMT\r\n" + "Age: 39\r\n" + "" + "\r\n"
				+ content.substring(10, content.length()) + "\r\n";

		String cache_206_OK_on_reproeduce = "HTTP/1.1 206 Partial Content\r\n" + "Content-Length: 57\r\n"
				+ "Content-Range: bytes 10-66/67\r\n" + "Date: Fri, 19 Oct 2018 01:22:15 GMT\r\n"
				+ "Server: Apache/2.2.22 (Ubuntu)\r\n" + "Accept-Ranges: bytes\r\n"
				+ "Expires: Fri, 19 Oct 2018 01:25:15 GMT\r\n" + "Age: 39\r\n" + " \r\n" + "d></head>\r\n"
				+ "<body><p align=\"left\">Expire\r\n" + "</body></html> " + "\r\n"; // added

		String PC_206_ReProduce = "[0x7f5f90fff198] Received response from server:\r\n" + "\r\n"
				+ "HTTP/1.1 206 Partial Content\r\n" + "Date: Mon, 17 Dec 2018 21:41:01 GMT\r\n"
				+ "Server: Apache/2.4.18 (Ubuntu)\r\n" + "Accept-Ranges: bytes\r\n" + "Content-Length: 12\r\n"
				+ "Expires: Mon, 17 Dec 2018 21:42:06 GMT\r\n" + "Age: 114\r\n" + "Content-Range: bytes 10-76/77\r\n"
				+ "Content-Type: application/xml\r\n" + "\r\n" + content.substring(1, 12) + "\r\n";

		sendHttpResponse(os, PC_206_ReProduce, "PC_206");

	}
	
	static void testLocations(String request) throws IOException {
		

		String loc1 = "Location: http://172.18.43.99/1";
		String loc2 = "Location: http://172.18.43.99/2";
		String loc3 = "Location: http://172.18.43.99/3";

		if(request.matches("Host: 172.18.43.99"))
		sendHttpResponse(os, locationIteration(loc1), "LOC1");
		
		if (request.matches("/1")) {
			sendHttpResponse(os, locationIteration(loc2), "LOC2");
		}
		if (request.matches("/2")) {
			sendHttpResponse(os, locationIteration(loc3), "LOC3");

		}
	}
	
	static String locationIteration(String loc) {			
		
		Calendar calendar = Calendar.getInstance();
		String dateGMT = calendar.getTime().toGMTString();
		// Add 3 minutes to the calendar time
		calendar.add(Calendar.MINUTE, 3);
		String targetDate = calendar.getTime().toGMTString();
		String  mesg_loc = "HTTP/1.1 301 Moved Permanently\r\n" + "Date: " + dateGMT + " \r\n" 
		        + "Server: Apache/2.2.17 (Ubuntu)\r\n" 
				+loc+ "\r\n"
//				"Last-Modified: Wed, 12 Dec 2018 19:23:00 GMT\r\n" + 
//				"ETag: \"5f80033-51-57cd820529d45\"\r\n" + 
//				"Accept-Ranges: bytes\r\n" + "Content-Length: " + content.length() + "\r\n"
//				+ "Keep-Alive: timeout=15, max=100\r\n" + "Connection: Keep-Alive\r\n" + "Expires: " + targetDate
				+"Content-Length: 0"+ "\r\n"
				+ " \r\n" ;
//		sendHttpResponse(os, mesg_loc1, "PC_206");	
		
		return mesg_loc;
		
	}

	static void sendWebFilter() throws IOException {

		String webs = "ietf.org\r\n" + "www.jd.com\r\n" + "ib*.com*\r\n" + "*ibmm\r\n" + "\r\n";
		Integer tsize = 128; // 1*1024;
		String wbsBig = webs + (new Date()) + Util.bigMsg(tsize);

		String commonHeader = "HTTP/1.1 200 OK\r\n" + "Date: " + (new Date()) + "\r\n"
				+ "Server: Apache/2.2.17 (Ubuntu)\r\n" + "Content-Type: text/plain \r\n";
		String errorHeader = "HTTP/1.1 312 Error\r\n" + "Date: " + (new Date()) + "\r\n"
				+ "Server: Apache/2.2.17 (Ubuntu)\r\n" + "Content-Type: text/plain \r\n";
		String std = "Keep-Alive: timeout=15, max=100\r\n" + "Connection: Keep-Alive\r\n" + "Content-Length: "
				+ webs.length() + "\r\n" + "\r\n" + webs;
		String noContentLength = "Keep-Alive: timeout=15, max=100\r\n" + "Connection: Keep-Alive\r\n" +
//				"Content-Length: " + wbsBig.length() + "\r\n" +	
				"\r\n" + wbsBig;

		String hasChunk = "Transfer-Encoding: chunked\r\n" + "\r\n" + // must have
				"8\r\n" + // length of the follow ( in hex)
				"ibm.com \r\n" + "7\r\n" + "\r\n" + // due to this line, need to add 2 to length of ( jd.*) ....
				"jad.*\r\n" +
//				Integer.toHexString(tsize)+"\r\n"+
//				wbsBig+"\r\n"+
				"0\r\n" // end of the trunk
				+ "\r\n";
		String bigChunk = "Transfer-Encoding: chunked\r\n" + "\r\n" + // must have
				"7\r\n" + // length of the follow ( in hex)
				"ibm.com\r\n" + Integer.toHexString(wbsBig.length()) + "\r\n" + wbsBig + "\r\n" + "0\r\n" // end of the
																											// trunk
				+ "\r\n";
		String empty = "HTTP/1.1 200 OK\r\n" + "Date: " + (new Date()) + "\r\n" + "Server: Apache/2.2.17 (Ubuntu)\r\n"
				+ "Content-Length: 0\r\n" + "Content-Type: text/plain";
		String utf_webfilter = "151.101.130.166\r\n" + //
//				"сделать-справку-в-бассейн.рф\r\n" + 
//				"продукты-из-финляндии.рф/raki_espa_v_ukrope_1_kg\r\n" + 
//				"призывник-нн.рф/kak-otkosit-ot-armii\r\n" + 
				"алиэкспрессотзывы.рф/семена-конопли-как-купить-на-алиэкспр\r\n"
				+ "http://ko.wikipedia.org/wiki/위키백과:대문" + "\r\n"
				+ "текстыпесни.рф/stihi/1488_ja-risuu-na-asfalte-belim-melom \r\n";

		String location = "HTTP/1.1 301 Moved Permanently\r\n" + // 301 or 303( see other)
				"Date: " + (new Date()) + "\r\n" + "Server: AkamaiGHost\r\n" + "Content-Length: 0\r\n"
				+ "Location: http://172.18.2.169/upload/ama/test-urls/\r\n" + "Connection: keep-alive\r\n"
				+ "X-Content-Type-Options: nosniff\r\n" + "X-XSS-Protection: 1; mode=block\r\n"
				+ "Content-Security-Policy: upgrade-insecure-requests\r\n" + "\r\n";

		/**
		 * Test ETag
		 */
		String before_304 = "" + "HTTP/1.1 200 OK\r\n" + "Date: " + (new Date()) + "\r\n"
				+ "Server: Apache/2.2.17 (Ubuntu)\r\n" + "Last-Modified: Thu, 11 Oct 2018 23:12:00 GMT\r\n"
				+ "ETag: \"5f80022-6-577fc1925857f\"\r\n" + "Accept-Ranges: bytes\r\n" + "Content-Length: 6\r\n"
				+ "Content-Type: text/plain\r\n" + "\r\n" + "*ibm*\r\n" + "";
//		curl -v  "http://172.18.2.169/upload/ama/test-urls"  -H "If-None-Match: \"5f80022-6-577fc1925857f\""
		String eTag_304 = "HTTP/1.1 304 Not Modified\r\n" + "Date: " + (new Date()) + "\r\n"
				+ "Server: Apache/2.4.18 (Ubuntu)\r\n" + // 172.18.43.100
				"ETag: \"5f80022-6-577fc1925857f\"\r\n" +
//				"Expires: Mon, 17 Dec 2018 20:59:47 GMT\r\n" + 
//				"Cache-Control: max-age=180\r\n" + 				
				"";

		String craftFromRaw = String.valueOf(MessageC.OK_200);

		// FGT send Header "connection: close" in the http/1.1 get message.
		sendHttpResponse(os, commonHeader + hasChunk, "Chunk");
//		sendHttpResponse(os, noContentLength, "trunk");		
	}

	private static void sendHttpResponse(OutputStream os, String mesg, String mesgName) throws IOException {

		int len = mesg.length() < 1000 ? mesg.length() : 1000;
		System.out.println("\r\nTo be sent:\n" + mesg.substring(0, len));

		os.write(mesg.getBytes());
		os.flush();
		System.out.println("\n===>Sent " + mesgName + "\n");

	}

}
