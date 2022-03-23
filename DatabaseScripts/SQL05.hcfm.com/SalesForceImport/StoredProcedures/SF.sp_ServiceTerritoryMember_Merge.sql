/* CreateDate: 03/17/2022 15:12:22.310 , ModifyDate: 03/17/2022 15:12:22.310 */
GO
CREATE PROCEDURE [SF].[sp_ServiceTerritoryMember_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[ServiceTerritoryMember])
RETURN ;

BEGIN TRY
;MERGE [SF].[ServiceTerritoryMember] AS [t]
USING [SFStaging].[ServiceTerritoryMember] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[IsDeleted] = [t].[IsDeleted]
	, [t].[MemberNumber] = [t].[MemberNumber]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[ServiceTerritoryId] = [t].[ServiceTerritoryId]
	, [t].[ServiceResourceId] = [t].[ServiceResourceId]
	, [t].[TerritoryType] = [t].[TerritoryType]
	, [t].[EffectiveStartDate] = [t].[EffectiveStartDate]
	, [t].[EffectiveEndDate] = [t].[EffectiveEndDate]
	, [t].[Street] = [t].[Street]
	, [t].[City] = [t].[City]
	, [t].[State] = [t].[State]
	, [t].[PostalCode] = [t].[PostalCode]
	, [t].[Country] = [t].[Country]
	, [t].[StateCode] = [t].[StateCode]
	, [t].[CountryCode] = [t].[CountryCode]
	, [t].[Latitude] = [t].[Latitude]
	, [t].[Longitude] = [t].[Longitude]
	, [t].[GeocodeAccuracy] = [t].[GeocodeAccuracy]
	, [t].[Address] = [t].[Address]
	, [t].[OperatingHoursId] = [t].[OperatingHoursId]
	, [t].[Role] = [t].[Role]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [IsDeleted]
	, [MemberNumber]
	, [CurrencyIsoCode]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [ServiceTerritoryId]
	, [ServiceResourceId]
	, [TerritoryType]
	, [EffectiveStartDate]
	, [EffectiveEndDate]
	, [Street]
	, [City]
	, [State]
	, [PostalCode]
	, [Country]
	, [StateCode]
	, [CountryCode]
	, [Latitude]
	, [Longitude]
	, [GeocodeAccuracy]
	, [Address]
	, [OperatingHoursId]
	, [Role]
	)
	VALUES(
	[s].[Id]
	, [s].[IsDeleted]
	, [s].[MemberNumber]
	, [s].[CurrencyIsoCode]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[ServiceTerritoryId]
	, [s].[ServiceResourceId]
	, [s].[TerritoryType]
	, [s].[EffectiveStartDate]
	, [s].[EffectiveEndDate]
	, [s].[Street]
	, [s].[City]
	, [s].[State]
	, [s].[PostalCode]
	, [s].[Country]
	, [s].[StateCode]
	, [s].[CountryCode]
	, [s].[Latitude]
	, [s].[Longitude]
	, [s].[GeocodeAccuracy]
	, [s].[Address]
	, [s].[OperatingHoursId]
	, [s].[Role]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[ServiceTerritoryMember] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
