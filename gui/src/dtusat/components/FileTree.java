package dtusat.components;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JTree;
import javax.swing.tree.DefaultMutableTreeNode;

public class FileTree extends JTree {

	public FileTree(String root) {
		super(createTree(root));
	}
	
	public static DefaultMutableTreeNode createTree(String dirname) {
		File f = new File(dirname);
		DefaultMutableTreeNode top = new DefaultMutableTreeNode();

		top.setUserObject(f.getName());
		if(f.isDirectory()) {
			File fls[] = f.listFiles();
			for(int i=0;i<fls.length;i++) {
				top.insert(createTree(fls[i].getPath()),i);
			}
		}
		return(top);
	}

}
