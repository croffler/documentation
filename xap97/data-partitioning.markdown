---
layout: post
title:  Data-Partitioning
categories: XAP97
parent: data-grid-clustering.html
weight: 200
---


{% summary %}This section describes GigaSpaces IMDG Load-balancing and data-partitioning facilities.{% endsummary %}

# Data Load-balancing

Load-balancing is essential in any truly scalable architecture, as it enables scaling beyond the physical resources of a single-server machine. In GigaSpaces, load-balancing is the mechanism used by the clustered proxy to distribute space operations among the different cluster members. Each cluster member can run on a different physical machine.

If a space belongs to a load-balancing group, the clustered proxy originating from this space contains logical references to all space members in the load-balancing group. The references are "logical", in the sense that no active connection to a space member is opened until it is needed. This is illustrated in the following diagram:

![load_balancing_basic.gif](/attachment_files/load_balancing_basic.gif)

{% tip %}
For details about scaling a running space cluster **in runtime** see the [Elastic Processing Unit](./elastic-processing-unit.html) section.
{% endtip %}

# Partitioning Types

{% toczone minLevel=2|maxLevel=2|type=flat|separator=pipe|location=top %}

GigaSpaces ships with a number of built-in load-balancing policies. These range from relatively static policies, where each proxy "attaches" to a specific server and directs all operations to it, to extremely dynamic policies where the target of an operation takes into account the operation data and the relative strength of the server machine.

In each load balancing group, a load-balancing policy is specified per basic space operation: write, read, take and notify. This allows you to direct different kinds of operations to different spaces, ensuring correct semantics for the application.

The following table describes the built-in load balancing types.

{: .table .table-bordered}
|Policy|Description|
|:-----|:----------|
|local-space |This policy routes the operation to the local embedded space (without specifying the exact space name). It is used in P2P clusters.|
|round-robin |The clustered proxy distributes the operations to the group members in a round-robin fashion. For example, if there are three spaces, one operation is performed on the first space, the next on the second space, the next on the third space, the next on the first space, and so on.|
|hash-based|As above, except a new hash is computed for each user operation, and so each operation may be routed to a different space. This ensures, with high probability, that operations are evenly distributed. This is the **default mode** and the recommended mode.|

# Hash-Based Load-Balancing

This is the **default mode** and applicable for most of the application. When using hash-based load-balancing policy the client proxy spread new written space objects into relevant cluster space nodes. The relevant space to rout the operation is determined using space object routing field (aka also as routing index) value hashcode. This value together with the number of tue cluster partitions used to calculate the target space for the operation.

