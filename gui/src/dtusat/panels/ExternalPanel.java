package dtusat.panels;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dtusat.FSController;
import dtusat.FSResponse;
import dtusat.FSSocket;
import dtusat.UnsuccessfulRequestException;

public class ExternalPanel extends JPanel {
	
	FSSocket socket;
	JScrollPane scrollPane;
	JPanel refreshPanel, listPanel;
	JButton refreshButton;
	
	public ExternalPanel() {
		socket = FSController.getInstance().getSocket();
		
		setLayout(new BorderLayout());
	
		// Refresh
		refreshPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
		refreshButton = new JButton("Refresh List");
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
		FSResponse response = socket.execute("list_scripts");
		if(response.isSuccess()) {
			try {
				JSONArray scripts = response.bodyAsArray();
				listPanel.removeAll();
				JPanel newList = new JPanel();
				newList.setLayout(new BoxLayout(newList, BoxLayout.Y_AXIS));
				for(int i=0;i<scripts.length();i++) {
					JSONObject script;
					script = (JSONObject) scripts.get(i);
					newList.add(new ScriptPanel(script.getString("name"), script.getString("help")));
				}
				listPanel.add(newList, BorderLayout.NORTH);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
	}

}
