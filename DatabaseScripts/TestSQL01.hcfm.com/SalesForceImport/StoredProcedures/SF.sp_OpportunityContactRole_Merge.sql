/* CreateDate: 03/04/2022 08:19:53.433 , ModifyDate: 03/04/2022 08:19:53.433 */
GO
CREATE PROCEDURE [SF].[sp_OpportunityContactRole_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[OpportunityContactRole])
RETURN ;

SET XACT_ABORT ON

BEGIN TRANSACTION

;MERGE [SF].[OpportunityContactRole] AS [t]
USING [SFStaging].[OpportunityContactRole] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[OpportunityId] = [t].[OpportunityId]
	, [t].[ContactId] = [t].[ContactId]
	, [t].[Role] = [t].[Role]
	, [t].[IsPrimary] = [t].[IsPrimary]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[IsDeleted] = [t].[IsDeleted]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [OpportunityId]
	, [ContactId]
	, [Role]
	, [IsPrimary]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [IsDeleted]
	, [CurrencyIsoCode]
	)
	VALUES(
	[s].[Id]
	, [s].[OpportunityId]
	, [s].[ContactId]
	, [s].[Role]
	, [s].[IsPrimary]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[IsDeleted]
	, [s].[CurrencyIsoCode]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[OpportunityContactRole] ;

COMMIT ;
GO
