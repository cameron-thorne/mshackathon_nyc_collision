SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Dim].[Collision]
(
	[DimCollisionID] [int]  NOT NULL,
	[CollisionID] [int]  NOT NULL,
	[CreateTmsp] [date]  NOT NULL
)
GO ;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Dim].[CollisionContributingFactor]
(
	[DimCollisionID] [int]  NULL,
	[DimContributingFactorID] [int]  NULL,
	[CreateTmsp] [date]  NULL
)
GO ;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Dim].[CollisionLocation]
(
	[DimCollisionLocationID] [int]  NOT NULL,
	[Longitude] [varchar](8000)  NOT NULL,
	[Latitude] [varchar](8000)  NOT NULL,
	[OnStreetName] [varchar](8000)  NULL,
	[CrossStreetName] [varchar](8000)  NULL,
	[OffStreetName] [varchar](8000)  NULL,
	[ZipCode] [varchar](8000)  NULL,
	[Borough] [varchar](8000)  NULL,
	[CreateTmsp] [date]  NOT NULL
)
GO ;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Dim].[CollisionVehicle]
(
	[DimCollisionID] [int]  NULL,
	[DimVehicleID] [int]  NULL,
	[TravelDirection] [varchar](8000)  NULL,
	[CreateTmsp] [date]  NULL
)
GO ;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Dim].[ContributingFactor]
(
	[DimContributingFactorID] [int]  NOT NULL,
	[ContributingFactor] [varchar](8000)  NULL,
	[CreateTmsp] [date]  NULL
)
GO ;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Dim].[Date]
(
	[DimDateId] [varchar](8000)  NULL,
	[CalendarDate] [varchar](8000)  NULL,
	[DisplayDate] [varchar](8000)  NULL,
	[DayNumber] [varchar](8000)  NULL,
	[DayNumberOfWeek] [varchar](8000)  NULL,
	[DayNumberOfYear] [varchar](8000)  NULL,
	[WeekNumber] [varchar](8000)  NULL,
	[MonthWeekLabel] [varchar](8000)  NULL,
	[MonthNumber] [varchar](8000)  NULL,
	[MonthNameLabel] [varchar](8000)  NULL,
	[QuarterNumber] [varchar](8000)  NULL,
	[QuarterLabel] [varchar](8000)  NULL,
	[YearNumber] [varchar](8000)  NULL,
	[YearQuarterLabel] [varchar](8000)  NULL,
	[MonthStartDate] [varchar](8000)  NULL,
	[MonthEndDate] [varchar](8000)  NULL,
	[QuarterStartDate] [varchar](8000)  NULL,
	[QuarterEndDate] [varchar](8000)  NULL,
	[YearStartDate] [varchar](8000)  NULL,
	[YearEndDate] [varchar](8000)  NULL,
	[FullDateLabel] [varchar](8000)  NULL
)
GO ;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Dim].[Vehicle]
(
	[DimVehicleID] [int]  NOT NULL,
	[UniqueVehicleID] [varchar](8000)  NOT NULL,
	[StateRegistration] [varchar](8000)  NOT NULL,
	[VehicleType] [varchar](8000)  NOT NULL,
	[VehicleMake] [varchar](8000)  NOT NULL,
	[VehicleModel] [varchar](8000)  NOT NULL,
	[CreateTmsp] [date]  NOT NULL
)
GO ;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Fact].[HumanImpact]
(
	[FactHumanImpactID] [int]  NOT NULL,
	[DimCollisionID] [int]  NOT NULL,
	[DimCollisionLocationID] [int]  NOT NULL,
	[DimCrashDateID] [int]  NOT NULL,
	[NumberOfPersonsInjured] [int]  NOT NULL,
	[NumberOfPersonsKilled] [int]  NOT NULL,
	[NumberOfPedestriansInjured] [int]  NOT NULL,
	[NumberOfPedestriansKilled] [int]  NOT NULL,
	[NumberOfCyclistInjured] [int]  NOT NULL,
	[NumberOfCyclistKilled] [int]  NOT NULL,
	[NumberOfMotoristInjured] [int]  NOT NULL,
	[NumberOfMotoristKilled] [int]  NOT NULL,
	[CreateTmsp] [date]  NOT NULL
)
GO ;