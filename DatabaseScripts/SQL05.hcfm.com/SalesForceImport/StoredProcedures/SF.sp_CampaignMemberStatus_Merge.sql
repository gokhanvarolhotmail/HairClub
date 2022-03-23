/* CreateDate: 03/17/2022 15:12:21.070 , ModifyDate: 03/17/2022 15:12:21.070 */
GO
CREATE PROCEDURE [SF].[sp_CampaignMemberStatus_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[CampaignMemberStatus])
RETURN ;

BEGIN TRY
;MERGE [SF].[CampaignMemberStatus] AS [t]
USING [SFStaging].[CampaignMemberStatus] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[IsDeleted] = [t].[IsDeleted]
	, [t].[CampaignId] = [t].[CampaignId]
	, [t].[Label] = [t].[Label]
	, [t].[SortOrder] = [t].[SortOrder]
	, [t].[IsDefault] = [t].[IsDefault]
	, [t].[HasResponded] = [t].[HasResponded]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [IsDeleted]
	, [CampaignId]
	, [Label]
	, [SortOrder]
	, [IsDefault]
	, [HasResponded]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	)
	VALUES(
	[s].[Id]
	, [s].[IsDeleted]
	, [s].[CampaignId]
	, [s].[Label]
	, [s].[SortOrder]
	, [s].[IsDefault]
	, [s].[HasResponded]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[CampaignMemberStatus] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
