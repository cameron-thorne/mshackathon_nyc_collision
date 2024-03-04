SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [Dim].[VehicleMerge]

AS
BEGIN

--Lets just do type 1 for this project

--I had problems with primary keys so I am just going to do a ROW_NUMBER cheat
DECLARE @MaxDimVehicleID INT 
SET @MaxDimVehicleID = (SELECT MAX(DimVehicleID) FROM Gold.Dim.Vehicle)

--Cant do merge sigh
--Update

UPDATE dimv
SET dimv.UniqueVehicleID = ISNULL(vehicles.VEHICLE_ID, ''),
dimv.StateRegistration = ISNULL(vehicles.STATE_REGISTRATION, ''),
dimv.VehicleType = ISNULL(vehicles.VEHICLE_TYPE, ''),
dimv.VehicleMake = ISNULL(vehicles.VEHICLE_MAKE, ''),
dimv.VehicleModel = ISNULL(vehicles.VEHICLE_MODEL, '')
FROM Silver.dbo.silver_nyc_vehicles AS vehicles 
INNER JOIN Gold.Dim.Vehicle AS dimv ON ISNULL(vehicles.VEHICLE_ID, '') = dimv.UniqueVehicleID
WHERE ISNULL(vehicles.VEHICLE_ID, '') <> ''

DECLARE @NegativeOneBit INT 
SET @NegativeOneBit = (SELECT CASE WHEN ISNULL((SELECT COUNT(*) FROM Gold.Dim.Vehicle), 0) > 0 THEN 1 ELSE 0 END)

IF @NegativeOneBit = 0

BEGIN 

INSERT INTO Gold.Dim.Vehicle
(
DimVehicleID,
UniqueVehicleID,
StateRegistration,
VehicleType,
VehicleMake,
VehicleModel,
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
GETDATE()
)

END

--Insert

INSERT INTO Gold.Dim.Vehicle
(
DimVehicleID,
UniqueVehicleID,
StateRegistration,
VehicleType,
VehicleMake,
VehicleModel,
CreateTmsp
)
SELECT 
ROW_NUMBER() OVER (ORDER BY ISNULL(vehicles.UNIQUE_ID, '')) + ISNULL(@MaxDimVehicleID, 0) DimVehicleID,
ISNULL(vehicles.VEHICLE_ID, '') AS UniqueVehicleID,
ISNULL(vehicles.STATE_REGISTRATION, '') AS StateRegistration,
ISNULL(vehicles.VEHICLE_TYPE, '') AS VehicleType,
ISNULL(vehicles.VEHICLE_MAKE, '') AS VehicleMake,
ISNULL(vehicles.VEHICLE_MODEL, '') AS VehicleModel,
GETDATE() CreateTmsp
--SELECT TOP 1000 *
FROM Silver.dbo.silver_nyc_vehicles AS vehicles
LEFT JOIN Gold.Dim.Vehicle AS dimv ON ISNULL(vehicles.VEHICLE_ID, '') = dimv.UniqueVehicleID
WHERE ISNULL(vehicles.VEHICLE_ID, '') <> ''
AND dimv.UniqueVehicleID IS NULL


END





GO

