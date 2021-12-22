/***********************************************************************
PROCEDURE:				[spSvc_NewBusinessSalesRefundsSubscription]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		01/03/2020
DESCRIPTION:			01/03/2020
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spSvc_NewBusinessSalesRefundsSubscription]
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_NewBusinessSalesRefundsSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT '_CorporateAreaDirectors@hcfm.com' AS 'SendTo'
,	'NKridel@hairclub.com;nbowman@hcfm.com;GDebono@hairclub.com;AAbusfieh@hairclub.com;DLittle@hairclub.com;HMatthews@hairclub.com' AS 'CCTo'
,	'dleiba@hairclub.com;rhut@hairclub.com' AS 'BCCTo'
,	'New Business Sales Refunds - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	DATEADD(DAY, -6, DATEADD(WEEK, DATEDIFF(WEEK, 0, CAST(GETDATE() AS DATE)), 0)) AS 'StartDate'
,	DATEADD(DAY, -1, DATEADD(WEEK, DATEDIFF(WEEK, 0, CAST(GETDATE() AS DATE)), 0)) AS 'EndDate'
,	0 AS 'Threshold'
,	'C' AS 'CenterType'


END
