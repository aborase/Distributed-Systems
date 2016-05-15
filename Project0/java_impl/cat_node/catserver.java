import java.io.*;
import java.net.*;
public class catserver {
    public static void main(String args[]) {
        ServerSocket server = null;
        Socket cskt = null;
        String line, fline, file = args[0];
        BufferedReader is, fs;
        PrintStream os;
        int port = Integer.parseInt(args[1]);

        try {
            server = new ServerSocket(port);
            cskt = server.accept();
            is = new BufferedReader(new InputStreamReader(cskt.getInputStream()));
            fs = new BufferedReader(new FileReader(file));
            os = new PrintStream(cskt.getOutputStream());

            if ((fline = fs.readLine()) == null) {
                System.out.println("EMPTY FILE");
                System.exit(0);
            }

            fs.close();
            fs = new BufferedReader(new FileReader(file));

            while (true) {
                line = is.readLine();
                if ((line != null) && line.equals("LINE")) {
                    if ((fline = fs.readLine()) == null) {
                        fs.close();
                        fs = new BufferedReader(new FileReader(file));
                        fline = fs.readLine();
                    }
                    os.println(fline.toUpperCase());
                } else if (line == null) {
                    break;
                }
            }

            // Cleanup
            is.close();
            fs.close();
            os.close();
            cskt.close();
            server.close();
        }
        catch (IOException e) {
            System.out.println(e);
        }
    }
}
