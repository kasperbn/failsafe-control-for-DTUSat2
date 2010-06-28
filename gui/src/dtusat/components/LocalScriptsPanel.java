package dtusat.components;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Enumeration;

import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTree;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dtusat.FSController;
import dtusat.FSResponse;
import dtusat.FSSocket;

public class LocalScriptsPanel extends JPanel implements TreeSelectionListener {

	FSSocket socket;
	JScrollPane scriptView;
	JPanel refreshPanel, scriptPanel;
	JButton refreshButton;
	private DefaultMutableTreeNode treeTop;
	private JTree fileTree;
	private String scriptsDir;
	private JSplitPane splitPane;
	private JPanel leftPanel;
	private JPanel leftNorthPanel;
	private JPanel rightPanel;
	
	public LocalScriptsPanel() {
		setLayout(new BorderLayout());
	
		// Splitpane
		splitPane = new JSplitPane();
		add(splitPane, BorderLayout.CENTER);
		
		// Left
		leftPanel = new JPanel(new BorderLayout());		
		splitPane.setLeftComponent(leftPanel);
		
			// North
			leftNorthPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
			leftPanel.add(leftNorthPanel, BorderLayout.NORTH);
			
				refreshButton = new JButton("Set Dir",new ImageIcon("src/dtusat/icons/folder_explore.png"));
				refreshButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e) {refreshList();}});
				leftNorthPanel.add(refreshButton);
		
			// Center
			treeTop = new DefaultMutableTreeNode("Local Scripts");
			fileTree = new JTree(treeTop);
			fileTree.addTreeSelectionListener(this);
			leftPanel.add(new JScrollPane(fileTree), BorderLayout.CENTER);
		
		// Right
		rightPanel = new JPanel(new BorderLayout());
		splitPane.setRightComponent(rightPanel);
		
			// Center
			scriptPanel = new JPanel();
			scriptPanel.setLayout(new BorderLayout());
			scriptView = new JScrollPane(scriptPanel);
			rightPanel.add(scriptView, BorderLayout.CENTER);
		
	}
	
	private void refreshList() {
		final JFileChooser fc = new JFileChooser();
		fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		
		if(fc.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
			
			treeTop.removeAllChildren();
			
			scriptsDir = fc.getSelectedFile().getAbsolutePath();
			walkDir(new File(scriptsDir));

		    fileTree.expandRow(0);
		    FSController.getInstance().mainPanel.repaint();
		}
	}

	private void walkDir(File folder) {
	    File[] listOfFiles = folder.listFiles();
	    for (int i = 0; i < listOfFiles.length; i++) {
	    	File current = listOfFiles[i]; 
	    	if(current.isDirectory()) {
	    		walkDir(current);
	    	} else if(current.isFile()) {
		        File f = listOfFiles[i];
		
		        if(f.canExecute()) {
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
					
					insertScriptAsNode(f.getAbsolutePath(), help);
		        }
		    }
	    }
	}
	
	private void insertScriptAsNode(String path, String help) {
		
		DefaultMutableTreeNode top = treeTop;
		
		// Make sure the directories are inserted
		String[] splittedPath = path.split("/");
		String scriptName = splittedPath[splittedPath.length-1];
		int skipCount = scriptsDir.split("/").length;
		
		// Skip until "scripts" folder and stop before the actual script
		for(int i=skipCount;i<splittedPath.length-1;i++) {
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
	public void valueChanged(TreeSelectionEvent arg0) {
		DefaultMutableTreeNode node = (DefaultMutableTreeNode) fileTree.getLastSelectedPathComponent();

		// Nothing is selected
		if(node == null) return;
		
		if(node.isLeaf()) {
			try {
				ScriptTreeNode scriptNode = (ScriptTreeNode) node;
				scriptPanel.removeAll();
				scriptPanel.add(new LocalScriptPanel(scriptNode.name, scriptNode.path, scriptNode.help), BorderLayout.NORTH);
				FSController.getInstance().mainPanel.repaint();
			} catch(ClassCastException cce) {
				// Tree is not loaded yet
			}
		}		
	}
}
