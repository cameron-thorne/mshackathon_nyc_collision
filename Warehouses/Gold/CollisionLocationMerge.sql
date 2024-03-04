SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [Dim].[CollisionLocationMerge]

AS
BEGIN

--Lets just do type 1 for this project

--I had problems with primary keys so I am just going to do a ROW_NUMBER cheat
DECLARE @MaxDimCollisionLocationID INT 
SET @MaxDimCollisionLocationID = (SELECT MAX(DimCollisionLocationID) FROM Gold.Dim.CollisionLocation)

--Cant do merge sadface
--Update

UPDATE dimcl
SET dimcl.Longitude = ISNULL(crashes.LONGITUDE, ''),
dimcl.Latitude = ISNULL(crashes.LATITUDE, ''),
dimcl.OnStreetName = ISNULL(crashes.ON_STREET_NAME, ''),
dimcl.CrossStreetName = ISNULL(crashes.CROSS_STREET_NAME, ''),
dimcl.OffStreetName = ISNULL(crashes.OFF_STREET_NAME, ''),
dimcl.ZipCode = ISNULL(crashes.ZIP_CODE, ''),
dimcl.Borough = ISNULL(crashes.BOROUGH, '')
FROM Silver.dbo.silver_nyc_crashes AS crashes
JOIN Silver.dbo.silver_nyc_vehicles AS vehicles ON crashes.COLLISION_ID = vehicles.COLLISION_ID
INNER JOIN Gold.Dim.CollisionLocation AS dimcl ON dimcl.Latitude = ISNULL(crashes.LATITUDE, '') AND dimcl.Longitude = ISNULL(crashes.LONGITUDE, '')
WHERE ISNULL(crashes.LONGITUDE, '') <> ''
AND ISNULL(crashes.LATITUDE, '') <> ''

DECLARE @NegativeOneBit INT 
SET @NegativeOneBit = (SELECT CASE WHEN ISNULL((SELECT COUNT(*) FROM Gold.Dim.CollisionLocation), 0) > 0 THEN 1 ELSE 0 END)

IF @NegativeOneBit = 0

BEGIN 

INSERT INTO Gold.Dim.CollisionLocation
(
DimCollisionLocationID,
Longitude,
Latitude,
OnStreetName,
CrossStreetName,
OffStreetName,
ZipCode,
Borough,
CreateTmsp
)
VALUES 
(
-1,
'' ,
'' ,
'' ,
'' ,
'' ,
'' ,
'' ,
GETDATE()
)

END

--Insert

INSERT INTO Gold.Dim.CollisionLocation
(
DimCollisionLocationID,
Longitude,
Latitude,
OnStreetName,
CrossStreetName,
OffStreetName,
ZipCode,
Borough,
CreateTmsp
)
SELECT 
ROW_NUMBER() OVER (ORDER BY t.Longitude) + ISNULL(@MaxDimCollisionLocationID, 0) DimCollisionLocationID,
Longitude,
Latitude,
OnStreetName,
CrossStreetName,
OffStreetName,
ZipCode,
Borough,
CreateTmsp
FROM
(
SELECT 
DISTINCT
ISNULL(crashes.LONGITUDE, '') AS Longitude,
ISNULL(crashes.LATITUDE, '') AS Latitude,
ISNULL(crashes.ON_STREET_NAME, '') AS OnStreetName,
ISNULL(crashes.CROSS_STREET_NAME, '') AS CrossStreetName,
ISNULL(crashes.OFF_STREET_NAME, '') AS OffStreetName,
ISNULL(crashes.ZIP_CODE, '') AS ZipCode,
ISNULL(crashes.BOROUGH, '') AS Borough,
GETDATE() CreateTmsp
FROM Silver.dbo.silver_nyc_crashes AS crashes
JOIN Silver.dbo.silver_nyc_vehicles AS vehicles ON crashes.COLLISION_ID = vehicles.COLLISION_ID
LEFT JOIN Gold.Dim.CollisionLocation AS dimcl ON dimcl.Latitude = ISNULL(crashes.LATITUDE, '') 
AND dimcl.Longitude = ISNULL(crashes.LONGITUDE, '')
AND dimcl.OnStreetName = ISNULL(crashes.ON_STREET_NAME, '')
AND dimcl.CrossStreetName = ISNULL(crashes.CROSS_STREET_NAME, '')
AND dimcl.OffStreetName = ISNULL(crashes.OFF_STREET_NAME, '')
AND dimcl.ZipCode = ISNULL(crashes.ZIP_CODE, '')
AND dimcl.Borough = ISNULL(crashes.BOROUGH, '')
WHERE ISNULL(crashes.LONGITUDE, '') <> ''
AND ISNULL(crashes.LATITUDE, '') <> ''
AND dimcl.DimCollisionLocationID IS NULL
) t

END




GO

