/* CreateDate: 12/22/2020 10:07:06.867 , ModifyDate: 12/22/2020 10:17:03.200 */
GO
CREATE FUNCTION fnGetAccomodationfromTask(@SFDC_LeadID nvarchar)
RETURNS TABLE
AS
RETURN
(
SELECT whoid, Accommodation__c FROM dbo.Task
WHERE whoid = @SFDC_LeadID
--ORDER BY task.[ActivityDate] asc
)
GO
