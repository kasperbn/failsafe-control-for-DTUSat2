package dtusat.panels;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dtusat.FSController;
import dtusat.FSResponse;
import dtusat.FSSocket;

public class InternalPanel extends JPanel {

	FSSocket socket;
	JScrollPane scrollPane;
	JPanel refreshPanel, listPanel;
	JButton refreshButton;
	
	public InternalPanel() {
		setLayout(new BorderLayout());
	
		// Refresh
		refreshPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
		refreshButton = new JButton("Set script directory");
		refreshButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e) {refreshList();}});
		
		refreshPanel.add(refreshButton);
		add(refreshPanel, BorderLayout.NORTH);
		
		// List Panel
		listPanel = new JPanel();
		listPanel.setLayout(new BorderLayout());
		scrollPane = new JScrollPane(listPanel);
		
		add(scrollPane);
	}
	
	private void refreshList() {
		final JFileChooser fc = new JFileChooser();
		fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		
		if(true || fc.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
			
			String dir = "/home/kbn/Code/bachelor/client_scripts/";//fc.getSelectedFile().getAbsolutePath();
			
			File folder = new File(dir);
		    File[] listOfFiles = folder.listFiles();

			listPanel.removeAll();
			JPanel newList = new JPanel();
			newList.setLayout(new BoxLayout(newList, BoxLayout.Y_AXIS));
		
		    for (int i = 0; i < listOfFiles.length; i++) {
		      if(listOfFiles[i].isFile()) {
		        File f = listOfFiles[i];
				
		        // Get help info
		        String help = "";
		        try {
			        String token = FSController.getInstance().getSocket().token;
					Process child;				
					child = new ProcessBuilder(f.getAbsolutePath(), "--help").start();
					BufferedReader out = new BufferedReader(new InputStreamReader(child.getInputStream()));
					child.waitFor();
					 
					String line;
					while ((line = out.readLine()) != null)
						help += line+"\n";
						
		        } catch (IOException e) {
					e.printStackTrace();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				
		        newList.add(new InternalScriptPanel(f.getName(), help, f.getAbsolutePath()));
		      }
		    }
			listPanel.add(newList, BorderLayout.NORTH);
		    FSController.getInstance().fsGuiPanel.repaint();
		}
	}
}
