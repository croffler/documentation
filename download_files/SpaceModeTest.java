import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Random;
import java.util.concurrent.TimeUnit;

import org.openspaces.admin.Admin;
import org.openspaces.admin.AdminFactory;
import org.openspaces.admin.pu.ProcessingUnit;
import org.openspaces.admin.pu.ProcessingUnitInstance;
import org.openspaces.admin.space.SpaceInstance;

import com.gigaspaces.cluster.activeelection.SpaceMode;


public class SpaceModeTest {
	
	private Admin admin;
	private ProcessingUnit pu;
	public SpaceModeTest(){}
	
	 
	 private Hashtable<String,ArrayList<SpaceInstance>> getSpacesOnHosts() throws Exception
		{
		 	admin = new AdminFactory().addLocators(locators).createAdmin();
	        pu = admin.getProcessingUnits().waitFor(processingUnitName, 30, TimeUnit.SECONDS);
			
	        Hashtable<String,ArrayList<SpaceInstance>> spaceListPerHost = new Hashtable<String,ArrayList<SpaceInstance>> ();
			int spaceCount = pu.getTotalNumberOfInstances();
			
			ProcessingUnitInstance puInstances[]=getInstances();		
			for (int i=0;i<puInstances.length;i++ )
			{
				String hostAddress = puInstances[i].getMachine().getHostAddress();

				ArrayList<SpaceInstance> spaces = null;
				if (!spaceListPerHost.containsKey(hostAddress))
				{
					spaces = new ArrayList<SpaceInstance>();
				}
				else
				{
					spaces=spaceListPerHost.get(hostAddress);
				}
				
				while (puInstances[i].getSpaceInstance() == null)
				{
					Thread.sleep(1000);
				}
				
				spaces.add(puInstances[i].getSpaceInstance());
				spaceListPerHost.put(hostAddress , spaces);
			}

			Enumeration<String> keys = spaceListPerHost.keys();
			while (keys.hasMoreElements())
			{
				String host = keys.nextElement();
				log.info("     Host:"+host);
				log.info("-------------------------");
				
				ArrayList<SpaceInstance> spaces = spaceListPerHost.get(host);
				Iterator<SpaceInstance> spaceIter = spaces.iterator();
				while (spaceIter.hasNext())
				{
					SpaceInstance space = spaceIter.next();
					if (space != null)
					{
						if (space.getMode().equals(SpaceMode.NONE))
						{
							space.waitForMode(SpaceMode.PRIMARY, 5000, TimeUnit.MILLISECONDS);
						}
						log.info("ID:" +space.getInstanceId() + " " +space.getMode()+ " Instance Count:" + getObjectCount(space));
						}
					}
			}

			return spaceListPerHost ;
		}
	 
	 ProcessingUnitInstance[] getInstances() throws Exception
	    {
			int spaceCount = pu.getTotalNumberOfInstances();
			int retryCount = 0;
			ProcessingUnitInstance puInstances[];
			
			while (true)
			{
				puInstances = pu.getInstances();
				retryCount ++;
				if (puInstances.length == spaceCount)
				{
					break;
				}
				if (retryCount == 20)
				{
					log.info("--->>> Can't get full list of instances!");
					break;
				}
				Thread.sleep(2000);
			}
			return puInstances;
	    }
}
