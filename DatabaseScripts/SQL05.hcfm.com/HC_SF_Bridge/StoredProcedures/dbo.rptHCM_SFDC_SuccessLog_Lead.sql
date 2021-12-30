/* CreateDate: 10/30/2017 13:48:56.310 , ModifyDate: 11/20/2017 10:53:46.867 */
GO
/*===========================================================================
 Author:		Rachelen Hut
 Create date:	10/30/2017
 Description:	Shows counts from HCM_SFDC_SuccessLog_Lead and other tables

EXEC [dbo].[rptHCM_SFDC_SuccessLog_Lead]
============================================================================*/

CREATE PROCEDURE [dbo].[rptHCM_SFDC_SuccessLog_Lead]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;


DECLARE @YesterdayStartDate DATETIME
DECLARE @YesterdayEndDate DATETIME
SET @YesterdayStartDate = DATEADD(day,DATEDIFF(day,0,GETDATE()-1),0)				--Yesterday at 12:00AM
SET @YesterdayEndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()),0) ))				--Yesterday at 11:59PM

CREATE TABLE #SuccessLeads(Tablename NVARCHAR(150)
,	LeadCount INT
 )

INSERT INTO #SuccessLeads
        (Tablename ,LeadCount)
SELECT 'HCM_SFDC_SuccessLog_Lead' AS Tablename
, COUNT(*) AS 'LeadCount'
FROM [dbo].[HCM_SFDC_SuccessLog_Lead]
WHERE create_date BETWEEN  CAST(@YesterdayStartDate AS VARCHAR(102)) AND CAST(@YesterdayEndDate AS VARCHAR(102))


INSERT INTO #SuccessLeads
        (Tablename ,LeadCount)
SELECT 'HCM_SFDC_SuccessLog_LeadTask' AS Tablename
, COUNT(*) AS 'LeadCount'
FROM [dbo].[HCM_SFDC_SuccessLog_LeadTask]
WHERE create_date BETWEEN  CAST(@YesterdayStartDate AS VARCHAR(102)) AND CAST(@YesterdayEndDate AS VARCHAR(102))


INSERT INTO #SuccessLeads
        (Tablename ,LeadCount)
SELECT 'HCM_SFDC_ErrorLog_Lead' AS Tablename
, COUNT(*) AS 'LeadCount'
FROM [dbo].[HCM_SFDC_ErrorLog_Lead]
WHERE create_date BETWEEN  CAST(@YesterdayStartDate AS VARCHAR(102)) AND CAST(@YesterdayEndDate AS VARCHAR(102))


INSERT INTO #SuccessLeads
        (Tablename ,LeadCount)
SELECT 'HCM_SFDC_ErrorLog_LeadTask' AS Tablename
, COUNT(*) AS 'LeadCount'
FROM [dbo].[HCM_SFDC_ErrorLog_LeadTask]
WHERE updated_date BETWEEN  CAST(@YesterdayStartDate AS VARCHAR(102)) AND CAST(@YesterdayEndDate AS VARCHAR(102))


--Now, get the SFDC to HCM bridge tables

INSERT INTO #SuccessLeads
        (Tablename ,LeadCount)
SELECT 'SFDC_HCM_Lead' AS Tablename
, COUNT(*) AS 'LeadCount'
FROM [HC_SF_Bridge].[dbo].[SFDC_HCM_Lead] AS shl
WHERE (shl.CreateDate BETWEEN  CAST(@YesterdayStartDate AS VARCHAR(102)) AND CAST(@YesterdayEndDate AS VARCHAR(102)))
		--OR sfdc_updated_date BETWEEN CAST(@StartDate AS VARCHAR(102)) AND CAST(@EndDate AS VARCHAR(102)))


INSERT INTO #SuccessLeads
        (Tablename ,LeadCount)
SELECT 'SFDC_HCM_LeadAddress' AS Tablename
, COUNT(*) AS 'LeadCount'
FROM [HC_SF_Bridge].[dbo].[SFDC_HCM_LeadAddress]
WHERE (CreateDate BETWEEN  CAST(@YesterdayStartDate AS VARCHAR(102)) AND CAST(@YesterdayEndDate AS VARCHAR(102)))
		--OR sfdc_updated_date BETWEEN CAST(@StartDate AS VARCHAR(102)) AND CAST(@EndDate AS VARCHAR(102)))


INSERT INTO #SuccessLeads
        (Tablename ,LeadCount)
SELECT 'SFDC_HCM_LeadEmail' AS Tablename
, COUNT(*) AS 'LeadCount'
FROM [HC_SF_Bridge].[dbo].[SFDC_HCM_LeadEmail]
WHERE (CreateDate BETWEEN  CAST(@YesterdayStartDate AS VARCHAR(102)) AND CAST(@YesterdayEndDate AS VARCHAR(102)))
		--OR sfdc_updated_date BETWEEN CAST(@StartDate AS VARCHAR(102)) AND CAST(@EndDate AS VARCHAR(102)))

INSERT INTO #SuccessLeads
        (Tablename ,LeadCount)
SELECT 'SFDC_HCM_LeadPhone' AS Tablename
, COUNT(*) AS 'LeadCount'
FROM [HC_SF_Bridge].[dbo].[SFDC_HCM_LeadPhone]
WHERE (CreateDate BETWEEN  CAST(@YesterdayStartDate AS VARCHAR(102)) AND CAST(@YesterdayEndDate AS VARCHAR(102)))
		--OR sfdc_updated_date BETWEEN CAST(@StartDate AS VARCHAR(102)) AND CAST(@EndDate AS VARCHAR(102)))


INSERT INTO #SuccessLeads
        (Tablename ,LeadCount)
SELECT 'SFDC_HCM_LeadTask' AS Tablename
, COUNT(*) AS 'LeadCount'
FROM [HC_SF_Bridge].[dbo].[SFDC_HCM_LeadTask]
WHERE (CreateDate BETWEEN  CAST(@YesterdayStartDate AS VARCHAR(102)) AND CAST(@YesterdayEndDate AS VARCHAR(102)))
		--OR sfdc_updated_date BETWEEN CAST(@StartDate AS VARCHAR(102)) AND CAST(@EndDate AS VARCHAR(102)))


SELECT * FROM #SuccessLeads

END
GO
