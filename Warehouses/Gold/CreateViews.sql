SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Dim].[vCollision]
AS 
SELECT DimCollisionID ,
    CollisionID
FROM Dim.Collision

GO

;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Dim].[vCollisionContributingFactor]
AS 
SELECT DimCollisionID 
    , DimContributingFactorID 
FROM Dim.CollisionContributingFactor

GO

;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [Dim].[vCollisionLocation]
AS
SELECT DimCollisionLocationID 
    , Longitude 
    , Latitude
    , Longitude+','+Latitude AS Coordinates 
    , UPPER(OnStreetName) AS [On Street Name] 
    , UPPER(CrossStreetName) AS [Cross Street Name] 
    , UPPER(OffStreetName) AS [Off Street Name]
    , ZipCode AS [Zip Code]
    , UPPER(Borough) AS Borough
    , 'NY' as [State]
FROM Dim.CollisionLocation



GO 

;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Dim].[vCollisionVehicle]
AS 
SELECT DimCollisionID ,
    DimVehicleID ,
	TravelDirection
FROM Dim.CollisionVehicle


GO

;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view Dim.vContributingFactor
as 
select cf.DimContributingFactorID 
    , cf.ContributingFactor [Contributing Factor]
from Dim.ContributingFactor as cf
GO

;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [Dim].[vDate] 
as 
select cast(d.DimDateId AS INT) DimDateId 
    , cast(d.CalendarDate as date) as [Calendar Date] 
    , cast(d.DayNumber as int) as [Day Number] 
    , cast(d.MonthNumber as int) as [Month Number]
    , d.MonthNameLabel as [Month Name]
    , cast(d.YearNumber as int) as [Year Number]
from Dim.[Date] as d
where cast(d.CalendarDate as date) >= '2012-01-01'
    and cast(d.CalendarDate as date) <= (SELECT MAX(cast(cd.CalendarDate as date)) FROM Fact.HumanImpact hi INNER JOIN Dim.Date cd on cd.DimDateId = hi.DimCrashDateID)



GO
;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [Dim].[vVehicle] as 
select v.DimVehicleID 
    , v.StateRegistration as [State Registration]
    , v.UniqueVehicleID 
    , v.VehicleMake as [Vehicle Make]
    , v.VehicleModel as [Vehicle Model]
    , v.VehicleType as [Vehicle Type]
from Dim.Vehicle v
GO

;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

;

CREATE view Fact.vHumanImpact
as 
select hi.DimCollisionID
    , hi.DimCollisionLocationID
    , hi.DimCrashDateID
    , hi.NumberOfCyclistInjured as [Number of Cyclist Injured]
    , hi.NumberOfCyclistKilled as [Number of Cyclist Killed]
    , hi.NumberOfMotoristInjured as [Number of Motorist Injured]
    , hi.NumberOfMotoristKilled as [Number of Motorist Killed]
    , hi.NumberOfPedestriansInjured as [Number of Pedestrians Injured]
    , hi.NumberOfPedestriansKilled as [Number of Pedestrians Killed]
    , hi.NumberOfPersonsInjured as [Number of Persons Injured]
    , hi.NumberOfPersonsKilled as [Number of Persons Killed]
from Fact.HumanImpact hi

GO

;



