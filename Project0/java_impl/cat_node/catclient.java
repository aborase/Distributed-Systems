import java.io.*;
import java.net.*;
import java.util.*;
public class catclient {
    public static void main(String args[]) {
        Socket skt = null;
        String line, fline, file = args[0];;
        BufferedReader is, fs;
        PrintStream os;
        int i = 0, port = Integer.parseInt(args[1]);
        List<String> lines  = new ArrayList<String>();;

        try {
            skt = new Socket("catserver", port);
            is = new BufferedReader(new InputStreamReader(skt.getInputStream()));
            fs = new BufferedReader(new FileReader(file));
            os = new PrintStream(skt.getOutputStream());

            if ((fline = fs.readLine()) == null) {
                System.out.println("EMPTY FILE");
                System.exit(0);
            } else {
                while (fline != null) {
                    lines.add(fline.toLowerCase());
                    fline = fs.readLine();
                }
            }

            fs.close();
            fs = new BufferedReader(new FileReader(file));

            while (i < 10) {
                os.println("LINE");
                if ((fline = fs.readLine()) == null) {
                    fs.close();
                    fs = new BufferedReader(new FileReader(file));
                    fline = fs.readLine();
                }
                line = is.readLine();

                if (line != null) {
                    if (lines.contains(line.toLowerCase())) {
                        System.out.println("OK");
                    } else {
                        System.out.println("MISSING");
                    }
                } else {
                    System.out.println("Connection closed by client");
                    break;
                }

                i++;
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException ex) {
                    Thread.currentThread().interrupt();
                }
            }

            // Cleanup
            is.close();
            os.close();
            fs.close();
            skt.close();
        } catch (IOException e) {
            System.out.println(e);
        }
    }
}
