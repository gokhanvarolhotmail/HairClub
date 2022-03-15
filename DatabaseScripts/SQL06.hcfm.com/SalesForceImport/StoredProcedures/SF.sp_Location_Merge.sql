/* CreateDate: 03/06/2022 17:23:57.277 , ModifyDate: 03/06/2022 17:23:57.277 */
GO
CREATE PROCEDURE [SF].[sp_Location_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[Location])
RETURN ;

BEGIN TRY
;MERGE [SF].[Location] AS [t]
USING [SFStaging].[Location] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[OwnerId] = [t].[OwnerId]
	, [t].[IsDeleted] = [t].[IsDeleted]
	, [t].[Name] = [t].[Name]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[LocationType] = [t].[LocationType]
	, [t].[Latitude] = [t].[Latitude]
	, [t].[Longitude] = [t].[Longitude]
	, [t].[Location] = [t].[Location]
	, [t].[Description] = [t].[Description]
	, [t].[DrivingDirections] = [t].[DrivingDirections]
	, [t].[TimeZone] = [t].[TimeZone]
	, [t].[ParentLocationId] = [t].[ParentLocationId]
	, [t].[PossessionDate] = [t].[PossessionDate]
	, [t].[ConstructionStartDate] = [t].[ConstructionStartDate]
	, [t].[ConstructionEndDate] = [t].[ConstructionEndDate]
	, [t].[OpenDate] = [t].[OpenDate]
	, [t].[CloseDate] = [t].[CloseDate]
	, [t].[RemodelStartDate] = [t].[RemodelStartDate]
	, [t].[RemodelEndDate] = [t].[RemodelEndDate]
	, [t].[IsMobile] = [t].[IsMobile]
	, [t].[IsInventoryLocation] = [t].[IsInventoryLocation]
	, [t].[RootLocationId] = [t].[RootLocationId]
	, [t].[LocationLevel] = [t].[LocationLevel]
	, [t].[ExternalReference] = [t].[ExternalReference]
	, [t].[LogoId] = [t].[LogoId]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [OwnerId]
	, [IsDeleted]
	, [Name]
	, [CurrencyIsoCode]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [LocationType]
	, [Latitude]
	, [Longitude]
	, [Location]
	, [Description]
	, [DrivingDirections]
	, [TimeZone]
	, [ParentLocationId]
	, [PossessionDate]
	, [ConstructionStartDate]
	, [ConstructionEndDate]
	, [OpenDate]
	, [CloseDate]
	, [RemodelStartDate]
	, [RemodelEndDate]
	, [IsMobile]
	, [IsInventoryLocation]
	, [RootLocationId]
	, [LocationLevel]
	, [ExternalReference]
	, [LogoId]
	)
	VALUES(
	[s].[Id]
	, [s].[OwnerId]
	, [s].[IsDeleted]
	, [s].[Name]
	, [s].[CurrencyIsoCode]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[LocationType]
	, [s].[Latitude]
	, [s].[Longitude]
	, [s].[Location]
	, [s].[Description]
	, [s].[DrivingDirections]
	, [s].[TimeZone]
	, [s].[ParentLocationId]
	, [s].[PossessionDate]
	, [s].[ConstructionStartDate]
	, [s].[ConstructionEndDate]
	, [s].[OpenDate]
	, [s].[CloseDate]
	, [s].[RemodelStartDate]
	, [s].[RemodelEndDate]
	, [s].[IsMobile]
	, [s].[IsInventoryLocation]
	, [s].[RootLocationId]
	, [s].[LocationLevel]
	, [s].[ExternalReference]
	, [s].[LogoId]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[Location] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
