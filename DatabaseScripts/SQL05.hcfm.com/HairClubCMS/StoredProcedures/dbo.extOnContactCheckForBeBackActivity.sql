/* CreateDate: 12/11/2012 14:57:18.533 , ModifyDate: 12/11/2012 14:57:18.533 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactCheckForBeBackActivity

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_CheckForBeBackActivity

==============================================================================
SAMPLE EXECUTION:
EXEC spApp_TREConsultations_CheckForBeBackActivity
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactCheckForBeBackActivity]
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #BeBack
	  (
		RowID int IDENTITY(1, 1)
	  , TREBebackExportID int
	  , ContactID varchar(10)
	  , CenterID varchar(20)
	  , Performer varchar(50)
	  , ResultCode varchar(50)
	  )

	/* Get New BeBack Records */
	INSERT  intO #BeBack (TREBebackExportID, ContactID, CenterID, Performer, ResultCode)
		SELECT TREBebackExportID, ContactID, CenterID, Performer, ResultCode
		FROM mtnTREBebackExport
		WHERE IsProcessedFlag = 0

	DECLARE @LoopCount int
	DECLARE @BeBackCount int

	SET @LoopCount = 1
	SET @BeBackCount = ( SELECT COUNT(*) FROM #BeBack )

	DECLARE @TREBebackExportID int
	DECLARE @ContactID varchar(10)
	DECLARE @CenterID varchar(20)
	DECLARE @Performer varchar(50)
	DECLARE @ResultCode varchar(50)

	WHILE @LoopCount <= @BeBackCount
	  BEGIN

	  SET @TREBebackExportID = (SELECT TREBebackExportID FROM #BeBack WHERE RowID = @LoopCount)
	  SET @ContactID = (SELECT ContactID FROM #BeBack WHERE RowID = @LoopCount)
	  SET @CenterID = (SELECT CenterID FROM #BeBack WHERE RowID = @LoopCount)
	  SET @Performer = (SELECT Performer FROM #BeBack WHERE RowID = @LoopCount)
	  SET @ResultCode = (SELECT ResultCode FROM #BeBack WHERE RowID = @LoopCount)

		/* Create BEBACK Activity */
		EXEC HCBOS..spApp_TREConsultations_CreateBeBackActivity @ContactID, @CenterID, @Performer, @ResultCode

		/* Check if BEBACK creation was successful, If yes then Update SQL01.HairclubCMS.dbo.mtnTREBebackExport table */
		IF EXISTS ( SELECT contact_id FROM HCMSkylineTest..oncd_contact WHERE contact_id = @ContactID AND surgery_consultation_flag = 'N' )
		  BEGIN
			UPDATE mtnTREBebackExport
			SET IsProcessedFlag = 1,
				ProcessedDate = GETDATE()
			WHERE TREBebackExportID = @TREBebackExportID
		  END

		SET @LoopCount = @LoopCount + 1

	  END
END
GO
