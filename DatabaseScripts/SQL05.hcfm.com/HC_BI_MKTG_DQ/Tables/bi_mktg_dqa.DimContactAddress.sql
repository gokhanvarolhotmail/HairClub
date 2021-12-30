/* CreateDate: 05/03/2010 12:22:42.490 , ModifyDate: 09/10/2020 11:17:33.260 */
GO
CREATE TABLE [bi_mktg_dqa].[DimContactAddress](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[ContactAddressKey] [int] NULL,
	[ContactAddressSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressTypeCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine2] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine3] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine4] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine1Soundex] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine2Soundex] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CitySoundex] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountyCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountyName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryPrefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeZoneCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PrimaryFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[CreateTimestamp] [datetime] NOT NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadAddressID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimContactAddress_1] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactAddress] ADD  CONSTRAINT [DF_DimContactAddress_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
