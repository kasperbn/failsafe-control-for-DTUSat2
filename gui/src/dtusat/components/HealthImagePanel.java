package dtusat.components;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Image;

import javax.swing.ImageIcon;
import javax.swing.JPanel;

public class HealthImagePanel extends JPanel {
	
	private Image img;
	private int margin;

	public Integer[] data;
	
	// [lower yellow, upper yellow, lower red, upper red]
	public int[][] intervals = {
			{},	  				  	// Auto reset 
			{}, 					// Boot count
			{},						// FS Error
			{},						// Number of SIBs
			{105, 115, 100, 120}, 	// I panel
			{105, 115, 100, 120}, 	// I bat
			{105, 115, 100, 120}, 	// V bat 
			{105, 115, 100, 120}, 	// V unreg
			{105, 115, 100, 120}, 	// V reg
			{105, 115, 100, 120}  	// I reg
	};
	
	private Dimension size;
	
	public HealthImagePanel() {
		super();
		img = new ImageIcon("src/dtusat/img/health_panel.png").getImage();
		margin = 20;
		
		setBackground(Color.white);
		size = new Dimension(img.getWidth(null)+2*margin+200, img.getHeight(null)+2*margin);
	    setPreferredSize(size);
	    setMinimumSize(size);
	    setMaximumSize(size);
	    setSize(size);
	    setLayout(null);
	}
	
	public void paintComponent(Graphics g) {	
		g.drawImage(img, margin, margin, null);
		
		int x_list = (int) (size.getWidth()-200);
		
		try {
			g.drawString("Auto reset status: "+data[0], x_list, 10+margin);
			g.drawString("Boot count: "+data[1], x_list, 30+margin);
			g.drawString("FS Error: "+data[2], x_list, 50+margin);
			g.drawString("Number of SIBs: "+data[3], x_list, 70+margin);		
			
			g.setFont(new Font("Mono", Font.BOLD, 20));
			g.setColor(Color.green);
			
			Color old = g.getColor();
			
			setHealthColor(g,4);g.drawString(""+data[4], 160+margin, 137+margin); // I panel
			setHealthColor(g,5);g.drawString(""+data[5], 143+margin, 334+margin); // I bat
			setHealthColor(g,6);g.drawString(""+data[6], 143+margin, 371+margin); // V bat
			setHealthColor(g,7);g.drawString(""+data[7], 227+margin, 226+margin); // V Unreg
			setHealthColor(g,8);g.drawString(""+data[8], 216+margin, 304+margin); // V reg
			setHealthColor(g,9);g.drawString(""+data[9], 305+margin, 254+margin); // I reg
			
			g.setColor(old);
			// ------------- TODO Replace with real data ----------------------
	
			g.setColor(new Color(0x888888));
			g.drawString("20", 96+margin, 259+margin);  // T eps
			g.drawString("20", 96+margin, 442+margin);  // T bat
			g.drawString("20", 361+margin, 60+margin);  // T com
			g.drawString("20", 393+margin, 525+margin); // T cpu
			g.drawString("20", 465+margin, 71+margin);  // RSSI
			g.drawString("110", 277+margin, 395+margin);// V 33
			g.drawString("110", 277+margin, 443+margin);// I 33
			g.drawString("110", 455+margin, 395+margin);// V 18
			g.drawString("110", 455+margin, 443+margin);// I 18
		
		} catch (NullPointerException e) {
			// Data not set yet
		}
	}
	
	public void setHealthColor(Graphics g, int i) {
		Color color = Color.green;
		int v = data[i];

		if(v < intervals[i][0] || v > intervals[i][1])
			color = Color.yellow;
		if(v < intervals[i][2] || v > intervals[i][3])
			color = Color.red;
	
		g.setColor(color);
	}
}
