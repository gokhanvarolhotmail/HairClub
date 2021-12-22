/* CreateDate: 09/28/2009 16:53:04.460 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CheckForBeBackActivity
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Marlon Burrell
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			9/28/2009
-- Date Implemented:		9/28/2009
-- Date Last Modified:		9/28/2009
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	BOS
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_CheckForBeBackActivity
================================================================================================*/
CREATE PROCEDURE spApp_TREConsultations_CheckForBeBackActivity
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE [#BeBack]
	  (
		[RowID] INT IDENTITY(1, 1)
	  , [TREBebackExportID] INT
	  , [ContactID] VARCHAR(10)
	  , [CenterID] VARCHAR(20)
	  , [Performer] VARCHAR(50)
	  , [ResultCode] VARCHAR(50)
	  )

	/* Get New BeBack Records */
	INSERT  INTO [#BeBack]
			(
			  [TREBebackExportID]
			, [ContactID]
			, [CenterID]
			, [Performer]
			, [ResultCode]
			)
			SELECT  [TREBebackExportID]
			,       [ContactID]
			,       [CenterID]
			,       [Performer]
			,       [ResultCode]
			FROM    [SQL01].[HairclubCMS].[dbo].[mtnTREBebackExport]
			WHERE   [IsProcessedFlag] = 0

	DECLARE @LoopCount INT
	DECLARE @BeBackCount INT

	SET @LoopCount = 1
	SET @BeBackCount = ( SELECT COUNT(*) FROM [#BeBack] )

	DECLARE @TREBebackExportID INT
	DECLARE @ContactID VARCHAR(10)
	DECLARE @CenterID VARCHAR(20)
	DECLARE @Performer VARCHAR(50)
	DECLARE @ResultCode VARCHAR(50)

	WHILE @LoopCount <= @BeBackCount
	  BEGIN

	  SET @TREBebackExportID = (SELECT [TREBebackExportID] FROM [#BeBack] WHERE [RowID] = @LoopCount)
	  SET @ContactID = (SELECT [ContactID] FROM [#BeBack] WHERE [RowID] = @LoopCount)
	  SET @CenterID = (SELECT [CenterID] FROM [#BeBack] WHERE [RowID] = @LoopCount)
	  SET @Performer = (SELECT [Performer] FROM [#BeBack] WHERE [RowID] = @LoopCount)
	  SET @ResultCode = (SELECT [ResultCode] FROM [#BeBack] WHERE [RowID] = @LoopCount)

		/* Create BEBACK Activity */
		EXEC [spApp_TREConsultations_CreateBeBackActivity] @ContactID, @CenterID, @Performer, @ResultCode

		/* Check if BEBACK creation was successful, If yes then Update [SQL01].[HairclubCMS].[dbo].[mtnTREBebackExport] table */
		IF EXISTS ( SELECT  [contact_id]
					FROM    [HCM].[dbo].[oncd_contact]
					WHERE   [contact_id] = @ContactID
							AND [surgery_consultation_flag] = 'N' )
		  BEGIN
			UPDATE  [SQL01].[HairclubCMS].[dbo].[mtnTREBebackExport]
			SET     [IsProcessedFlag] = 1
			,		[ProcessedDate] = GETDATE()
			WHERE   [TREBebackExportID] = @TREBebackExportID
		  END

		SET @LoopCount = @LoopCount + 1

	  END
END
GO
