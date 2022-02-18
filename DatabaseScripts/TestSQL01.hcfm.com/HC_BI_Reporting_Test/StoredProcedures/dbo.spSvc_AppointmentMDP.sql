/* CreateDate: 10/02/2019 12:42:53.470 , ModifyDate: 12/17/2021 17:23:45.180 */
GO
/***********************************************************************
PROCEDURE:				spSvc_AppointmentMDP
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					James Lee
IMPLEMENTOR:			James Lee
DATE IMPLEMENTED:		10/2/2019
DESCRIPTION:			10/2/2019
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_AppointmentMDP
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_AppointmentMDP]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SELECT	'TLewis@hairclub.com;CBrown@hairclub.com;DLira@hairclub.com;SShembri@hairclub.com' AS 'SendTo'
,		'Appointment RestorInk - ' + DATENAME(DW, GETDATE() - 0) + ', ' + CONVERT(VARCHAR, GETDATE() - 0, 101) AS 'Subject'


END
GO
