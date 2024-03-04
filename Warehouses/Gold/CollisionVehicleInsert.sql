SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROC [Dim].[CollisionVehicleInsert]

AS
BEGIN

INSERT INTO Gold.Dim.CollisionVehicle
(
    DimCollisionID ,
    DimVehicleID ,
	TravelDirection ,
    CreateTmsp
)

SELECT col.DimCollisionID ,
    ISNULL(ve.DimVehicleID, -1) AS DimVehicleID ,
	ISNULL(v.TRAVEL_DIRECTION, '') AS TravelDirection ,
    GETDATE()
FROM Silver.dbo.silver_nyc_crashes c
LEFT JOIN Silver.dbo.silver_nyc_vehicles v ON v.COLLISION_ID = c.COLLISION_ID
LEFT JOIN Gold.Dim.Collision col ON col.CollisionID = c.COLLISION_ID 
LEFT JOIN Gold.Dim.Vehicle ve ON ve.UniqueVehicleID = v.VEHICLE_ID


END



GO

