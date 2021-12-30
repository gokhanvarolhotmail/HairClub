/* CreateDate: 06/29/2011 09:43:12.483 , ModifyDate: 05/02/2021 19:40:55.690 */
GO
CREATE TABLE [bi_cms_stage].[DimClient](
	[DataPkgKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[ClientNumber_Temp] [int] NULL,
	[ClientIdentifier] [int] NULL,
	[ClientFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMiddleName] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientLastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalutationSSID] [int] NULL,
	[ClientSalutationDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientSalutationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientAddress1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientAddress2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientAddress3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientDateOfBirth] [datetime] NULL,
	[GenderSSID] [int] NULL,
	[ClientGenderDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientGenderDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusSSID] [int] NULL,
	[ClientMaritalStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMaritalStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationSSID] [int] NULL,
	[ClientOccupationDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientOccupationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthinicitySSID] [int] NULL,
	[ClientEthinicityDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientEthinicityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotCallFlag] [bit] NULL,
	[DoNotContactFlag] [bit] NULL,
	[IsHairModelFlag] [bit] NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[ClientEMailAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientTextMessageAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientPhone1] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1TypeSSID] [int] NULL,
	[ClientPhone1TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientPhone1TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientPhone2] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone2TypeSSID] [int] NULL,
	[ClientPhone2TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientPhone2TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientPhone3] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone3TypeSSID] [int] NULL,
	[ClientPhone3TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientPhone3TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentBioMatrixClientMembershipSSID] [uniqueidentifier] NULL,
	[CurrentSurgeryClientMembershipSSID] [uniqueidentifier] NULL,
	[CurrentExtremeTherapyClientMembershipSSID] [uniqueidentifier] NULL,
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
	[ClientARBalance] [money] NULL,
	[contactssid] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contactkey] [int] NULL,
	[CurrentXtrandsClientMembershipSSID] [uniqueidentifier] NULL,
	[BosleyProcedureOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleyConsultOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleySiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpectedConversionDate] [datetime] NULL,
	[SFDC_Leadid] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentMDPClientMembershipSSID] [uniqueidentifier] NULL,
	[ClientEmailAddressHashed] [varbinary](128) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimClient_ClientSSID_DataPkgKey] ON [bi_cms_stage].[DimClient]
(
	[DataPkgKey] ASC,
	[ClientSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_Phone1TypeSSID_1]  DEFAULT ((-2)) FOR [Phone1TypeSSID]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_Phone2TypeSSID_1]  DEFAULT ((-2)) FOR [Phone2TypeSSID]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_Phone3TypeSSID_1]  DEFAULT ((-2)) FOR [Phone3TypeSSID]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimClient] ADD  CONSTRAINT [DF_DimClient_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
