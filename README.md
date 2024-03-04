# Power BI Reports for Vehicle Collisions in New York City, NY built in Fabric 
In New York City in the United States, a standard police report is required when a vehicle collision occurs where someone is injured, killed, or if there is at least $1,000 worth of damage. This data is collected and published online as an open data source at [NYC Open Data](https://opendata.cityofnewyork.us/) and is updated daily. 

The two datasets used are Crashes and Vehicles per the URL's below:

[Crashes](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95/about_data)

[Vehicles](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Vehicles/bm4k-52h4/about_data)

The scenario is to provide Power BI reports that are updated daily to provide descriptive analytics and insight into location, contributing factors, and vehicle types for vehicle collisions using Fabric and CoPilot. This solution also provides foundations for other personas like Data Analysts and Data Scientists for future work.

![image](https://github.com/cameron-thorne/mshackathon_nyc_collision/assets/13606996/54d04885-d468-42f3-b78f-585d66aba3bf)

![image](https://github.com/cameron-thorne/mshackathon_nyc_collision/assets/13606996/aa3c591b-e912-4172-8b50-8eb6ff8806db)


This solution does the following in a Fabric workspace:
- Uses notebooks and PySpark to load intial CSV files as delta tables into a Lakehouse. 
- Uses Data Factory to pull collison and vehicles involved data on a daily basis via an API call to New York City's Open Data website and lands it in a Lakehouse as tables. Data can be explored via the SQL Analytics Endpoint or PySpark/Spark SQL using a notebook.
- A standard Medallion Architecture is applied. The Lakehouse serves as Bronze, and two Warehouses serve for Silver and Gold. Via Data Factory, daily data is flowed through to Gold. CoPilot was used to help with creating some pipelines and for questions. 
- A semantic model built with SQL Views from Gold that uses Direct Lake mode.
- Two seperate Power BI reports were created initially using CoPilot. The reports were then reviewed and amended for more effective reporting.

  ![image](https://github.com/cameron-thorne/mshackathon_nyc_collision/assets/13606996/02182050-c1f5-43f5-a20f-48c9fd062834)


# Setup instructions

You will need to create a Fabric workspace. Most files needed are in the repository but some are not because of current limitations of GIT versioning in Fabric as of 3/3/2024. 

## Get inital data and load into Lakehouse

We need to create our inital dataset. We cannot do this via API because without registration, the API has a 1,000 row limit. We ideally only need to do this once to set up the data and then any new data will come from the API. 

1. Create a Lakehouse and name it CityCrashData.
2. Go to the NYC Open Data website for [Crashes](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Vehicles/bm4k-52h4/about_data) and export the dataset as a CSV file. Because the file is large, it cannnot be hosted in a GitHub repository. Please note, there is a record in the CSV file with a line space in it. This shifts data into incorrect columns. The most simple way to remove this new line, is to use a text editor like Visual Studio Code. You will need to complete this step before you go on further.
3. Create a folder named "NYC" in the Files folder in the Lakehouse.  
4. Upload the CSV file with the name "CollisionsCrashes.csv".
5. Go to the NYC Open Data website for [Vehicles](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Vehicles/bm4k-52h4/about_data) and export the dataset as a CSV file.
6. Upload the CSV file with the name "CollisionsVehicles.csv".
7. Run the notebook InitialBronzeLoad and run it. It will take the CSV files and load them as Delta tables in the Lakehouse.

## Set up Silver Warehouse

1. Create a Warehouse named "Silver".
2. Run the SQL scripts in the Silver folder in Warehouses to create tables and stored procedures.

## Set up Gold Warehouse

1. Create a Warehouse named "Gold".
2. Run the SQL scripts in the Gold folder in Warehouses to create tables, views, and stored procedures.

## Set up Silver_Load Pipelines 

Note, currently, there is no feature to upload pipelines from JSON files. It's a feature that Microsoft is working on and this will change when it becomes available. 

1. Create a pipeline with the name "Silver_Load".  
2. Set it up per the image below and details from the JSON file for Silver_Load in the Pipelines folder.
   ![image](https://github.com/cameron-thorne/mshackathon_nyc_collision/assets/13606996/c8b315e6-50b8-476d-94c6-412a0a781b12)

## Set up Gold_Load Pipeline

Note, currently, there is no feature to upload pipelines from JSON files. It's a feature that Microsoft is working on and this will change when it becomes available. 

1. Create a pipeline with the name "Gold_Load"
2. Set it up per the image below and details from the JSON file for Gold_Load in the Pipelines folder.
   ![image](https://github.com/cameron-thorne/mshackathon_nyc_collision/assets/13606996/74e9433b-2296-40c8-80cf-3df630c407c1)

## Set up main_daily Pipeline

Note, currently, there is no feature to upload pipelines from JSON files. It's a feature that Microsoft is working on and this will change when it becomes available. 

1. Create a pipeline with the name "main_daily".
2. Set it up per the image below and details from the JSON file for main_daily in the Pipelines folder.
   ![image](https://github.com/cameron-thorne/mshackathon_nyc_collision/assets/13606996/5e5adcf3-e0e5-4310-9844-31ce86ab9965)
3. Set up scheduled run for time you prefer. We set ours to run at daily at 7:00 PM Central (United States).

## Set up semantic model

We created our semantic model using Tabular Editor 3 Enterprise. 

1. Create a Semantic Model named "NYC_CrashModel".
2. Connect to the model using Tabular Editor 3 and save the model's TOM to a folder with a working database connection to Fabric locally on your computer.
3. Copy the contents of the "tables" folder in Semantic/NYC_CrashModel file path in the repository to the tables folder on your local computer.
4. Save the changes to the database.
5. Refresh the model.

## Set up the Power BI reports

Complete the following for the two PBIX files in the Reports repository folder.

1. Open the PBIX file with Power BI Desktop.
2. Go to Data Source Settings and switch to the semantic model NYC_CrashModel that you created.
3. Publish the report to the Fabric workspace.



