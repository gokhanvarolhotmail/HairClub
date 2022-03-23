/* CreateDate: 03/17/2022 15:12:15.510 , ModifyDate: 03/17/2022 15:12:15.510 */
GO
CREATE PROCEDURE [SF].[sp_Commissions_Log__c_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[Commissions_Log__c])
RETURN ;

BEGIN TRY
;MERGE [SF].[Commissions_Log__c] AS [t]
USING [SFStaging].[Commissions_Log__c] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[IsDeleted] = [t].[IsDeleted]
	, [t].[Name] = [t].[Name]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[LastActivityDate] = [t].[LastActivityDate]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[Service_Appointment__c] = [t].[Service_Appointment__c]
	, [t].[ACE_Approved__c] = [t].[ACE_Approved__c]
	, [t].[Comments__c] = [t].[Comments__c]
	, [t].[Commission_To_Proposed_Change__c] = [t].[Commission_To_Proposed_Change__c]
	, [t].[Commission_To__c] = [t].[Commission_To__c]
	, [t].[Commissions_Logic_Details__c] = [t].[Commissions_Logic_Details__c]
	, [t].[My_Commission_Log__c] = [t].[My_Commission_Log__c]
	, [t].[Related_Lead__c] = [t].[Related_Lead__c]
	, [t].[Related_Person_Account__c] = [t].[Related_Person_Account__c]
	, [t].[System_Generated__c] = [t].[System_Generated__c]
	, [t].[Commission_To_Manager__c] = [t].[Commission_To_Manager__c]
	, [t].[Commission_To_Company__c] = [t].[Commission_To_Company__c]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [IsDeleted]
	, [Name]
	, [CurrencyIsoCode]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [LastActivityDate]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [Service_Appointment__c]
	, [ACE_Approved__c]
	, [Comments__c]
	, [Commission_To_Proposed_Change__c]
	, [Commission_To__c]
	, [Commissions_Logic_Details__c]
	, [My_Commission_Log__c]
	, [Related_Lead__c]
	, [Related_Person_Account__c]
	, [System_Generated__c]
	, [Commission_To_Manager__c]
	, [Commission_To_Company__c]
	)
	VALUES(
	[s].[Id]
	, [s].[IsDeleted]
	, [s].[Name]
	, [s].[CurrencyIsoCode]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[LastActivityDate]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[Service_Appointment__c]
	, [s].[ACE_Approved__c]
	, [s].[Comments__c]
	, [s].[Commission_To_Proposed_Change__c]
	, [s].[Commission_To__c]
	, [s].[Commissions_Logic_Details__c]
	, [s].[My_Commission_Log__c]
	, [s].[Related_Lead__c]
	, [s].[Related_Person_Account__c]
	, [s].[System_Generated__c]
	, [s].[Commission_To_Manager__c]
	, [s].[Commission_To_Company__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[Commissions_Log__c] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
