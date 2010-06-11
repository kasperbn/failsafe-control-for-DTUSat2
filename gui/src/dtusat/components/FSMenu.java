package dtusat.components;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.ImageIcon;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JSeparator;

import dtusat.FSController;

public class FSMenu extends JMenuBar implements ActionListener {

	private JMenuItem disconnectMenuItem;
	private JMenuItem quitMenuItem;
	public JCheckBoxMenuItem autoLockItem;
	private JMenuItem lockItem;
	private JMenuItem unlockItem;
	private FSController controller;

	public FSMenu() {
		controller = FSController.getInstance();
		
		JMenu fileMenu = new JMenu("File");
		quitMenuItem = new JMenuItem("Quit", new ImageIcon("src/dtusat/icons/door_out.png"));
		quitMenuItem.addActionListener(this);
		fileMenu.add(quitMenuItem);
		add(fileMenu);
		
		// Connection Menu
		JMenu connectionMenu = new JMenu("Connection");

		autoLockItem = new JCheckBoxMenuItem("Auto Lock", controller.isAutoLocked);
		autoLockItem.addActionListener(this);
		connectionMenu.add(autoLockItem);
		
		lockItem = new JMenuItem("Lock", new ImageIcon("src/dtusat/icons/lock.png"));
		lockItem.addActionListener(this);
		connectionMenu.add(lockItem);
		
		unlockItem = new JMenuItem("Unlock", new ImageIcon("src/dtusat/icons/unlock.png"));
		unlockItem.addActionListener(this);
		connectionMenu.add(unlockItem);
		
		connectionMenu.add(new JSeparator());
		
		disconnectMenuItem = new JMenuItem("Disconnect", new ImageIcon("src/dtusat/icons/disconnect.png"));
		disconnectMenuItem.addActionListener(this);
		connectionMenu.add(disconnectMenuItem);
		
		add(connectionMenu);
				
	}

	public void actionPerformed(ActionEvent e) {
		if(e.getSource() == disconnectMenuItem) {
			controller.getSocket().disconnect();
		}
		
		if(e.getSource() == quitMenuItem) {
			System.exit(0);
		}
		
		if(e.getSource() == lockItem) {
			controller.lock();
		}
		
		if(e.getSource() == unlockItem) {
			controller.unlock();
		}
		
		if(e.getSource() == autoLockItem) {
			controller.setAutoLocked(autoLockItem.isSelected());
		}
	}
	
}
