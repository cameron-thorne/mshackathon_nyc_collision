# Power Bi Reports for Vehicle Collisions in New York City, NY
In New York City in the United States, a standard policy report is required, when a vehicle collison occurs where someone is injured, killed, or if there is at least $1,000 worht of damage. This data is collected and published online to New York City's Open Data initative. 

The scenario is to provide live Power BI report to provide descriptive analytics and insight into location, contributing factors, and vehicle types for vehicle collisions. 

This solution does the following:
- Uses Data Factory to pull collison and vehicles involved data on a daily basis via an API call to New York City's Open Data website and lands it in a Lakehouse as tables. Data can be explored via the SQL Analytics Endpoint or PySpark/Spark SQL using a notebook.
- A standard Medallion Architecture is applied. The Lakehouse serves as Bronze, and two Warehouses serve for Silver and Gold. Via Data Factory, daily data is flowed through to Gold.
- A semantic model built with SQL Views from Gold that uses Direct Lake mode
- Two seperate Power BI reports were created initially using CoPilot. The reports were then reviewed and amended for more effective reporting.
