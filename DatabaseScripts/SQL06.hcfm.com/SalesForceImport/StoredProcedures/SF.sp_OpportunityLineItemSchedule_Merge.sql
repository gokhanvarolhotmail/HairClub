/* CreateDate: 03/06/2022 17:23:57.490 , ModifyDate: 03/06/2022 17:23:57.490 */
GO
CREATE PROCEDURE [SF].[sp_OpportunityLineItemSchedule_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[OpportunityLineItemSchedule])
RETURN ;

BEGIN TRY
;MERGE [SF].[OpportunityLineItemSchedule] AS [t]
USING [SFStaging].[OpportunityLineItemSchedule] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[OpportunityLineItemId] = [t].[OpportunityLineItemId]
	, [t].[Type] = [t].[Type]
	, [t].[Revenue] = [t].[Revenue]
	, [t].[Quantity] = [t].[Quantity]
	, [t].[Description] = [t].[Description]
	, [t].[ScheduleDate] = [t].[ScheduleDate]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[IsDeleted] = [t].[IsDeleted]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [OpportunityLineItemId]
	, [Type]
	, [Revenue]
	, [Quantity]
	, [Description]
	, [ScheduleDate]
	, [CurrencyIsoCode]
	, [CreatedById]
	, [CreatedDate]
	, [LastModifiedById]
	, [LastModifiedDate]
	, [SystemModstamp]
	, [IsDeleted]
	)
	VALUES(
	[s].[Id]
	, [s].[OpportunityLineItemId]
	, [s].[Type]
	, [s].[Revenue]
	, [s].[Quantity]
	, [s].[Description]
	, [s].[ScheduleDate]
	, [s].[CurrencyIsoCode]
	, [s].[CreatedById]
	, [s].[CreatedDate]
	, [s].[LastModifiedById]
	, [s].[LastModifiedDate]
	, [s].[SystemModstamp]
	, [s].[IsDeleted]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[OpportunityLineItemSchedule] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
