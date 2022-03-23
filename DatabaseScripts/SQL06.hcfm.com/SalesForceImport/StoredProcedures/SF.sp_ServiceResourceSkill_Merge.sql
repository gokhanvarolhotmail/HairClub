/* CreateDate: 03/17/2022 15:12:16.400 , ModifyDate: 03/17/2022 15:12:16.400 */
GO
CREATE PROCEDURE [SF].[sp_ServiceResourceSkill_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[ServiceResourceSkill])
RETURN ;

BEGIN TRY
;MERGE [SF].[ServiceResourceSkill] AS [t]
USING [SFStaging].[ServiceResourceSkill] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[IsDeleted] = [t].[IsDeleted]
	, [t].[SkillNumber] = [t].[SkillNumber]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[ServiceResourceId] = [t].[ServiceResourceId]
	, [t].[SkillId] = [t].[SkillId]
	, [t].[SkillLevel] = [t].[SkillLevel]
	, [t].[EffectiveStartDate] = [t].[EffectiveStartDate]
	, [t].[EffectiveEndDate] = [t].[EffectiveEndDate]
	, [t].[External_Id__c] = [t].[External_Id__c]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [IsDeleted]
	, [SkillNumber]
	, [CurrencyIsoCode]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [ServiceResourceId]
	, [SkillId]
	, [SkillLevel]
	, [EffectiveStartDate]
	, [EffectiveEndDate]
	, [External_Id__c]
	)
	VALUES(
	[s].[Id]
	, [s].[IsDeleted]
	, [s].[SkillNumber]
	, [s].[CurrencyIsoCode]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[ServiceResourceId]
	, [s].[SkillId]
	, [s].[SkillLevel]
	, [s].[EffectiveStartDate]
	, [s].[EffectiveEndDate]
	, [s].[External_Id__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[ServiceResourceSkill] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
