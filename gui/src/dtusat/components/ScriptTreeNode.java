package dtusat.components;

import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.MutableTreeNode;

public class ScriptTreeNode extends DefaultMutableTreeNode implements MutableTreeNode {

	String name, path, help;
	
	public ScriptTreeNode(String name, String path, String help) {
		super(name);
		this.name = name;
		this.path = path;
		this.help = help;
	}
	
}
