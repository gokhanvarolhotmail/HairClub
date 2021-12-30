/* CreateDate: 05/03/2010 12:21:09.517 , ModifyDate: 09/03/2021 09:35:33.147 */
GO
CREATE TABLE [bi_mktg_dds].[DimContact](
	[ContactKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactMiddleName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactLastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSuffix] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Salutation] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactStatusSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactMethodSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactMethodDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DoNotSolicitFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DoNotCallFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DoNotEmailFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DoNotMailFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DoNotTextFlag] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactGender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactCallTime] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CompleteSale] [int] NULL,
	[ContactResearch] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ReferringStore] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ReferringStylist] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactLanguageSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactLanguageDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactPromotonSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactPromotionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactRequestSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactRequestDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactAgeRangeSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactAgeRangeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactHairLossSSID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactHairLossDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNCFlag] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DNCDate] [datetime] NULL,
	[ContactAffiliateID] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactCenterSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactCenter] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactAlternateCenter] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[AdiFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DiscStyleSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTreatment] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossinFamily] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreationDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[ContactSessionid] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactOriginalCenter] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleySiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleySFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactFullName]  AS ((isnull([ContactLastName],'')+', ')+isnull([ContactFirstName],'')) PERSISTED NOT NULL,
	[DMARegion] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DMADescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[Lead_Activity_status__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimContact] PRIMARY KEY CLUSTERED
(
	[ContactKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimContact_RowIsCurrent_ContactSSID_ContactKey] ON [bi_mktg_dds].[DimContact]
(
	[ContactSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([ContactKey],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimContact_SFDC_LeadID_ContactStatusSSID] ON [bi_mktg_dds].[DimContact]
(
	[SFDC_LeadID] ASC,
	[ContactStatusSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimContact_ContactStatusSSID_INCL] ON [bi_mktg_dds].[DimContact]
(
	[ContactStatusSSID] ASC
)
INCLUDE([ContactKey],[ContactSSID],[ContactFirstName],[ContactLastName],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimContact_SFDC_PersonAccountID_ContactStatusSSID_INCL] ON [bi_mktg_dds].[DimContact]
(
	[SFDC_PersonAccountID] ASC,
	[ContactStatusSSID] ASC
)
INCLUDE([ContactKey],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dds].[DimContact] ADD  CONSTRAINT [DF_DimContact_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_mktg_dds].[DimContact] ADD  CONSTRAINT [DF_DimContact_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_mktg_dds].[DimContact] ADD  CONSTRAINT [DF_DimContact_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Original OnContactID from previous CRM' , @level0type=N'SCHEMA',@level0name=N'bi_mktg_dds', @level1type=N'TABLE',@level1name=N'DimContact', @level2type=N'COLUMN',@level2name=N'ContactSSID'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Contact''s first name as entered in CRM solution' , @level0type=N'SCHEMA',@level0name=N'bi_mktg_dds', @level1type=N'TABLE',@level1name=N'DimContact', @level2type=N'COLUMN',@level2name=N'ContactFirstName'
GO
