/* CreateDate: 05/03/2010 12:26:20.543 , ModifyDate: 08/24/2021 20:18:19.303 */
GO
CREATE TABLE [bi_mktg_stage].[DimContact](
	[DataPkgKey] [int] NULL,
	[ContactKey] [int] NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactMiddleName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactLastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSuffix] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactStatusSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactMethodSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactMethodDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotSolicitFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotCallFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotEmailFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotMailFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotTextFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactGender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactCallTime] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompleteSale] [int] NULL,
	[ContactResearch] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferringStore] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferringStylist] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactLanguageSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactLanguageDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactPromotonSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactPromotionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactRequestSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactRequestDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactAgeRangeSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactAgeRangeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactHairLossSSID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactHairLossDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNCFlag] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNCDate] [datetime] NULL,
	[ContactAffiliateID] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactCenterSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactCenter] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactAlternateCenter] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifiedDate] [datetime] NULL,
	[IsNew] [tinyint] NULL,
	[IsType1] [tinyint] NULL,
	[IsType2] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsInferredMember] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdiFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DiscStyleSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTreatment] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossInFamily] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreationDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[ContactSessionid] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactOriginalCenter] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleySiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleySFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DMARegion] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DMADescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GCLID] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_IsDeleted] [bit] NULL,
	[LeadSource] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Accomodation] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [nvarchar](105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Activity_status__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimContact_ContactSSID_DataPkgKey] ON [bi_mktg_stage].[DimContact]
(
	[DataPkgKey] ASC,
	[ContactSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC,
	[SFDC_LeadID] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_mktg_stage].[DimContact] ADD  CONSTRAINT [DF_DimContact_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
