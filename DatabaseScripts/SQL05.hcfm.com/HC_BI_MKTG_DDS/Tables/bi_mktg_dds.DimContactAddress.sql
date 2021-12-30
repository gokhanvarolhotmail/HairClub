/* CreateDate: 05/03/2010 12:21:09.537 , ModifyDate: 09/03/2021 09:35:32.953 */
GO
CREATE TABLE [bi_mktg_dds].[DimContactAddress](
	[ContactAddressKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ContactAddressSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressTypeCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AddressLine1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine2] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine3] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine4] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine1Soundex] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AddressLine2Soundex] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[City] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CitySoundex] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ZipCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountyCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountyName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryPrefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeZoneCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PrimaryFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadAddressID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimContactAddress] PRIMARY KEY CLUSTERED
(
	[ContactAddressKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimContactAddress_RowIsCurrent_ContactAddressSSID_ContactAddressKey] ON [bi_mktg_dds].[DimContactAddress]
(
	[ContactAddressSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([ContactAddressKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimContactAddress_RowIsCurrent_SFDC_LeadID_ContactAddressKey] ON [bi_mktg_dds].[DimContactAddress]
(
	[SFDC_LeadID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([ContactAddressKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_mktg_dds].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_StateName]  DEFAULT ('') FOR [StateName]
GO
ALTER TABLE [bi_mktg_dds].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_CountyName]  DEFAULT ('') FOR [CountyName]
GO
ALTER TABLE [bi_mktg_dds].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_CountryName]  DEFAULT ('') FOR [CountryName]
GO
ALTER TABLE [bi_mktg_dds].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_CountryPrefix]  DEFAULT ('') FOR [CountryPrefix]
GO
ALTER TABLE [bi_mktg_dds].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_mktg_dds].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_mktg_dds].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
