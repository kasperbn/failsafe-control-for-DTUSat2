package dtusat.components;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Enumeration;

import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTree;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.TreeNode;
import javax.xml.bind.annotation.XmlElementRef.DEFAULT;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dtusat.FSController;
import dtusat.FSResponse;
import dtusat.FSCallback;
import dtusat.FSSocket;

public class ServerScriptsPanel extends JPanel implements TreeSelectionListener {
	
	FSSocket socket;
	JScrollPane scriptView;
	JPanel refreshPanel, scriptPanel;
	JButton refreshButton;
	private DefaultMutableTreeNode treeTop;
	private JTree fileTree;
	
	public ServerScriptsPanel() {
		socket = FSController.getInstance().getSocket();
		
		setLayout(new BorderLayout());
	
		// Refresh
		refreshPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
		refreshButton = new JButton("Refresh List", new ImageIcon("src/dtusat/icons/refresh.png"));
		refreshButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e) {refreshList();}});
		
		refreshPanel.add(refreshButton);
		add(refreshPanel, BorderLayout.NORTH);
		
		// File tree
		treeTop = new DefaultMutableTreeNode("Server Scripts");
		fileTree = new JTree(treeTop);
		fileTree.addTreeSelectionListener(this);
		JScrollPane fileTreeView = new JScrollPane(fileTree);
		
		// Script Panel
		scriptPanel = new JPanel();
		scriptPanel.setLayout(new BorderLayout());
		scriptView = new JScrollPane(scriptPanel);
		
		JSplitPane treeListSplitter = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, fileTreeView, scriptView);
		treeListSplitter.setDividerLocation(200);
		
		add(treeListSplitter);
	}

	private void refreshList() {
		socket.request("list_scripts", new FSCallback() {
			public void onResponse(FSResponse response) {
				if(response.isSuccess()) {
					treeTop.removeAllChildren();
				
					JSONArray scripts = response.dataAsArray();
					
					try {
						for(int i=0;i<scripts.length();i++) {
							JSONObject script = (JSONObject) scripts.get(i);
							insertScriptAsNode(script.getString("path"), script.getString("help"));
						}
					} catch (JSONException e) {
						e.printStackTrace();
					}
					
					fileTree.expandRow(0);
					FSController.getInstance().mainPanel.repaint();
				}	
			}
		});
	}
	
	private void insertScriptAsNode(String path, String help) {
		
		DefaultMutableTreeNode top = treeTop;
		
		// Make sure the directories are inserted
		String[] splittedPath = path.split("/");
		String scriptName = splittedPath[splittedPath.length-1];
		
		// Skip "scripts" folder and stop before the actual script
		for(int i=1;i<splittedPath.length-1;i++) {
			String dirName = splittedPath[i];
			boolean isInserted = false;
			
			// Is directory already in the tree?
			for(Enumeration<DefaultMutableTreeNode> e = top.children(); e.hasMoreElements();) {
				DefaultMutableTreeNode existing = e.nextElement();
				if(existing.toString().equals(dirName)) {
					isInserted = true;
					top = existing;
					break;
				}
			}
			
			// Directory is not in tree
			if(!isInserted) {
				DefaultMutableTreeNode newDir = new DefaultMutableTreeNode(dirName);
				top.add(newDir);
				top = newDir;
			}
		}
		
		// Now insert the script node
		top.add(new ScriptTreeNode(scriptName, path, help));
	}

	@Override
	public void valueChanged(TreeSelectionEvent e) {
		DefaultMutableTreeNode node = (DefaultMutableTreeNode) fileTree.getLastSelectedPathComponent();

		// Nothing is selected
		if(node == null) return;
		
		if(node.isLeaf()) {
			try {
				ScriptTreeNode scriptNode = (ScriptTreeNode) node;
				scriptPanel.removeAll();
				scriptPanel.add(new ServerScriptPanel(scriptNode.name, scriptNode.path, scriptNode.help), BorderLayout.NORTH);
				FSController.getInstance().mainPanel.repaint();
			} catch(ClassCastException cce) {
				// Tree is not loaded yet
			}
		}
	}
}