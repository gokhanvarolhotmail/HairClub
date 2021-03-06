/* CreateDate: 10/02/2018 17:29:10.273 , ModifyDate: 04/28/2020 16:27:36.677 */
GO
/*
==============================================================================
PROCEDURE:				dbaInitializeDeferredRevenueSynonyms

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		09/15/2015

LAST REVISION DATE: 	09/15/2015

==============================================================================
DESCRIPTION:	Initializes synonyms for the Deferred Revenue Database table references.
==============================================================================
NOTES:
		* 02/09/2013 MVT - Created
		* 04/01/2016 MVT - Updated to point to HCTestSQL05 for staging and
							to HCTestCMS for Dev.
		* 04/21/2020 MVT - Modified to use the new DAILY deferred DB on SQL06 and
							added a synonym for daily deferred Proc.
==============================================================================
SAMPLE EXECUTION:  [dbaInitializeDeferredRevenueSynonyms] 0, 1, 0
==============================================================================
*/

CREATE PROCEDURE [dbo].[dbaInitializeDeferredRevenueSynonyms]
		@IsLive bit,
		@IsStaging bit,
		@IsDev bit
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @DeferredRevenueDB nvarchar(100)

	IF @IsDev = 1 OR @IsStaging = 1
		SET @DeferredRevenueDB = 'HC_DeferredRevenue_DAILY.dbo.'
	ELSE IF @IsLive = 1
		SET @DeferredRevenueDB = 'SQL06.HC_DeferredRevenue_DAILY.dbo.'

	DECLARE @sqlCommand nvarchar(1000)


	--
	-- Deferred Revenue FactDeferredRevenueHeader table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('DeferredRevenue_FactDeferredRevenueHeader_TABLE'))
		DROP SYNONYM DeferredRevenue_FactDeferredRevenueHeader_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM DeferredRevenue_FactDeferredRevenueHeader_TABLE FOR ' + @DeferredRevenueDB + 'FactDeferredRevenueHeader'
	EXEC (@sqlCommand)

	--
	-- Deferred Revenue FactDeferredRevenueDetails table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('DeferredRevenue_FactDeferredRevenueDetails_TABLE'))
		DROP SYNONYM DeferredRevenue_FactDeferredRevenueDetails_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM DeferredRevenue_FactDeferredRevenueDetails_TABLE FOR ' + @DeferredRevenueDB + 'FactDeferredRevenueDetails'
	EXEC (@sqlCommand)


	--
	-- Deferred Revenue extHairClubCMSGetDeferredBalanceByClient proc
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('DeferredRevenue_extHairClubCMSGetDeferredBalanceByClient_PROC'))
		DROP SYNONYM DeferredRevenue_extHairClubCMSGetDeferredBalanceByClient_PROC;

	SET @sqlCommand = 'CREATE SYNONYM DeferredRevenue_extHairClubCMSGetDeferredBalanceByClient_PROC FOR ' + @DeferredRevenueDB + 'extHairClubCMSGetDeferredBalanceByClient'
	EXEC (@sqlCommand)

END
GO
