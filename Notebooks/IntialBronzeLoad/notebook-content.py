# Synapse Analytics notebook source

# METADATA ********************

# META {
# META   "synapse": {
# META     "lakehouse": {
# META       "default_lakehouse": "bf5725ea-3363-4b0a-9cdc-fd52efdc7997",
# META       "default_lakehouse_name": "CityCrashData",
# META       "default_lakehouse_workspace_id": "48fd17ca-aeff-44b8-9582-1e2cf6eaa9fd",
# META       "known_lakehouses": [
# META         {
# META           "id": "bf5725ea-3363-4b0a-9cdc-fd52efdc7997"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

df_crash = spark.read.format("csv").option("header", "true").load("Files/Bronze/NYC/CollisionsCrashes.csv")

# CELL ********************

df_crash_renamed = df_crash 

for col in df_crash.dtypes:
    old_field_name = col[0]
    new_field_name = col[0].replace(" ", "_")
    df_crash_renamed = df_crash_renamed.withColumnRenamed(old_field_name, new_field_name)

print("Done renaming columns")

# CELL ********************

for col in df_crash_renamed.dtypes:
    print(col[0])

# CELL ********************

df_crash_renamed.write.mode("overwrite").format("delta").saveAsTable("bronze_nyc_crashes")

# CELL ********************

df_vehicle = spark.read.format("csv").option("header", "true").load("Files/Bronze/NYC/CollisionsVehicles.csv")

# CELL ********************

df_vehicle_renamed = df_vehicle

for col in df_vehicle.dtypes:
    old_field_name = col[0]
    new_field_name = col[0].replace(" ", "_")
    df_vehicle_renamed = df_vehicle_renamed.withColumnRenamed(old_field_name, new_field_name)

print("Done renaming columns")

# CELL ********************

df_vehicle_renamed.write.mode("overwrite").format("delta").saveAsTable("bronze_nyc_vehicles")
