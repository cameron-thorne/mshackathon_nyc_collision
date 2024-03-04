SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Dim].[ContributingFactorMerge]

AS
BEGIN

--Lets just do type 1 for this project

--I had problems with primary keys so I am just going to do a ROW_NUMBER cheat
DECLARE @MaxDimContributingFactorID INT 
SET @MaxDimContributingFactorID = (SELECT MAX(DimContributingFactorID) FROM Gold.Dim.ContributingFactor)

DECLARE @NegativeOneBit INT 
SET @NegativeOneBit = (SELECT CASE WHEN ISNULL((SELECT COUNT(*) FROM Gold.Dim.ContributingFactor), 0) > 0 THEN 1 ELSE 0 END)

IF @NegativeOneBit = 0

BEGIN 

INSERT INTO Gold.Dim.ContributingFactor
(
DimContributingFactorID,
ContributingFactor,
CreateTmsp
)
VALUES 
(
-1,
'' ,
GETDATE()
)

END

--Insert

INSERT INTO Gold.Dim.ContributingFactor
(
DimContributingFactorID,
ContributingFactor,
CreateTmsp
)
SELECT 
ROW_NUMBER() OVER (ORDER BY ContributingFactor) + ISNULL(@MaxDimContributingFactorID, 0) DimVehicleID,
ContributingFactor,
GETDATE() CreateTmsp 
FROM 
(
SELECT DISTINCT ContributingFactor FROM 
(
SELECT 
ISNULL(crashes.[CONTRIBUTING_FACTOR_VEHICLE_1], '') ContributingFactor
--SELECT TOP 1000 *
FROM Silver.dbo.silver_nyc_crashes AS crashes
LEFT JOIN Gold.Dim.ContributingFactor AS dimcf1 ON ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_1, '') = dimcf1.ContributingFactor
WHERE ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_1, '') <> ''
AND dimcf1.ContributingFactor IS NULL
UNION
SELECT 
ISNULL(crashes.[CONTRIBUTING_FACTOR_VEHICLE_2], '') ContributingFactor
--SELECT TOP 1000 *
FROM Silver.dbo.silver_nyc_crashes AS crashes
LEFT JOIN Gold.Dim.ContributingFactor AS dimcf2 ON ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_2, '') = dimcf2.ContributingFactor
WHERE ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_2, '') <> ''
AND dimcf2.ContributingFactor IS NULL
UNION
SELECT 
ISNULL(crashes.[CONTRIBUTING_FACTOR_VEHICLE_3], '') ContributingFactor
--SELECT TOP 1000 *
FROM Silver.dbo.silver_nyc_crashes AS crashes
LEFT JOIN Gold.Dim.ContributingFactor AS dimcf3 ON ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_3, '') = dimcf3.ContributingFactor
WHERE ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_3, '') <> ''
AND dimcf3.ContributingFactor IS NULL
UNION
SELECT 
ISNULL(crashes.[CONTRIBUTING_FACTOR_VEHICLE_4], '') ContributingFactor
--SELECT TOP 1000 *
FROM Silver.dbo.silver_nyc_crashes AS crashes
LEFT JOIN Gold.Dim.ContributingFactor AS dimcf4 ON ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_4, '') = dimcf4.ContributingFactor
WHERE ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_4, '') <> ''
AND dimcf4.ContributingFactor IS NULL
UNION
SELECT 
ISNULL(crashes.[CONTRIBUTING_FACTOR_VEHICLE_5], '') ContributingFactor
--SELECT TOP 1000 *
FROM Silver.dbo.silver_nyc_crashes AS crashes
LEFT JOIN Gold.Dim.ContributingFactor AS dimcf5 ON ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_5, '') = dimcf5.ContributingFactor
WHERE ISNULL(crashes.CONTRIBUTING_FACTOR_VEHICLE_5, '') <> ''
AND dimcf5.ContributingFactor IS NULL
) t
) y

END



GO

