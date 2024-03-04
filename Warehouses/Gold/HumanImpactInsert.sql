SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROC [Fact].[HumanImpactInsert]

AS
BEGIN

--Lets just do type 1 for this project

--I had problems with primary keys so I am just going to do a ROW_NUMBER cheat
--DECLARE @MaxFactHumanImpactID INT 
--SET @MaxFactHumanImpactID = (SELECT MAX(DimCollisionLocationID) FROM Gold.Fact.HumanImpact)

DELETE FROM Gold.Fact.HumanImpact

--Insert

INSERT INTO Gold.Fact.HumanImpact
(
FactHumanImpactID,
DimCollisionID ,
DimCollisionLocationID,
DimCrashDateID,
NumberOfPersonsInjured,
NumberOfPersonsKilled,
NumberOfPedestriansInjured,
NumberOfPedestriansKilled,
NumberOfCyclistInjured,
NumberOfCyclistKilled,
NumberOfMotoristInjured,
NumberOfMotoristKilled,
CreateTmsp
)
SELECT
ROW_NUMBER() OVER (ORDER BY ISNULL(crashes.COLLISION_ID, '')) /*+ ISNULL(@MaxFactHumanImpactID, 0)*/ FactHumanImpactID,
ISNULL(co.DimCollisionID, -1) DimCollisionID ,
ISNULL(dimcl.DimCollisionLocationID, -1) DimCollisionLocationID,
ISNULL(crashdate.DimDateId, -1) DimCrashDateID,
ISNULL(NUMBER_OF_PERSONS_INJURED, 0) NumberOfPersonsInjured,
ISNULL(NUMBER_OF_PERSONS_KILLED, 0) NumberOfPersonsKilled,
ISNULL(NUMBER_OF_PEDESTRIANS_INJURED, 0) NumberOfPedestriansInjured,
ISNULL(NUMBER_OF_PEDESTRIANS_KILLED, 0) NumberOfPedestriansKilled,
ISNULL(NUMBER_OF_CYCLIST_INJURED, 0) NumberOfCyclistInjured,
ISNULL(NUMBER_OF_CYCLIST_KILLED, 0) NumberOfCyclistKilled,
ISNULL(NUMBER_OF_MOTORIST_INJURED, 0) NumberOfMotoristInjured,
ISNULL(NUMBER_OF_MOTORIST_KILLED, 0) NumberOfMotoristKilled,
GETDATE() CreateTmsp
--SELECT COUNT(*)
FROM Silver.dbo.silver_nyc_crashes AS crashes
LEFT JOIN Gold.Dim.Collision co on co.CollisionID = crashes.COLLISION_ID
LEFT JOIN Gold.Dim.CollisionLocation AS dimcl ON dimcl.Latitude = ISNULL(crashes.LATITUDE, '') 
AND dimcl.Longitude = ISNULL(crashes.LONGITUDE, '')
AND dimcl.OnStreetName = ISNULL(crashes.ON_STREET_NAME, '')
AND dimcl.CrossStreetName = ISNULL(crashes.CROSS_STREET_NAME, '')
AND dimcl.OffStreetName = ISNULL(crashes.OFF_STREET_NAME, '')
AND dimcl.ZipCode = ISNULL(crashes.ZIP_CODE, '')
AND dimcl.Borough = ISNULL(crashes.BOROUGH, '')
LEFT JOIN Gold.Dim.Date crashdate ON ISNULL(CAST(crashes.CRASH_DATE as date), '1900-01-01') = CAST(crashdate.CalendarDate as DATE)
WHERE ISNULL(crashes.LONGITUDE, '') <> ''
AND ISNULL(crashes.LATITUDE, '') <> ''

END






GO

