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
	
	public LocalScriptsPanel() {
		setLayout(new BorderLayout());
	
		// Refresh
		refreshPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
		refreshButton = new JButton("Set Dir",new ImageIcon("src/dtusat/icons/folder_explore.png"));
		refreshButton.addActionListener(new ActionListener() { public void actionPerformed(ActionEvent e) {refreshList();}});
		
		refreshPanel.add(refreshButton);
		add(refreshPanel, BorderLayout.NORTH);
		
		// File tree
		treeTop = new DefaultMutableTreeNode("Local Scripts");
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
		final JFileChooser fc = new JFileChooser();
		fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		
		if(fc.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
			
			treeTop.removeAllChildren();
			
			//scriptsDir = "/home/kbn/Code/bachelor/client_scripts/";
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
