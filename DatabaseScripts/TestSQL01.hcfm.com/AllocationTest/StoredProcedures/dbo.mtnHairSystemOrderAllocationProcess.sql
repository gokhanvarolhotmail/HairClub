/* CreateDate: 10/31/2019 21:09:58.657 , ModifyDate: 01/06/2020 09:13:01.357 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				mtnHairSystemOrderAllocationProcess

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 2/10/2010

LAST REVISION DATE: 	 2/10/2010

==============================================================================
DESCRIPTION:	Allocation Process:
					Executes each of the individual stored procs for allocating
					hair systems to factories
==============================================================================
NOTES:
		* 2/10/10 PRM - Created stored proc
		* 11/16/10 PRM - Return AllocationGUID at the end of Allocation for reports
		* 10/28/11 MVT - Wrapped a transaction around the allocation process
		* 01/11/13 MVT - Moved the Process to kick off the SSIS job inside the Try
						so that it only runs if all procs are successfull.
		* 03/18/14 MLM - Allocation will be done by Default Factory then Cost.
						 No Longer will Allocation by Previous Factory or Percentage.
		* 02/17/15 SAL - Do not run the SSIS Job if the server is HCTESTSQL (ie; Staging or Dev)
		* 02/19/18 SAL - Add call to stored proc that will process Hans Wiemann HSOs (TFS#9663)
==============================================================================
SAMPLE EXECUTION:
EXEC mtnHairSystemOrderAllocationProcess
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnHairSystemOrderAllocationProcess] AS
BEGIN
	DECLARE @HairSystemAllocationGUID uniqueidentifier
	DECLARE @User nvarchar(50)
	DECLARE @FilterID int
	DECLARE @EndDate datetime
	DECLARE @HairSystemStatus_Ready nvarchar(10)

	SET @HairSystemAllocationGUID = NEWID()
	SET @User = 'Allocation Process'
	SET @EndDate = DATEADD(DAY, 1, CONVERT(VARCHAR(10), GETUTCDATE(), 101))
	SET @HairSystemStatus_Ready = 'READY'

	DECLARE hsaCursor CURSOR FAST_FORWARD FOR
		SELECT DISTINCT
			[HairSystemAllocationGUID],
			[HairSystemAllocationDate]
		FROM
			dba.HairSystemOrdersToProcess
		ORDER BY
			[HairSystemAllocationDate];

	OPEN hsaCursor
	FETCH NEXT FROM hsaCursor INTO @HairSystemAllocationGUID, @EndDate

	WHILE @@FETCH_STATUS = 0
	BEGIN

	SET @EndDate = CAST(DATEADD(DAY, 1, @EndDate) AS date);

	UPDATE
		hso
	SET
		hso.HairSystemOrderStatusId = 7
	FROM
		datHairSystemOrder hso
	INNER JOIN
		dba.HairSystemOrdersToProcess hsotp ON hsotp.HairSystemOrderGUID = hso.HairSystemOrderGUID AND hsotp.HairSystemOrderNumber = hso.HairSystemOrderNumber
	WHERE
		hsotp.HairSystemAllocationGUID = @HairSystemAllocationGUID;

BEGIN TRANSACTION

	BEGIN TRY
		-- Hans Wiemann Orders will be processed first so that the rest of allocation bypasses them
		SELECT @FilterID = HairSystemAllocationFilterID FROM lkpHairSystemAllocationFilter WHERE HairSystemAllocationFilterDescriptionShort = 'FILTER3'
		EXEC mtnHairSystemOrderAllocationForHansWiemann @User, @FilterID, @EndDate

		EXEC mtnHairSystemOrderAllocationBegin @HairSystemAllocationGUID, @User, @EndDate

		-- Repair Orders will always go to the previous Factory
		SELECT @FilterID = HairSystemAllocationFilterID FROM lkpHairSystemAllocationFilter WHERE HairSystemAllocationFilterDescriptionShort = 'FILTER2'
		EXEC mtnHairSystemOrderAllocationByPreviousOrder @HairSystemAllocationGUID, @User, @FilterID, @EndDate, @HairSystemStatus_Ready

		SELECT @FilterID = HairSystemAllocationFilterID FROM lkpHairSystemAllocationFilter WHERE HairSystemAllocationFilterDescriptionShort = 'FILTER3'
		EXEC mtnHairSystemOrderAllocationByDefaultFactory @HairSystemAllocationGUID, @User, @FilterID, @EndDate, @HairSystemStatus_Ready

		------SELECT @FilterID = HairSystemAllocationFilterID FROM lkpHairSystemAllocationFilter WHERE HairSystemAllocationFilterDescriptionShort = 'FILTER4'
		------EXEC mtnHairSystemOrderAllocationByPercentage @HairSystemAllocationGUID, @User, @FilterID, @EndDate, @HairSystemStatus_Ready

		SELECT @FilterID = HairSystemAllocationFilterID FROM lkpHairSystemAllocationFilter WHERE HairSystemAllocationFilterDescriptionShort = 'FILTER5'
		EXEC mtnHairSystemOrderAllocationByCost @HairSystemAllocationGUID, @User, @FilterID, @EndDate, @HairSystemStatus_Ready

		EXEC mtnHairSystemOrderAllocationPricing @HairSystemAllocationGUID, @User, @HairSystemStatus_Ready

		EXEC mtnHairSystemOrderAllocationComplete @HairSystemAllocationGUID, @User

		COMMIT TRANSACTION;

		---- Start the SSIS package to export PO's
		--DECLARE @serverName varchar(50)
		--SET @serverName = (CAST (SERVERPROPERTY ( 'ComputerNamePhysicalNetBIOS') as varchar(50)) )
		----IF (@serverName LIKE 'HCTESTSQL%' OR @serverName LIKE 'SQL01' OR @serverName LIKE 'HCSQL%')
		--IF (@serverName LIKE 'SQL01' OR @serverName LIKE 'HCSQL%')
		--BEGIN
		--	EXEC msdb.dbo.SP_Start_job 'ExportByHPONumberAndFactoryJob'
		--END

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;

		DECLARE @message nvarchar(500), @ErrorNumber int, @ErrorSeverity int, @ErrorState int, @ErrorProcedure nvarchar(126), @ErrorLine int, @ErrorMessage nvarchar(2048)

		SELECT
			@ErrorNumber = ERROR_NUMBER()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE()
			,@ErrorProcedure = ERROR_PROCEDURE()
			,@ErrorLine = ERROR_LINE()
			,@ErrorMessage = ERROR_MESSAGE()

		SET @message = 'Error occured during allocation.  Error Number: '
						+ Convert(nvarchar(20), @ErrorNumber)
						+ ' Error Message: '
						+ @ErrorMessage
						+ ' Error Procedure: '
						+ @ErrorProcedure
						+ ' Error Line: '
						+ Convert(nvarchar(20),@ErrorLine)

		RAISERROR(@message, @ErrorSeverity, @ErrorState)

	END CATCH

	--return the allocation guid so reports can be run after allocation
	SELECT @HairSystemAllocationGUID AS HairSystemAllocationGUID


	FETCH NEXT FROM hsaCursor INTO @HairSystemAllocationGUID, @EndDate
	END

	CLOSE hsaCursor
	DEALLOCATE hsaCursor



END
GO
