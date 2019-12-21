package easycomm.proxy;


import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.net.SocketException;

/**
 * Created by oksuz on 29/10/2017.
 */
public class Proxy implements Runnable {

//    private static final Logger LOGGER = LoggerFactory.getLogger(Proxy.class);
    private final Socket in;
    private final Socket out;

    public Proxy(Socket in, Socket out) {
        this.in = in;
        this.out = out;
    }

    @Override
    public void run() {
        LOGGER.info("Proxy {}:{} --> {}:{}", in.getInetAddress().getHostName()+"#"+ in.getPort(),out.getInetAddress().getHostName()+"#"+out.getPort());

        try {
            InputStream inputStream = getInputStream();
            OutputStream outputStream = getOutputStream();

            if (inputStream == null || outputStream == null) {
                return;
            }

            byte[] reply = new byte[4096];
            int bytesRead;
            
           // int character;
            StringBuilder output = new StringBuilder();

            int mid =0 ;
            out.setSoLinger(true, 0);
            while (-1 != (bytesRead = inputStream.read(reply))) {
            	
            	mid++;
            	output.append((char) bytesRead);
            	if ( mid == 3)
            		in.close(); // sent FIN if w/o setSoLinger
//            		out.close(); //sent RST ( with setSoLinger)
            
            	else 
                    outputStream.write(reply, 0, bytesRead);
                
                LOGGER.info("Rcv: rnd",mid+" len: "+bytesRead ,output);
            }
            
        } catch (SocketException ignored) {
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                in.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private InputStream getInputStream() {
        try {
            return in.getInputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    private OutputStream getOutputStream() {
        try {
            return out.getOutputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }
}