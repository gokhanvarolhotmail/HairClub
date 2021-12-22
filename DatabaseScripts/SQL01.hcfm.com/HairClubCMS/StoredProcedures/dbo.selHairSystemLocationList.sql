/***********************************************************************

PROCEDURE:				mtnHairSystemLocationCreate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		10/8/2010

LAST REVISION DATE: 	10/8/2010

--------------------------------------------------------------------------------------------------------
NOTES:  Use this script to grant permissions to stored procedures
		* 10/6/10 PRM - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selHairSystemLocationList 100, 1, 2

***********************************************************************/

CREATE PROCEDURE [dbo].[selHairSystemLocationList]
(
	@CenterID int,
	@CabinetNumber int = NULL,
	@DrawerNumber int = NULL
)
AS
  BEGIN
	IF @CabinetNumber IS NULL AND @DrawerNumber IS NULL
	  BEGIN
		SELECT subLocation.CabinetNumber, NULL AS DrawerNumber, NULL AS BinNumber, NULL AS HairSystemLocationID, (MaxQuantity - ISNULL(ItemCount,0)) AS AvailableCount
		FROM (
				SELECT DISTINCT CabinetNumber
				FROM cfgHairSystemLocation hsl
				WHERE hsl.CenterID = @CenterID
					AND CabinetNumber IS NOT NULL
			) subLocation
			LEFT JOIN (
				SELECT CabinetNumber, COUNT(*) AS ItemCount
				FROM cfgHairSystemLocation hsl
					INNER JOIN datHairSystemOrder hso ON hsl.HairSystemLocationID = hso.HairSystemLocationID
				WHERE hsl.CenterID = @CenterID
				GROUP BY hsl.CabinetNumber
			) subSystems ON subLocation.CabinetNumber = subSystems.CabinetNumber
			LEFT JOIN (
				SELECT CabinetNumber, SUM(ISNULL(MaximumQuantityPerLocation,0)) AS MaxQuantity
				FROM cfgHairSystemLocation hsl
				WHERE hsl.CenterID = @CenterID
				GROUP BY CabinetNumber
			) subMaxCount ON subLocation.CabinetNumber = subMaxCount.CabinetNumber
		ORDER BY subLocation.CabinetNumber
	  END
	ELSE IF @DrawerNumber IS NULL
	  BEGIN
		SELECT subLocation.CabinetNumber, subLocation.DrawerNumber, NULL AS BinNumber, NULL AS HairSystemLocationID, (MaxQuantity - ISNULL(ItemCount,0)) AS AvailableCount
		FROM (
				SELECT DISTINCT CabinetNumber, DrawerNumber
				FROM cfgHairSystemLocation hsl
				WHERE hsl.CenterID = @CenterID
					AND CabinetNumber IS NOT NULL AND DrawerNumber IS NOT NULL
					AND CabinetNumber = @CabinetNumber
			) subLocation
			LEFT JOIN (
				SELECT CabinetNumber, DrawerNumber, COUNT(*) AS ItemCount
				FROM cfgHairSystemLocation hsl
					INNER JOIN datHairSystemOrder hso ON hsl.HairSystemLocationID = hso.HairSystemLocationID
				WHERE hsl.CenterID = @CenterID
				GROUP BY hsl.CabinetNumber, DrawerNumber
			) subSystems ON subLocation.CabinetNumber = subSystems.CabinetNumber AND subLocation.DrawerNumber = subSystems.DrawerNumber
			LEFT JOIN (
				SELECT CabinetNumber, DrawerNumber, SUM(ISNULL(MaximumQuantityPerLocation,0)) AS MaxQuantity
				FROM cfgHairSystemLocation hsl
				WHERE hsl.CenterID = @CenterID
				GROUP BY CabinetNumber, DrawerNumber
			) subMaxCount ON subLocation.CabinetNumber = subMaxCount.CabinetNumber AND subLocation.DrawerNumber = subMaxCount.DrawerNumber
		ORDER BY subLocation.DrawerNumber
	  END
	ELSE
	  BEGIN
		SELECT subLocation.CabinetNumber, subLocation.DrawerNumber, subLocation.BinNumber, subLocation.HairSystemLocationID, (MaxQuantity - ISNULL(ItemCount,0)) AS AvailableCount
		FROM (
				SELECT DISTINCT CabinetNumber, DrawerNumber, BinNumber, HairSystemLocationID
				FROM cfgHairSystemLocation hsl
				WHERE hsl.CenterID = @CenterID
					AND CabinetNumber IS NOT NULL AND DrawerNumber IS NOT NULL
					AND CabinetNumber = @CabinetNumber
					AND DrawerNumber = @DrawerNumber
			) subLocation
			LEFT JOIN (
				SELECT hsl.HairSystemLocationID, COUNT(*) AS ItemCount
				FROM cfgHairSystemLocation hsl
					INNER JOIN datHairSystemOrder hso ON hsl.HairSystemLocationID = hso.HairSystemLocationID
				WHERE hsl.CenterID = @CenterID
				GROUP BY hsl.HairSystemLocationID
			) subSystems ON subLocation.HairSystemLocationID = subSystems.HairSystemLocationID
			LEFT JOIN (
				SELECT hsl.HairSystemLocationID, SUM(ISNULL(MaximumQuantityPerLocation,0)) AS MaxQuantity
				FROM cfgHairSystemLocation hsl
				WHERE hsl.CenterID = @CenterID
				GROUP BY hsl.HairSystemLocationID
			) subMaxCount ON subLocation.HairSystemLocationID = subMaxCount.HairSystemLocationID
		ORDER BY subLocation.DrawerNumber
	  END
  END
