/* CreateDate: 12/03/2021 10:25:05.920 , ModifyDate: 12/03/2021 10:25:05.920 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				dbaInitializeHC_BI_SFDCSynonyms

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Jeremy Miller

IMPLEMENTOR: 			Jeremy Miller

DATE IMPLEMENTED: 		09/05/2019

LAST REVISION DATE: 	09/05/2019

==============================================================================
DESCRIPTION:	Initializes synonyms for the HC_BI_SFDC Database table references.
==============================================================================
NOTES:
		* 09/05/2019 JLM - Created. Based on dbaInitializedOnContactSynonyms (TFS #12903)

==============================================================================
SAMPLE EXECUTION: EXEC [dbaInitializeHC_BI_SFDCSynonyms] 0,1, 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[dbaInitializeHC_BI_SFDCSynonyms]
    @IsLive bit,
    @IsStaging bit,
    @IsDev bit
AS

BEGIN
    SET NOCOUNT ON

	DECLARE @HC_BI_SFDC_DB nvarchar(100)

	IF @IsDev = 1 OR @IsStaging = 1
		SET @HC_BI_SFDC_DB = '[SQL05].HC_BI_SFDC.dbo.'  -- (DevSky)
	ELSE IF @IsLive = 1
		SET @HC_BI_SFDC_DB = '[SQL05].HC_BI_SFDC.dbo.'  -- (Live)


    DECLARE @sqlCommand nvarchar(1000)

    IF EXISTS(SELECT * FROM sys.objects WHERE object_id = object_id('HC_BI_SFDC_extHairClubCMSGetSourceList_PROC'))
		DROP SYNONYM HC_BI_SFDC_extHairClubCMSGetSourceList_PROC;

    SET @sqlCommand = 'CREATE SYNONYM HC_BI_SFDC_extHairClubCMSGetSourceList_PROC FOR ' + @HC_BI_SFDC_DB + 'extHairClubCMSGetSourceList'
	EXEC (@sqlCommand)
END
GO
