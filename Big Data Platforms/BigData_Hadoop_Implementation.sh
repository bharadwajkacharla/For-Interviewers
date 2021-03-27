#Assignment Details
#You have zip file loaded into /project2/msca/kadochnikov/data/Municipal_Court_Caseload_Information.zip in Linux environment, representing the caseload for Austin municipal courts.

#1.Copy the file into your own directory on Linux server
[bharadwajk@md01 assignment3]$ cp /project2/msca/kadochnikov/data/Municipal_Court_Caseload_Information.zip /project2/msca/bharadwajk/assignment3/

#2.Unzip the file

[bharadwajk@md01 assignment3]$  cd /home/bharadwajk/assignment3/
[bharadwajk@md01 assignment3]$  unzip Municipal_Court_Caseload_Information.zip

#3. Load the file into Hive table

#the below snippet helps us in understanding the data types of the csv file
[bharadwajk@md01 assignment3]$  head -5 Municipal_Court_Caseload_Information.csv

Offense Case Type,Offense Date,Offense Time,Offense Charge Description,Offense Street Name,Offense Cross Street Check , 
Offense Cross Street,School Zone,Construction Zone,Case Closed
TR,04/29/2010 07:00:00 AM +0000,22.40.00,FAILED TO MAINTAIN FINANCIAL RESPONSIBILITY,8000 BLOCK RESEARCH,N, ,N,N,Y
TR,04/29/2010 07:00:00 AM +0000,22.40.00,FAILURE TO SIGNAL INTENT TO CHANGE LANES,8000 BLOCK RESEARCH,N, ,N,N,Y
TR,04/29/2010 07:00:00 AM +0000,20.00.00,SPEEDING-STATE HIGHWAYS,1000 BLOCK NORTH U S 183,N, ,N,N,Y
TR,04/29/2010 07:00:00 AM +0000,20.00.00,NO SEAT BELT-DRIVER/PASSENGER,1000 BLOCK NORTH U S 183,N, ,N,N,Y

[bharadwajk@md01 assignment3]$ hive;
hive> create database bharadwajk;
hive> use database bharadwajk;

#Creating external table
hive> create external table municipal_court 
        (Offense_Case_Type string, 
        Offense_Date date, 
        Offense_Time timestamp, 
        Offense_Charge_Description string, 
        Offense_Street_Name varchar(50), 
        Offense_Cross_Street_Check string, 
        Offense_Cross_Street varchar(50), 
        School_Zone string, 
        Construction_Zone string, 
        Case_Closed string)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE
    tblproperties ("skip.header.line.count"="1");

hive> LOAD DATA LOCAL INPATH '/home/bharadwajk/assignment3' INTO TABLE municipal_court;

# 5. Delete both zipped file and CSV file from Linux machine, keeping only the file in HDFS

[bharadwajk@md01 assignment3$] rm Municipal_Court_Caseload_Information.*

#6. Calculate frequency of offences by Offense Case Type

hive> select 
    >     offense_case_type,
    >     count(*) as frequency_of_offences
    > from municipal_court
    > group by offense_case_type;

#7. Identify the most frequent offences by Offense Charge Description
 (Show Offense Charge Description and offence frequency count in descending order)

 hive > SELECT 
            offense_charge_description as Offense_Description, 
            count(offense_charge_description) as Frequency
        > FROM municipal_court
        > GROUP BY offense_charge_description
        > ORDER BY Frequency DESC
        > LIMIT 5;