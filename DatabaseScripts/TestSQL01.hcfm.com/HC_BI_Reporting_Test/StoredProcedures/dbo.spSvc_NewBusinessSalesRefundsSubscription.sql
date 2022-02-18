/* CreateDate: 01/03/2020 15:46:00.997 , ModifyDate: 12/19/2021 20:26:23.993 */
GO
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
,	'DLittle@hairclub.com' AS 'CCTo'
,	'New Business Sales Refunds - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	DATEADD(DAY, -6, DATEADD(WEEK, DATEDIFF(WEEK, 0, CAST(GETDATE() AS DATE)), 0)) AS 'StartDate'
,	DATEADD(DAY, -1, DATEADD(WEEK, DATEDIFF(WEEK, 0, CAST(GETDATE() AS DATE)), 0)) AS 'EndDate'
,	0 AS 'Threshold'
,	'C' AS 'CenterType'


END
GO
