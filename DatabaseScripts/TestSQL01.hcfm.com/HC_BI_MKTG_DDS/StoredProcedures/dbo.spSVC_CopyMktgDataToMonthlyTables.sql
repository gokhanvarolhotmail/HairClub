/* CreateDate: 04/01/2021 09:02:51.190 , ModifyDate: 05/07/2021 10:18:29.773 */
GO
-- =============================================
-- Author:		Kevin Murdoch
-- Create date: 04/01/2021
-- Description:	Copies FactLead, DimContact, FactActivityResults, DimActivityResults to Monthly Tables
--				Prior to running this script change the BeginDateKey and EndDateKey to be for the prior month period

-- NOTES:
--	05/07/2021	KMurdoch	Insert Monthly insert date
--
-- =============================================
CREATE PROCEDURE [dbo].[spSVC_CopyMktgDataToMonthlyTables]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @BeginDateKey INT;
    DECLARE @EndDatekey INT;
	DECLARE @FirstDay DATETIME;
	DECLARE @LastDay DATETIME;

	SET @FirstDay = DATEADD(month, DATEDIFF(month, -1, GETDATE()) - 2, 0)
	SET @LastDay = DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))

	--SELECT CONVERT(INT, CONVERT(VARCHAR(4),YEAR(GETDATE())) + FORMAT(MONTH(GETDATE()-1),'00') + CONVERT(VARCHAR(2),DAY(DATEADD(DAY, -(DAY(GETDATE())), GETDATE()))))
	--SELECT CONVERT(INT, CONVERT(VARCHAR(4),YEAR(GETDATE())) + FORMAT(MONTH(GETDATE()-1),'00') + CONVERT(VARCHAR(2),'01'))


    SET @BeginDateKey = CONVERT(INT, CONVERT(VARCHAR(4),YEAR(@FirstDay)) + FORMAT(MONTH(@FirstDay),'00') + CONVERT(VARCHAR(2),'01'));
    SET @EndDatekey = CONVERT(INT, CONVERT(VARCHAR(4),YEAR(@LastDay)) + FORMAT(MONTH(@LastDay),'00') + CONVERT(VARCHAR(2),DAY(@LastDay)));

	--SELECT @BeginDateKey
	--SELECT @EndDatekey
	--SELECT @LastDay
	--SELECT @FirstDay

    /**********************************************************************************************************

INSERT FACTLEAD INTO FACTLEADMONTHLY TABLE

--***********************************************************************************************************/
    INSERT INTO [HC_BI_MKTG_DDS].[bi_mktg_dds].[FactLeadMonthly]
    (
        [ContactKey],
        [LeadCreationDateKey],
        [LeadCreationTimeKey],
        [CenterKey],
        [SourceKey],
        [GenderKey],
        [OccupationKey],
        [EthnicityKey],
        [MaritalStatusKey],
        [HairLossTypeKey],
        [AgeRangeKey],
        [EmployeeKey],
        [PromotionCodeKey],
        [SalesTypeKey],
        [Leads],
        [Appointments],
        [Shows],
        [Sales],
        [Activities],
        [NoShows],
        [NoSales],
        [InsertAuditKey],
        [UpdateAuditKey],
        [AssignedEmployeeKey],
        [SHOWDIFF],
        [SALEDIFF],
        [QuestionAge],
        [RecentSourceKey],
        [InvalidLead],
		[MonthlyInsertDate]
    )
    SELECT [ContactKey],
           [LeadCreationDateKey],
           [LeadCreationTimeKey],
           [CenterKey],
           [SourceKey],
           [GenderKey],
           [OccupationKey],
           [EthnicityKey],
           [MaritalStatusKey],
           [HairLossTypeKey],
           [AgeRangeKey],
           [EmployeeKey],
           [PromotionCodeKey],
           [SalesTypeKey],
           [Leads],
           [Appointments],
           [Shows],
           [Sales],
           [Activities],
           [NoShows],
           [NoSales],
           [InsertAuditKey],
           [UpdateAuditKey],
           [AssignedEmployeeKey],
           [SHOWDIFF],
           [SALEDIFF],
           [QuestionAge],
           [RecentSourceKey],
           [InvalidLead],
		   getutcdate()
    FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead
    WHERE LeadCreationDateKey
    BETWEEN @BeginDateKey AND @endDatekey
	and ContactKey not in (select contactkey from bi_mktg_dds.FactLeadMonthly where LeadCreationDateKey between @BeginDateKey AND @endDatekey)

    /**********************************************************************************************************

INSERT DIMCONTACT INTO DIMCONTACTMONTHLY TABLE

***********************************************************************************************************/

    INSERT INTO [bi_mktg_dds].[DimContactMonthly]
    (
        [ContactKey],
        [ContactSSID],
        [ContactFirstName],
        [ContactMiddleName],
        [ContactLastName],
        [ContactSuffix],
        [Salutation],
        [ContactStatusSSID],
        [ContactStatusDescription],
        [ContactMethodSSID],
        [ContactMethodDescription],
        [DoNotSolicitFlag],
        [DoNotCallFlag],
        [DoNotEmailFlag],
        [DoNotMailFlag],
        [DoNotTextFlag],
        [ContactGender],
        [ContactCallTime],
        [CompleteSale],
        [ContactResearch],
        [ReferringStore],
        [ReferringStylist],
        [ContactLanguageSSID],
        [ContactLanguageDescription],
        [ContactPromotonSSID],
        [ContactPromotionDescription],
        [ContactRequestSSID],
        [ContactRequestDescription],
        [ContactAgeRangeSSID],
        [ContactAgeRangeDescription],
        [ContactHairLossSSID],
        [ContactHairLossDescription],
        [DNCFlag],
        [DNCDate],
        [ContactAffiliateID],
        [ContactCenterSSID],
        [ContactCenter],
        [ContactAlternateCenter],
        [RowIsCurrent],
        [RowStartDate],
        [RowEndDate],
        [RowChangeReason],
        [RowIsInferred],
        [InsertAuditKey],
        [UpdateAuditKey],
        [AdiFlag],
        [DiscStyleSSID],
        [HairLossTreatment],
        [HairLossSpot],
        [HairLossExperience],
        [HairLossinFamily],
        [HairLossFamily],
        [CreationDate],
        [UpdateDate],
        [ContactSessionid],
        [ContactOriginalCenter],
        [SFDC_LeadID],
        [BosleySiebelID],
        [BosleySFDC_LeadID],
        [DMARegion],
        [DMADescription],
        [Street],
        [City],
        [State],
        [StateCode],
        [Country],
        [CountryCode],
        [PostalCode],
        [GCLID],
        [SFDC_PersonAccountID],
        [SFDC_IsDeleted],
        [LeadSource],
        [Accomodation],
        [Phone],
        [MobilePhone],
        [Email],
        [Lead_Activity_status__c],
		[MonthlyInsertDate]
    )
    SELECT dc.[ContactKey],
           [ContactSSID],
           [ContactFirstName],
           [ContactMiddleName],
           [ContactLastName],
           [ContactSuffix],
           [Salutation],
           [ContactStatusSSID],
           [ContactStatusDescription],
           [ContactMethodSSID],
           [ContactMethodDescription],
           [DoNotSolicitFlag],
           [DoNotCallFlag],
           [DoNotEmailFlag],
           [DoNotMailFlag],
           [DoNotTextFlag],
           [ContactGender],
           [ContactCallTime],
           [CompleteSale],
           [ContactResearch],
           [ReferringStore],
           [ReferringStylist],
           [ContactLanguageSSID],
           [ContactLanguageDescription],
           [ContactPromotonSSID],
           [ContactPromotionDescription],
           [ContactRequestSSID],
           [ContactRequestDescription],
           [ContactAgeRangeSSID],
           [ContactAgeRangeDescription],
           [ContactHairLossSSID],
           [ContactHairLossDescription],
           [DNCFlag],
           [DNCDate],
           [ContactAffiliateID],
           [ContactCenterSSID],
           [ContactCenter],
           [ContactAlternateCenter],
           [RowIsCurrent],
           [RowStartDate],
           [RowEndDate],
           [RowChangeReason],
           [RowIsInferred],
           dc.[InsertAuditKey],
           dc.[UpdateAuditKey],
           [AdiFlag],
           [DiscStyleSSID],
           [HairLossTreatment],
           [HairLossSpot],
           [HairLossExperience],
           [HairLossinFamily],
           [HairLossFamily],
           [CreationDate],
           [UpdateDate],
           [ContactSessionid],
           [ContactOriginalCenter],
           [SFDC_LeadID],
           [BosleySiebelID],
           [BosleySFDC_LeadID],
           [DMARegion],
           [DMADescription],
           [Street],
           [City],
           [State],
           [StateCode],
           [Country],
           [CountryCode],
           [PostalCode],
           [GCLID],
           [SFDC_PersonAccountID],
           [SFDC_IsDeleted],
           [LeadSource],
           [Accomodation],
           [Phone],
           [MobilePhone],
           [Email],
           [Lead_Activity_status__c],
		   getutcdate()
    FROM bi_mktg_dds.DimContact dc
        left outer JOIN bi_mktg_dds.FactLeadMonthly flm
            ON dc.ContactKey = flm.ContactKey
    WHERE flm.LeadCreationDateKey
    BETWEEN @BeginDateKey AND @endDatekey
	and dc.ContactKey not in (select contactkey from bi_mktg_dds.DimContactMonthly)



