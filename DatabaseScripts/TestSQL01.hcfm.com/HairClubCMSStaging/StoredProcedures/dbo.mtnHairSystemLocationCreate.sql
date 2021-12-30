/* CreateDate: 12/31/2010 13:21:06.687 , ModifyDate: 02/27/2017 09:49:21.387 */
GO
/***********************************************************************

PROCEDURE:				mtnHairSystemLocationCreate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		10/6/2010

LAST REVISION DATE: 	10/6/2010

--------------------------------------------------------------------------------------------------------
NOTES:  Use this script to grant permissions to stored procedures
		* 10/6/10 PRM - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnHairSystemLocationCreate

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnHairSystemLocationCreate]
(
	@CenterID int,
	@CabinetNumber int = NULL,
	@NumberOfDrawers int = 1,
	@NumberOfBins int = 1,
	@NonstandardDescription nvarchar(50) = NULL,
	@MaximumQuantityPerLocation int = NULL
)
AS
  BEGIN

	IF (@NonstandardDescription IS NOT NULL)
	  BEGIN
		INSERT INTO cfgHairSystemLocation (CenterID, NonstandardDescription, CabinetNumber, DrawerNumber, BinNumber, MaximumQuantityPerLocation, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
			(@CenterID, @NonstandardDescription, NULL, NULL, NULL, @MaximumQuantityPerLocation, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa')
	  END
	ELSE
	  BEGIN
		DECLARE @DrawerCnt int = 1
		DECLARE @BinCnt int = 1

		WHILE @DrawerCnt <= @NumberOfDrawers
		  BEGIN
			WHILE @BinCnt <= @NumberOfBins
			  BEGIN
				INSERT INTO cfgHairSystemLocation (CenterID, NonstandardDescription, CabinetNumber, DrawerNumber, BinNumber, MaximumQuantityPerLocation, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
					(@CenterID, NULL, @CabinetNumber, @DrawerCnt, @BinCnt, @MaximumQuantityPerLocation, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa')
				SET @BinCnt = @BinCnt + 1
			  END
			SET @BinCnt = 1
			SET @DrawerCnt = @DrawerCnt + 1
		  END
	  END
  END
GO
