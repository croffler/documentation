package xapdoc.parser;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Scanner;
import java.util.TreeSet;

/**
 * Created with IntelliJ IDEA.
 * User: chris Roffler
 * Date: 10/18/15
*/
public class MenuTree {

	private static String BASE_PATH;
	
	private static final String[] dirs = new String[] {
		"0.3", "1.0", "1.1", "videos"
	};

    public static void main(String[] args) throws Exception {
		if (args.length < 1) {
			System.out.println("Incorrect number of arguments: " + args.length);			
			System.exit(1);
		}
		int totalPages = 0;
		// e.g. BASE_PATH = "/Users/xxxxx/Documents/xap-docs";
		BASE_PATH = args[0];
		System.out.println("Starting with base path " + BASE_PATH);			
		long startTime = System.currentTimeMillis();
        // Read all pages
        for (String path : dirs) {
            //System.out.println("Processing dir : " + path);
            Map<String, Page> pagesMap = new HashMap<String,Page>();
            File folder = new File(BASE_PATH + "/sites/ie-docs/content/" + path);
            for (File file : folder.listFiles()) {
                // make sure we only process markdown files
                if (file.isFile() && file.getName().contains(".markdown")) {
                    Page p = createPage(file);
                    pagesMap.put(file.getName().replace(".markdown", ".html"), p);
                }
            }
			totalPages += pagesMap.size();

            // now lets order them according to the weight
            TreeSet<Page> pagesTree = new TreeSet<Page>();
            for (Page p : pagesMap.values()) {
                if ( p.getWeight() != null){
                    if (p.getParent() == null)
					    pagesTree.add(p);
				    else {
                        Page parent = pagesMap.get(p.getParent());
                        if (parent != null)
                            parent.addChild(p);
                    }
                }
                else{
                   // System.out.println(p.getCategory() + "  " + p.getFileName() + "  has nul weight");
                }
            }

            // write the html to the file system
            PrintWriter writer = null;
            try {
                writer = new PrintWriter(BASE_PATH + "/themes/ie-theme/layouts/partials/sidenav-" + path + ".html", "UTF-8");
				for (Page p : pagesTree)
					printPage(writer, p);
            } finally {
                if (writer != null) {
                    writer.close();
                }
            }

           // System.out.println("Processed: " + path);
        }
		long duration = System.currentTimeMillis() - startTime;
        System.out.println("Finished generating navbar (duration=" + duration + "ms, folders=" + dirs.length + ", pages=" + totalPages + ")");
    }

    private static void printPage(PrintWriter writer, Page page) {
        String fileName = page.getFileName().replace(".markdown", ".html");
        if (page.getChildren().size() != 0) {
			writer.println("<li class='expandable'><div class='hitarea expandable-hitarea'></div><a href='./" + fileName + "'>" + page.getTitle() + "</a>");
			writer.println("<ul style='display: none'>");
            for (Page child : page.getChildren())
                printPage(writer, child);
			writer.println("</ul>");
			writer.println("</li>");
			
        } else {
			writer.println("<li><a href='./" + fileName + "'>" + page.getTitle() + "</a></li>");
        }
    }

    private static Page createPage(File file) throws IOException {

		if (file.getName().contains("--"))
			throw new IOException("File names can't conatin more then one '-' :" + file.getName());            
	
		Scanner scanner = new Scanner(file);
		Properties properties = new Properties();
        boolean foundHeader = false;
        boolean foundFooter = false;
	
		//System.out.println("*** Scanning " + file.getName());	
		try {
            while (scanner.hasNextLine() && !foundFooter) {
                final String line = scanner.nextLine().trim();
				if (line.equals("---")) {
					if (!foundHeader)
						foundHeader = true;
					else
						foundFooter = true;
				} else if (foundHeader) {
					int pos = line.indexOf(':');
					if (pos != -1) {						
						String name = line.substring(0, pos).trim();
						String value = line.substring(pos + 1).trim();
						properties.setProperty(name, value);
					}
				}
            }
        } finally {
            scanner.close();
        }
		
		Page p = new Page();
        p.setFileName(file.getName());
		p.setTitle(properties.getProperty("title"));
		String weight = properties.getProperty("weight");
		if (weight != null)
			p.setWeight(Long.parseLong(weight));
		String parent = properties.getProperty("parent");
		if (parent != null && !parent.equals("none"))
			p.setParent(parent);
        String category = properties.getProperty("categories");
        if (category != null )
            p.setCategory(category);

        return p;
    }
}
