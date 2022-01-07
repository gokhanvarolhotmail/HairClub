/****** Object:  StoredProcedure [ODS].[UpdateLeadEmaiPhones]    Script Date: 1/7/2022 4:05:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [ODS].[UpdateLeadEmaiPhones] AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    UPDATE [ODS].[SFDC_Lead]
	SET  [ODS].[SFDC_Lead].email = e.name
	from [ODS].[SFDC_Lead] l
	join [ODS].[SFDC_Email__c] e
	on e.lead__c = l.id
	where l.email is null  and e.name is not null

	UPDATE [ODS].[SFDC_Lead]
	SET  [ODS].[SFDC_Lead].phone = p.name
	from [ODS].[SFDC_Lead] l
	join [ODS].[SFDC_Phone__c] p
	on p.lead__c = l.id
	where l.phone is null and (p.name is not null and p.Type__c = 'Home')

	UPDATE [ODS].[SFDC_Lead]
	SET  [ODS].[SFDC_Lead].mobilephone = p.name
	from [ODS].[SFDC_Lead] l
	join [ODS].[SFDC_Phone__c] p
	on p.lead__c = l.id
	where l.phone is null and (p.name is not null and p.Type__c = 'Cell')

END
GO
