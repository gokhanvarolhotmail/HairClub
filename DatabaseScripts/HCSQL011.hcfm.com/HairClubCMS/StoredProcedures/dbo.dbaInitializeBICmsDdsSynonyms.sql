/* CreateDate: 10/02/2018 17:29:10.213 , ModifyDate: 10/02/2018 17:29:10.213 */
GO
/*
==============================================================================
PROCEDURE:				dbaInitializeBICmsDdsSynonyms

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		09/15/2015

LAST REVISION DATE: 	09/15/2015

==============================================================================
DESCRIPTION:	Initializes synonyms for the HC_BI_CMS_DDS Database table references.
==============================================================================
NOTES:
		* 02/09/2013 MVT - Created

==============================================================================
SAMPLE EXECUTION:  [dbaInitializeBICmsDdsSynonyms] 0, 1, 0
==============================================================================
*/

CREATE PROCEDURE [dbo].[dbaInitializeBICmsDdsSynonyms]
		@IsLive bit,
		@IsStaging bit,
		@IsDev bit
AS
BEGIN
	SET NOCOUNT ON



	DECLARE @BICmsDdsDB nvarchar(100)

	IF @IsDev = 1 OR @IsStaging = 1
		SET @BICmsDdsDB = 'SQL06.HC_BI_CMS_DDS.bi_cms_dds.'
	ELSE IF @IsLive = 1
		SET @BICmsDdsDB = 'SQL06.HC_BI_CMS_DDS.bi_cms_dds.'

	DECLARE @sqlCommand nvarchar(1000)


	--
	-- Deferred Revenue DimClient table
	--
	IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('BICmsDds_DimClient_TABLE'))
		DROP SYNONYM BICmsDds_DimClient_TABLE;

	SET @sqlCommand = 'CREATE SYNONYM BICmsDds_DimClient_TABLE FOR ' + @BICmsDdsDB + 'DimClient'
	EXEC (@sqlCommand)


END
GO
