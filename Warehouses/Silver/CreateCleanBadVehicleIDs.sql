SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.CleanBadVehicleIDs

AS
BEGIN
	-- We drop vehicle id's 1 to 10 because they have high counts by collision id. 
    delete from dbo.silver_nyc_vehicles
	where VEHICLE_ID IN
	(
	'1'
	, '2'
	, '3'
	, '4'
	, '5'
	, '6'
	, '7'
	, '8'
	, '9'
	, '10'
	)
END

GO

