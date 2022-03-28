import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Launcher {

    public static void main(String args[]) {

        //Creates the Frame
        JFrame LaunchFrame = new JFrame();
        LaunchFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        LaunchFrame.setSize(225, 225);

        // The center active element
        JPanel LoginCenter = new JPanel(new GridBagLayout());
        GridBagConstraints constraint = new GridBagConstraints();
        constraint.anchor = GridBagConstraints.WEST;
        constraint.insets = new Insets(10, 10, 10, 10);

        JButton buttonLaunchServer = new JButton("Launch A");
        JButton buttonLaunchLocal = new JButton("Launch B");

        // create a new panel with GridBagLayout manager

        // add components to the panel
        //START Launcher GUI LAYOUT
        constraint.gridx = 0;
        constraint.gridy = 0;
        LoginCenter.add(buttonLaunchServer, constraint);

        constraint.gridx = 0;
        constraint.gridy = 1;
        LoginCenter.add(buttonLaunchLocal, constraint);

        // set border for the panel
        LoginCenter.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Launcher"));


        buttonLaunchServer.addActionListener(new ActionListener(){
            public void actionPerformed(ActionEvent e) {
                Runtime rt = Runtime.getRuntime();
                try {
                    rt.exec("cmd.exe /c start java -jar C:\\\\Folder\\File");
                } catch (IOException a) {
                    a.printStackTrace();
                }
            }
        });
        buttonLaunchLocal.addActionListener(new ActionListener(){
            public void actionPerformed(ActionEvent e) {
                Runtime rt = Runtime.getRuntime();
                try {
                    rt.exec("cmd.exe /c start java -jar C:\\\\Folder\\File");
                } catch (IOException a) {
                    a.printStackTrace();
                }
            }
        });

        //Adding Components to the frame.
        //frame.getContentPane().add(BorderLayout.SOUTH, panel);
        LaunchFrame.getContentPane().add(BorderLayout.CENTER, LoginCenter);
        LaunchFrame.setLocationRelativeTo(null);
        LaunchFrame.setVisible(true);
    }
}
