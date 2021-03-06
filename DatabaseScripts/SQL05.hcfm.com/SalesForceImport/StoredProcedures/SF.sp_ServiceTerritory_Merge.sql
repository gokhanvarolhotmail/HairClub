/* CreateDate: 03/17/2022 15:12:22.110 , ModifyDate: 03/17/2022 15:12:22.110 */
GO
CREATE PROCEDURE [SF].[sp_ServiceTerritory_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[ServiceTerritory])
RETURN ;

BEGIN TRY
;MERGE [SF].[ServiceTerritory] AS [t]
USING [SFStaging].[ServiceTerritory] AS [s]
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
	, [t].[ParentTerritoryId] = [t].[ParentTerritoryId]
	, [t].[TopLevelTerritoryId] = [t].[TopLevelTerritoryId]
	, [t].[Description] = [t].[Description]
	, [t].[OperatingHoursId] = [t].[OperatingHoursId]
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
	, [t].[IsActive] = [t].[IsActive]
	, [t].[TypicalInTerritoryTravelTime] = [t].[TypicalInTerritoryTravelTime]
	, [t].[Alternative_Phone__c] = [t].[Alternative_Phone__c]
	, [t].[AreaManager__c] = [t].[AreaManager__c]
	, [t].[Area__c] = [t].[Area__c]
	, [t].[AssistantManager__c] = [t].[AssistantManager__c]
	, [t].[BackLinePhone__c] = [t].[BackLinePhone__c]
	, [t].[BestTressedOffered__c] = [t].[BestTressedOffered__c]
	, [t].[Caller_Id__c] = [t].[Caller_Id__c]
	, [t].[CenterAlert__c] = [t].[CenterAlert__c]
	, [t].[CenterNumber__c] = [t].[CenterNumber__c]
	, [t].[CenterOwner__c] = [t].[CenterOwner__c]
	, [t].[CenterType__c] = [t].[CenterType__c]
	, [t].[CompanyID__c] = [t].[CompanyID__c]
	, [t].[Company__c] = [t].[Company__c]
	, [t].[ConfirmationCallerIDEnglish__c] = [t].[ConfirmationCallerIDEnglish__c]
	, [t].[ConfirmationCallerIDFrench__c] = [t].[ConfirmationCallerIDFrench__c]
	, [t].[ConfirmationCallerIDSpanish__c] = [t].[ConfirmationCallerIDSpanish__c]
	, [t].[CustomerServiceLine__c] = [t].[CustomerServiceLine__c]
	, [t].[DisplayName__c] = [t].[DisplayName__c]
	, [t].[External_Id__c] = [t].[External_Id__c]
	, [t].[ImageConsultant__c] = [t].[ImageConsultant__c]
	, [t].[MDPOffered__c] = [t].[MDPOffered__c]
	, [t].[MDPPerformed__c] = [t].[MDPPerformed__c]
	, [t].[Main_Phone__c] = [t].[Main_Phone__c]
	, [t].[ManagerName__c] = [t].[ManagerName__c]
	, [t].[Map_Short_Link__c] = [t].[Map_Short_Link__c]
	, [t].[MgrCellPhone__c] = [t].[MgrCellPhone__c]
	, [t].[OfferPRP__c] = [t].[OfferPRP__c]
	, [t].[OtherCallerIDEnglish__c] = [t].[OtherCallerIDEnglish__c]
	, [t].[OtherCallerIDFrench__c] = [t].[OtherCallerIDFrench__c]
	, [t].[OtherCallerIDSpanish__c] = [t].[OtherCallerIDSpanish__c]
	, [t].[OutboundDialingAllowed__c] = [t].[OutboundDialingAllowed__c]
	, [t].[ProfileCode__c] = [t].[ProfileCode__c]
	, [t].[Region__c] = [t].[Region__c]
	, [t].[Status__c] = [t].[Status__c]
	, [t].[Supported_Appointment_Types__c] = [t].[Supported_Appointment_Types__c]
	, [t].[SurgeryOffered__c] = [t].[SurgeryOffered__c]
	, [t].[TimeZone__c] = [t].[TimeZone__c]
	, [t].[Type__c] = [t].[Type__c]
	, [t].[WebPhone__c] = [t].[WebPhone__c]
	, [t].[Web_Phone__c] = [t].[Web_Phone__c]
	, [t].[X1Apptperslot__c] = [t].[X1Apptperslot__c]
	, [t].[English_Directions__c] = [t].[English_Directions__c]
	, [t].[French_Directions__c] = [t].[French_Directions__c]
	, [t].[Spanish_Directions__c] = [t].[Spanish_Directions__c]
	, [t].[Virtual__c] = [t].[Virtual__c]
	, [t].[English_Cross_Streets__c] = [t].[English_Cross_Streets__c]
	, [t].[French_Cross_Streets__c] = [t].[French_Cross_Streets__c]
	, [t].[Spanish_Cross_Streets__c] = [t].[Spanish_Cross_Streets__c]
	, [t].[Business_Hours__c] = [t].[Business_Hours__c]
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
	, [ParentTerritoryId]
	, [TopLevelTerritoryId]
	, [Description]
	, [OperatingHoursId]
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
	, [IsActive]
	, [TypicalInTerritoryTravelTime]
	, [Alternative_Phone__c]
	, [AreaManager__c]
	, [Area__c]
	, [AssistantManager__c]
	, [BackLinePhone__c]
	, [BestTressedOffered__c]
	, [Caller_Id__c]
	, [CenterAlert__c]
	, [CenterNumber__c]
	, [CenterOwner__c]
	, [CenterType__c]
	, [CompanyID__c]
	, [Company__c]
	, [ConfirmationCallerIDEnglish__c]
	, [ConfirmationCallerIDFrench__c]
	, [ConfirmationCallerIDSpanish__c]
	, [CustomerServiceLine__c]
	, [DisplayName__c]
	, [External_Id__c]
	, [ImageConsultant__c]
	, [MDPOffered__c]
	, [MDPPerformed__c]
	, [Main_Phone__c]
	, [ManagerName__c]
	, [Map_Short_Link__c]
	, [MgrCellPhone__c]
	, [OfferPRP__c]
	, [OtherCallerIDEnglish__c]
	, [OtherCallerIDFrench__c]
	, [OtherCallerIDSpanish__c]
	, [OutboundDialingAllowed__c]
	, [ProfileCode__c]
	, [Region__c]
	, [Status__c]
	, [Supported_Appointment_Types__c]
	, [SurgeryOffered__c]
	, [TimeZone__c]
	, [Type__c]
	, [WebPhone__c]
	, [Web_Phone__c]
	, [X1Apptperslot__c]
	, [English_Directions__c]
	, [French_Directions__c]
	, [Spanish_Directions__c]
	, [Virtual__c]
	, [English_Cross_Streets__c]
	, [French_Cross_Streets__c]
	, [Spanish_Cross_Streets__c]
	, [Business_Hours__c]
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
	, [s].[ParentTerritoryId]
	, [s].[TopLevelTerritoryId]
	, [s].[Description]
	, [s].[OperatingHoursId]
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
	, [s].[IsActive]
	, [s].[TypicalInTerritoryTravelTime]
	, [s].[Alternative_Phone__c]
	, [s].[AreaManager__c]
	, [s].[Area__c]
	, [s].[AssistantManager__c]
	, [s].[BackLinePhone__c]
	, [s].[BestTressedOffered__c]
	, [s].[Caller_Id__c]
	, [s].[CenterAlert__c]
	, [s].[CenterNumber__c]
	, [s].[CenterOwner__c]
	, [s].[CenterType__c]
	, [s].[CompanyID__c]
	, [s].[Company__c]
	, [s].[ConfirmationCallerIDEnglish__c]
	, [s].[ConfirmationCallerIDFrench__c]
	, [s].[ConfirmationCallerIDSpanish__c]
	, [s].[CustomerServiceLine__c]
	, [s].[DisplayName__c]
	, [s].[External_Id__c]
	, [s].[ImageConsultant__c]
	, [s].[MDPOffered__c]
	, [s].[MDPPerformed__c]
	, [s].[Main_Phone__c]
	, [s].[ManagerName__c]
	, [s].[Map_Short_Link__c]
	, [s].[MgrCellPhone__c]
	, [s].[OfferPRP__c]
	, [s].[OtherCallerIDEnglish__c]
	, [s].[OtherCallerIDFrench__c]
	, [s].[OtherCallerIDSpanish__c]
	, [s].[OutboundDialingAllowed__c]
	, [s].[ProfileCode__c]
	, [s].[Region__c]
	, [s].[Status__c]
	, [s].[Supported_Appointment_Types__c]
	, [s].[SurgeryOffered__c]
	, [s].[TimeZone__c]
	, [s].[Type__c]
	, [s].[WebPhone__c]
	, [s].[Web_Phone__c]
	, [s].[X1Apptperslot__c]
	, [s].[English_Directions__c]
	, [s].[French_Directions__c]
	, [s].[Spanish_Directions__c]
	, [s].[Virtual__c]
	, [s].[English_Cross_Streets__c]
	, [s].[French_Cross_Streets__c]
	, [s].[Spanish_Cross_Streets__c]
	, [s].[Business_Hours__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[ServiceTerritory] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