/**********************************************************************************************************

INSERT FACTACTIVITYRESULTS INTO FACTACTIVITYRESULTSMONTHLY TABLE

***********************************************************************************************************/

    INSERT INTO [bi_mktg_dds].[FactActivityResultsMonthly]
    (
        [ActivityKey],
        [ActivityDateKey],
        [ActivityTimeKey],
        [ActivityResultDateKey],
        [ActivityResultKey],
        [ActivityResultTimeKey],
        [ActivityCompletedDateKey],
        [ActivityCompletedTimeKey],
        [ActivityDueDateKey],
        [ActivityStartTimeKey],
        [OriginalAppointmentDateKey],
        [ActivitySavedDateKey],
        [ActivitySavedTimeKey],
        [ContactKey],
        [CenterKey],
        [SalesTypeKey],
        [SourceKey],
        [ActionCodeKey],
        [ResultCodeKey],
        [GenderKey],
        [OccupationKey],
        [EthnicityKey],
        [MaritalStatusKey],
        [HairLossTypeKey],
        [AgeRangeKey],
        [CompletedByEmployeeKey],
        [ClientNumber],
        [Appointments],
        [Show],
        [NoShow],
        [Sale],
        [NoSale],
        [Consultation],
        [BeBack],
        [SurgeryOffered],
        [ReferredToDoctor],
        [InitialPayment],
        [InsertAuditKey],
        [UpdateAuditKey],
        [ActivityEmployeeKey],
        [Accomodation],
        [LeadSourceKey],
        [LeadCreationDateKey],
        [LeadCreationTimeKey],
        [PromoCodeKey]
		--[MonthlyInsertDate]
    )
    SELECT [ActivityKey],
           [ActivityDateKey],
           [ActivityTimeKey],
           [ActivityResultDateKey],
           [ActivityResultKey],
           [ActivityResultTimeKey],
           [ActivityCompletedDateKey],
           [ActivityCompletedTimeKey],
           [ActivityDueDateKey],
           [ActivityStartTimeKey],
           [OriginalAppointmentDateKey],
           [ActivitySavedDateKey],
           [ActivitySavedTimeKey],
           [ContactKey],
           [CenterKey],
           [SalesTypeKey],
           [SourceKey],
           [ActionCodeKey],
           [ResultCodeKey],
           [GenderKey],
           [OccupationKey],
           [EthnicityKey],
           [MaritalStatusKey],
           [HairLossTypeKey],
           [AgeRangeKey],
           [CompletedByEmployeeKey],
           [ClientNumber],
           [Appointments],
           [Show],
           [NoShow],
           [Sale],
           [NoSale],
           [Consultation],
           [BeBack],
           [SurgeryOffered],
           [ReferredToDoctor],
           [InitialPayment],
           [InsertAuditKey],
           [UpdateAuditKey],
           [ActivityEmployeeKey],
           [Accomodation],
           [LeadSourceKey],
           [LeadCreationDateKey],
           [LeadCreationTimeKey],
           [PromoCodeKey]
		   --getutcdate()
    FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[FactActivityResults]
    WHERE ActivityDueDateKey
    BETWEEN @BeginDateKey AND @endDatekey;

    /**********************************************************************************************************

INSERT DIMACTIVITYRESULTS INTO DIMACTIVITYRESULTSMONTHLY TABLE

***********************************************************************************************************/


    INSERT INTO [bi_mktg_dds].[DimActivityResultMonthly]
    (
        [ActivityResultKey],
        [ActivityResultSSID],
        [CenterSSID],
        [ActivitySSID],
        [ContactSSID],
        [SalesTypeSSID],
        [SalesTypeDescription],
        [ActionCodeSSID],
        [ActionCodeDescription],
        [ResultCodeSSID],
        [ResultCodeDescription],
        [SourceSSID],
        [SourceDescription],
        [IsShow],
        [IsSale],
        [ContractNumber],
        [ContractAmount],
        [ClientNumber],
        [InitialPayment],
        [NumberOfGraphs],
        [OrigApptDate],
        [DateSaved],
        [RescheduledFlag],
        [RescheduledDate],
        [SurgeryOffered],
        [ReferredToDoctor],
        [RowIsCurrent],
        [RowStartDate],
        [RowEndDate],
        [RowChangeReason],
        [RowIsInferred],
        [InsertAuditKey],
        [UpdateAuditKey],
        [SFDC_TaskID],
        [SFDC_LeadID],
        [Accomodation],
        [SFDC_PersonAccountID]
		--[MonthlyInsertDate]
    )
    SELECT dar.[ActivityResultKey],
           [ActivityResultSSID],
           [CenterSSID],
           [ActivitySSID],
           [ContactSSID],
           [SalesTypeSSID],
           [SalesTypeDescription],
           [ActionCodeSSID],
           [ActionCodeDescription],
           [ResultCodeSSID],
           [ResultCodeDescription],
           [SourceSSID],
           [SourceDescription],
           [IsShow],
           [IsSale],
           [ContractNumber],
           [ContractAmount],
           dar.[ClientNumber],
           dar.[InitialPayment],
           [NumberOfGraphs],
           [OrigApptDate],
           [DateSaved],
           [RescheduledFlag],
           [RescheduledDate],
           dar.[SurgeryOffered],
           dar.[ReferredToDoctor],
           [RowIsCurrent],
           [RowStartDate],
           [RowEndDate],
           [RowChangeReason],
           [RowIsInferred],
           dar.[InsertAuditKey],
           dar.[UpdateAuditKey],
           [SFDC_TaskID],
           [SFDC_LeadID],
           dar.[Accomodation],
           [SFDC_PersonAccountID]
		   --getutcdate()
    FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult dar
        INNER JOIN bi_mktg_dds.FactActivityResultsMonthly farm
            ON dar.ActivityResultKey = farm.ActivityResultKey
    WHERE farm.ActivityDueDateKey
    BETWEEN @BeginDateKey AND @endDatekey;


END;
GO
