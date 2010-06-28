package dtusat.components;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.net.ssl.SSLEngineResult.Status;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import org.json.JSONArray;
import org.json.JSONException;

import dtusat.FSCallback;
import dtusat.FSController;
import dtusat.FSResponse;

public class HealthPanel extends JPanel {
	
	private JPanel systemsPanel;
	private JScrollPane scrollPane;
	private HealthImagePanel healthImagePanel;
	private JLabel lastUpdated;
	
	public HealthPanel() {
		setLayout(new BorderLayout());
		
		JPanel northPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
		add(northPanel, BorderLayout.NORTH);
		
			JButton refreshButton = new JButton("Update status");
			refreshButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e) {refreshList();}});
			northPanel.add(refreshButton);
			
			lastUpdated = new JLabel();
			northPanel.add(lastUpdated);
			
		healthImagePanel = new HealthImagePanel();
		scrollPane = new JScrollPane(healthImagePanel);
		scrollPane.setBackground(Color.white);
		
		add(scrollPane, BorderLayout.CENTER);
		
		
	}

	protected void refreshList() {
		FSController.getInstance().getSocket().request("health_status", new FSCallback() {
			public void onResponse(FSResponse response) {
				if(response.status == FSController.FS_HEALTH_STATUS) {
					JSONArray json_data = response.dataAsArray();
					Integer[] data = new Integer[json_data.length()];
					for(int i=0;i<json_data.length();i++) {
						try {
							data[i] = json_data.getInt(i);
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
					healthImagePanel.data = data;
					
					
					Calendar cal = Calendar.getInstance();
				    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
				    String time = sdf.format(cal.getTime());
					
					lastUpdated.setText("Last updated: "+time);
					FSController.getInstance().mainPanel.repaint();
				}
			}
		});
	}
}
