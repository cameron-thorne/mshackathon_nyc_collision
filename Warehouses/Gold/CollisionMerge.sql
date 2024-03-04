SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [Dim].[CollisionMerge]

AS
BEGIN

--Lets just do type 1 for this project

--I had problems with primary keys so I am just going to do a ROW_NUMBER cheat
DECLARE @MaxDimCollisionID INT 
SELECT @MaxDimCollisionID = (SELECT MAX(DimCollisionID) FROM Gold.Dim.Collision)

--Cant do merge sadface
--Update

UPDATE dimcl
SET dimcl.CollisionID = ISNULL(crashes.COLLISION_ID, '')
FROM Silver.dbo.silver_nyc_crashes AS crashes
INNER JOIN Gold.Dim.Collision AS dimcl ON dimcl.CollisionID = ISNULL(crashes.COLLISION_ID, '') 


DECLARE @NegativeOneBit INT 
SET @NegativeOneBit = (SELECT CASE WHEN ISNULL((SELECT COUNT(*) FROM Gold.Dim.Collision), 0) > 0 THEN 1 ELSE 0 END)

IF @NegativeOneBit = 0

BEGIN 

INSERT INTO Gold.Dim.Collision
(
DimCollisionID ,
CollisionID ,
CreateTmsp
)
VALUES 
(
-1 ,
'' ,
GETDATE()
)

END

--Insert

INSERT INTO Gold.Dim.Collision
(
DimCollisionID,
CollisionID ,
CreateTmsp
)
SELECT 
ROW_NUMBER() OVER (ORDER BY t.CollisionID) + ISNULL(@MaxDimCollisionID, 0) DimCollisionID,
CollisionID ,
CreateTmsp
FROM
(
SELECT 
DISTINCT
ISNULL(crashes.COLLISION_ID, '') AS CollisionID ,
GETDATE() CreateTmsp
FROM Silver.dbo.silver_nyc_crashes AS crashes
LEFT JOIN Gold.Dim.Collision AS dimcl ON dimcl.CollisionID = ISNULL(crashes.COLLISION_ID, '') 
WHERE dimcl.DimCollisionID IS NULL
) t

END




GO

