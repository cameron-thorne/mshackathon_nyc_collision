SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Dim].[CollisionContributingFactorInsert]

AS
BEGIN
insert into Dim.CollisionContributingFactor
(
DimCollisionID ,
DimContributingFactorID ,
CreateTmsp
)
    select dc.DimCollisionID 
	, isnull(cf1.DimContributingFactorID, -1) DimContributingFactorID
	, getdate()
from Silver.dbo.silver_nyc_crashes c
left join Dim.Collision dc on dc.CollisionID = c.COLLISION_ID
left join Dim.ContributingFactor cf1 on cf1.ContributingFactor = c.CONTRIBUTING_FACTOR_VEHICLE_1
where c.CONTRIBUTING_FACTOR_VEHICLE_1 is not null

union all

select dc.DimCollisionID 
	, isnull(cf2.DimContributingFactorID, -1) DimContributingFactorID
	, getdate()
from Silver.dbo.silver_nyc_crashes c
left join Dim.Collision dc on dc.CollisionID = c.COLLISION_ID
left join Dim.ContributingFactor cf2 on cf2.ContributingFactor = c.CONTRIBUTING_FACTOR_VEHICLE_2
where c.CONTRIBUTING_FACTOR_VEHICLE_2 is not null

union all

select dc.DimCollisionID 
	, isnull(cf3.DimContributingFactorID, -1) DimContributingFactorID
	, getdate()
from Silver.dbo.silver_nyc_crashes c
left join Dim.Collision dc on dc.CollisionID = c.COLLISION_ID
left join Dim.ContributingFactor cf3 on cf3.ContributingFactor = c.CONTRIBUTING_FACTOR_VEHICLE_3
where c.CONTRIBUTING_FACTOR_VEHICLE_3 is not null

union all

select dc.DimCollisionID 
	, isnull(cf4.DimContributingFactorID, -1) DimContributingFactorID
	, getdate()
from Silver.dbo.silver_nyc_crashes c
left join Dim.Collision dc on dc.CollisionID = c.COLLISION_ID
left join Dim.ContributingFactor cf4 on cf4.ContributingFactor = c.CONTRIBUTING_FACTOR_VEHICLE_4
where c.CONTRIBUTING_FACTOR_VEHICLE_4 is not null

union all

select dc.DimCollisionID 
	, isnull(cf5.DimContributingFactorID, -1) DimContributingFactorID
	, getdate()
from Silver.dbo.silver_nyc_crashes c
left join Dim.Collision dc on dc.CollisionID = c.COLLISION_ID
left join Dim.ContributingFactor cf5 on cf5.ContributingFactor = c.CONTRIBUTING_FACTOR_VEHICLE_5
where c.CONTRIBUTING_FACTOR_VEHICLE_5 is not null

END

GO

