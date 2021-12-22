/* CreateDate: 07/15/2021 08:05:07.450 , ModifyDate: 12/18/2021 17:26:43.923 */
GO
/***********************************************************************
PROCEDURE:				spSvc_DailyFlashCorporateSubscription
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/31/2021
DESCRIPTION:			3/31/2021
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_DailyFlashCorporateSubscriptionByTeamInt
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_DailyFlashCorporateSubscriptionByTeamInt]
AS
BEGIN

    SET FMTONLY OFF;
    SET NOCOUNT ON;


    SELECT '_DeptManagementCommittee@hairclub.com;_CorporateRegionalDirectors@hairclub.com;_DailyFlashCorporate@hairclub.com;hiroki.itakura@aderans.com;mutsuo.minowa@aderans.com;yosuke.ikunaga@aderans.com;masaaki.furukawa@aderans.com;slong@callinsite.com;jphillips@callinsite.com;CEscobar@hairclub.com;OArias@hairclub.com;BOlivierJacquecin@hairclub.com;SDorelien@hairclub.com;Relder@hairclub.com;asalazar@hairclub.com' AS 'SendTo'

         , 'brensing@hairclub.com;cczencz@hairclub.com'                                                                                  AS 'CopyTo'
         , 'Daily Flash - All Corporate - ' + DATENAME(DW, GETDATE() - 1) + ', ' +
           CONVERT(VARCHAR, GETDATE() - 1, 101)                                                                                                                                                                                                                                     AS 'Subject'
         , 'C'                                                                                                                                                                                                                                                                      AS 'CenterType'

END
GO
