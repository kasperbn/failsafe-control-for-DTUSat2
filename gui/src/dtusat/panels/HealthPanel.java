package dtusat.panels;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import dtusat.FSController;

public class HealthPanel extends JPanel {
	
	private JPanel systemsPanel;
	private String[][] subSystems = {
			{"Power (EPS)", "The power sub system provides power for all the other sub systems. The power PCB will monitor the battery health status, manage battery charging and measure the currents flowing to each sub system."},
			{"On Board Computer (OBC)","The OBC is the \"brain\" of the satellite. It manages dataflow, executes telecommands and may be used for calculations such as attitude data."},
			{"Radio (COM)","In order to send and receive data an onboard radio is necessary. The PPL requires a separate radio receiver."},
			{"Attitude Determination and Control System (ACS)","The ACS determines the orientation of the satellite in space and together with the OBC the ACS alters the orientation. I.e. the OBC decides whether alterations are necessary or not."},
			{"Structure (MECH)","The mechanical structure fixates all the sub systems with respect to each other. It will dimensioned to withstand the stress during the launch phase, provide maximum shielding from the solar radiation and still be as light as possible."},
			{"Software (OBDH)","On board SW is developed in close collaboration with the OBC group."},
			{"Ground station (GS)","The ground station will establish radio communication with the satellite at each pass. It will be placed on the roof of one of the buildings at DTU campus."},
			{"Mission Control", "Mission control is the command center operating the satellite. Since the ground station is placed on DTU campus mission control will most likely merge with the ground station."},
			{"Payload (PPL)", "The payload to fly on DTUsat was selected on 10th of November by the Jury at the Payload Conference."}
	};
	private JScrollPane scrollPane;
	private JPanel listPanel;

	
	public HealthPanel() {
		setLayout(new BorderLayout());
		
		//systemsPanel = new JPanel();
		listPanel = new JPanel();
		listPanel.setLayout(new BoxLayout(listPanel, BoxLayout.Y_AXIS));
		scrollPane = new JScrollPane(listPanel);
		add(scrollPane, BorderLayout.CENTER);
		
		// Refresh
		JPanel refreshPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JButton refreshButton = new JButton("Get status");
		refreshButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e) {refreshList();}});
		
		refreshPanel.add(refreshButton);
		add(refreshPanel, BorderLayout.NORTH);
	}


	protected void refreshList() {
		listPanel.removeAll();
		for(String[] s : subSystems) {
			try {
				listPanel.add(new SubSystemPanel(s[0],SubSystemPanel.GREEN,s[1]));
			} catch (UnknownStatusException e) {
				e.printStackTrace();
			}
		}
		FSController.getInstance().fsGuiPanel.repaint();
	}
}
