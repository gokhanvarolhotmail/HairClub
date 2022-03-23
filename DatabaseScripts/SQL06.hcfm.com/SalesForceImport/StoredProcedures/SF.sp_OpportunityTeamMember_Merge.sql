/* CreateDate: 03/17/2022 15:12:15.980 , ModifyDate: 03/17/2022 15:12:15.980 */
GO
CREATE PROCEDURE [SF].[sp_OpportunityTeamMember_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[OpportunityTeamMember])
RETURN ;

BEGIN TRY
;MERGE [SF].[OpportunityTeamMember] AS [t]
USING [SFStaging].[OpportunityTeamMember] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[OpportunityId] = [t].[OpportunityId]
	, [t].[UserId] = [t].[UserId]
	, [t].[Name] = [t].[Name]
	, [t].[PhotoUrl] = [t].[PhotoUrl]
	, [t].[Title] = [t].[Title]
	, [t].[TeamMemberRole] = [t].[TeamMemberRole]
	, [t].[OpportunityAccessLevel] = [t].[OpportunityAccessLevel]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[IsDeleted] = [t].[IsDeleted]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [OpportunityId]
	, [UserId]
	, [Name]
	, [PhotoUrl]
	, [Title]
	, [TeamMemberRole]
	, [OpportunityAccessLevel]
	, [CurrencyIsoCode]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [IsDeleted]
	)
	VALUES(
	[s].[Id]
	, [s].[OpportunityId]
	, [s].[UserId]
	, [s].[Name]
	, [s].[PhotoUrl]
	, [s].[Title]
	, [s].[TeamMemberRole]
	, [s].[OpportunityAccessLevel]
	, [s].[CurrencyIsoCode]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[IsDeleted]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[OpportunityTeamMember] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