{% highlight java %}
Target partition space ID = safeABS(routing field hashcode) % (# of partitions)

int safeABS( int value)
{
     return value == Integer.MIN_VALUE ? Integer.MAX_VALUE : Math.abs(value);
}
{% endhighlight %}

The routing field must implement the `hashCode` method and will be used both when performing write and read operations. When using this approach the assumption is there is normal distribution of routing field values to have even distribution of the data across all the cluster partitions.

{% tip %}

- It is recommended to use an Integer or a Long field type to be used as the routing field.
- Default routing field is the space id field. In such a case make sure you have the @SpaceId using the `autoGenarate=false` mode.
{% endtip %}

{% warning %}
Converting a numeric value to a String and using the string representation as the routing key will give a different load balancing in comparison to a numeric value.
{% endwarning %}

## Example

A cluster is defined with 3 partitions where each partition have one primary and one backup space.

![load_balancing1.jpg](/attachment_files/load_balancing1.jpg)

The cluster configured to use the hash-based load-balancing policy. The application writes the `Account` space object into the clustered space. The `accountID` field as part of the `Account` class is defined as the routing field using the `@SpaceRouting` decoration.

The Account class implementation:

{% highlight java %}
@SpaceClass
public class Account
{
	Integer accountID;
	String accountName;

	@SpaceRouting
	public Integer getAccountID()
	{
	return accountID;
	}

	public String getAccountName()
	{
		return accountName;
	}
	// setter methods
	...
}
{% endhighlight %}

The `accountID` field value is used by the space client proxy together with the number partitions in the following manner to determine the target space for the write, read, or take operations:

{% highlight java %}
Target Space number = (accountID hashCode value) modulo (Partitions Amount)
{% endhighlight %}

If we will write 30 Account space objects with different `accountID` values into the cluster, the space objects will be routed into the 3 partitions in the following manner:
![load_balancing2.jpg](/attachment_files/load_balancing2.jpg)

{% tip %}
If the relevant target space or its backup space is not active an error message will be thrown.
{% endtip %}

## Hash based Load-Balancing Calculator

See below Hash based Load-Balancing Calculator that calculates the target space of a given routing value.
You may change this to use String based routing values or numerical values.

{% highlight java %}
import java.util.Hashtable;
import java.util.Random;

public class LoadBalancingCalc {
	public static void main(String[] args) {
		int partitions = 10;
//		String values[] = {"A","B","C" , "AAAAAA" , "BBB" , "CCCC", "QQQQ" , "C" , "Y"};

		Random rand = new Random(1000);
		int maxObject =1000;
		String values[]  = new String [maxObject ];
		for (int i=0; i<maxObject ;i++)
		{
			values[i] = String.valueOf(rand.nextInt(maxObject ));
		}

		Hashtable dist = new Hashtable ();
		for (int i=0;i<values.length ; i++)
		{
			int hc = values[i].hashCode();
			int targetPartitionID = safeABS(hc) % partitions;
			Integer dist_value = (Integer)dist.get(targetPartitionID);

			if (dist_value == null)
				dist_value = new Integer(0);

			dist.put(targetPartitionID , dist_value.intValue() + 1) ;
		}
		System.out.println("Total amount of objects:" + maxObject);
		System.out.println("Total amount of partitions:" + partitions);

		for (int i=0;i<dist.size() ; i++)
		{
			System.out.println("Partition " + i +  " have " + dist.get{% infosign %} + " objects");
		}
		System.out.println();
		System.out.println("Routing field values:");
		for (int i=0; i<maxObject ;i++)
		{
			System.out.print (values[i] + ",");
			if ((i % 80 ==0) && (i>80))
				System.out.println();
		}
	}
        static int safeABS( int value)
        {
            return value == Integer.MIN_VALUE ? Integer.MAX_VALUE : Math.abs(value);
        }
}
{% endhighlight %}

Here is an example output:

{% highlight java %}
Total amount of objects:1000
Total amount of partitions:10
Partition 0 have 107 objects
Partition 1 have 104 objects
Partition 2 have 104 objects
Partition 3 have 99 objects
Partition 4 have 104 objects
Partition 5 have 92 objects
Partition 6 have 103 objects
Partition 7 have 103 objects
Partition 8 have 90 objects
Partition 9 have 94 objects

Routing field values:
487,935,676,124,....
{% endhighlight %}

# Load-balancing with Replication/Failover

Load-balancing can be combined with replication. Depending on the application needs and the load-balancing policy used, this may or may not be necessary. For example, if users tend to perform read operations, and the policy used is round-robin, replication will be necessary to ensure the requested space object exists on the target space. If, by contrast, the policy used is distribute-by-class, it may not be necessary to replicate, because the class requested should have been written to the same space.

Load-balancing can also be combined with failover, to achieve both scalability and fault tolerance.

# Broadcast

There are three Broadcast options:

- **`broadcast-if-null-values`** -- for `null` fields, for hash-based `null` index. Default for read, take and notify. Its meaning is: the template is a `null` template (actual `null` or all fields are `null` or no fields), or, if the load-blanacing policy is hash-based, the first index (hash index) is `null` or no index is defined. This option is triggered in the following case: the LB policy is not hash-based and extended-matching (Using `SQLQuery`, for example) is used by the template, or the LB policy is hash-based and extended matching is used and the match-code for the specific field is not EQ (equal). The latter is designated in order to enable query processor and other extended-matching users to query over multiple spaces.
- **`unconditional`** -- use broadcast mode anyway -- whatever the template field value is.
- **`broadcast-disabled`** -- disable broadcast. Operations are routed based on a template's first indexed field. If template's first indexed field is `null`, an error occurs.

# Batch Operation Execution Mode

The following table specifies when the different batch operations executed in parallel manner and when in serial manner when the space running in partitioned mode:

{: .table .table-bordered}
| **Operation** | **Transactional** | **Max values** | **Execution Mode** | Returns when.. |
|:--------------|:------------------|:---------------|:-------------------|:---------------|
| readMultiple | NO | n/a | Parallel | Returns when all spaces completed their operation |
| readMultiple | YES (should use JiniTX) | < Integer.MAX_VALUE | **Serial** | Returns when found enough matching space objects |
| readMultiple | n/a(if YES should use JiniTX) | Integer. MAX_VALUE | Parallel | Returns when all spaces completed their operation |
| takeMultiple | n/a | < Integer.MAX_VALUE | **Serial** | Returns when all spaces completed their operation |
| takeMultiple | n/a (if YES should use JiniTX) | Integer.MAX_VALUE | Parallel | Returns when all spaces completed their operation |
| writeMultiple | n/a | n/a | Parallel | Returns when all spaces completed their operation |
| updateMultiple | n/a | n/a | Parallel | Returns when all spaces completed their operation |

- A Parallel operation on the client means that the partition proxy will run a thread against each of its constituent partition proxies, each thread excuting the operation (take , read). Corollary: every partition will experience a read/take multiple. No partition can guarantee that it will supply objects that the application client obtains in its result.
- A Serial operation on the client means that the partition proxy will execute one read/take multiple on each partition, the partitions being accessed in partition number order, 0 through max partition number. The readMultiple/takeMultiple will complete as soon as the requisite number of objects has been read/taken, or all partitions accessed, whichever comes soonest. Corollary: only partition 0 can guarantee that it will experience a readMultiple/takeMultiple - i.e according to the member ID - Each partition has a numeric running ID associated with it and the processing done according their order(0 to N).
- When executing custom queries against partitioned space (triggers the space filter) you should use the takeMultiple or readMultiple with Integer.MAX_VALUE as the max values to execute the filter operation in parallel across the partitions.
- WriteMultipe/UpdateMultiple with a transaction executed in parallel manner.
- When calling any of the batch operations with a template and set the routing id in the template (making sure all the space objects go to the same physical space in a cluster) you do not need to use jini transaction. Local transaction will suffice.
- readMultiple/takeMultiple against any single partition is a synchronous call in the associated partition specific client proxy. The space operation is a synchronous operation. It will return as many requested objects as are currently present in the space, up to the number requested. If no objects are matched an empty array is returned.

## Parallel Operation Thread Pool

The client performs parallel operations using a dedicated thread pool managed at the proxy. You may tune this pool size via the following settings at the cluster config:

{% highlight xml %}
<proxy-broadcast-threadpool-min-size>4</proxy-broadcast-threadpool-min-size>
<proxy-broadcast-threadpool-max-size>64</proxy-broadcast-threadpool-max-size>
{% endhighlight %}

## Considerations

- The replication scheme does not take into account `IReplicatable` (partial replication) and replication matrix.
- In some cases broadcast can cause ownership/SSI problems to happen.
- Operations under a Local transaction are not supported when the transaction involves multiple partitions - you should use in such a case the Distributed Transaction manager.
- All objects with a given routing value will be stored on the _same partition_. This means that a given partition _must_ be able to hold all similarly-routed objects. If the routing value is weighted too far in a given direction (i.e., the distribution is very uneven, with one value having 90% of the data set, for example) the partitioning will be uneven. It's best to use a derived routing field that gives a flat distribution across all nodes, if possible.

{% endtoczone %}
