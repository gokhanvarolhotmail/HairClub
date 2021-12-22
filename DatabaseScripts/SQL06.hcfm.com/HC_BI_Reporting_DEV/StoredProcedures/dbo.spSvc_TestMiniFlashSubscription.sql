/***********************************************************************
PROCEDURE:				spSvc_TestMiniFlashSubscription
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		12/30/2019
DESCRIPTION:			12/30/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_TestMiniFlashSubscription
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_TestMiniFlashSubscription]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT	'rhut@hairclub.com' AS 'SendTo'
,		'Test Mini Flash - ' + DATENAME(DW, GETDATE() -1) + ', ' + CONVERT(VARCHAR, GETDATE() -1, 101) AS 'Subject'
,		'rhut@hairclub.com' AS 'CC'


END
