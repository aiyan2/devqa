package easycomm.proxy;

public class LOGGER {

	static void info(String mesg, Object obj, Object obj2) {

		System.out.println(mesg + obj +" :: "+ obj2);
	}
	
	static void info(String mesg, Object ...obj) {
		
		 
		
		for (Object i: obj)
		    mesg += obj.toString();

		System.out.println(mesg);
	}
	
	static String byteArray2String(byte[] B, int length) {
		
		StringBuffer sb = new StringBuffer();
		for ( int i=0; i<length; i++) {
		  sb.append(B[i]);
	}
		info("Content is:", sb);
		return sb.toString();
	}
}
