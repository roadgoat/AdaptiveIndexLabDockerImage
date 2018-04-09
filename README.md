# Adaptive Lab Docker Image
Adaptive index demo - Dockerfile and scripts.  Couchbase 5.x and greater.
This projects consists of a Dockerfile, a configuration shell script that is run in the Ubuntu container and a Couchbase back up file.  This project was built with Couchbase 5.1.  

To Create the Container, you must have Docker Version 18.03.0 or higher.  Download this repository, unzip the contents to a working directory, go to that directory from the command line and run the following:

docker build .

docker run -d --name db -p 8091-8094:8091-8094 -p 11210:11210 -p 9100-9105:9100-9105 <image_id>

![alt text](https://github.com/roadgoat/AdaptiveIndexDemo/blob/master/CommandLine1.png)

You can connect to the Couchbase node by going to http://127.0.0.0.1:8091  

User: Administrator
Password: password

![alt text](https://github.com/roadgoat/AdaptiveIndexDemo/blob/master/Screen%20Shot%202018-03-30%20at%2010.14.53%20AM.png)

The following test N1QL statements can be run against this data set:

select count(Crash_Id), Crash_Group_ID from Metadata where
Crash_Id is not missing and 
Crash_Group_ID is not missing and
App_Key = "AD-AAB-AAA-NWN" AND
Mobile_App_Name = "com.appdynamics.android" AND
App_Crash_Time <= "12/19/17 5:13" AND 
type = "MobileCrashReport"
GROUP BY Crash_Group_ID;

SELECT * FROM Metadata
WHERE App_Key = "AD-AAB-AAB-XTE" AND
      Region = "Minnesota" AND
      Browser = "Firefox" AND
      Session_Start_Time < "12/20/17 13:14" AND
      type="BrowserSessions";

SELECT * FROM Metadata
WHERE App_Key = "AD-AAB-AAB-XTE" AND
      (Page_Name = "controller/app/view/customdashboard/widgets" OR Page_Name = "d%") AND
      Timestamp between '12/20/17 13:11' AND '12/21/17 13:11
' AND
      type = "BrowserSnapshots"    
      

![alt text](https://github.com/roadgoat/AdaptiveIndexDemo/blob/master/QuerySample.png)

Note: The primary index on the sample bucket was note built.  
