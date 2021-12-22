/* CreateDate: 11/21/2019 15:17:53.760 , ModifyDate: 06/03/2020 23:19:06.430 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[DimClient](
	[ClientKey] [int] NOT NULL,
	[ClientSSID] [uniqueidentifier] NOT NULL,
	[ClientNumber_Temp] [int] NULL,
	[ClientIdentifier] [int] NOT NULL,
	[ClientFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMiddleName] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientLastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalutationSSID] [int] NOT NULL,
	[ClientSalutationDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientSalutationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientFullName]  AS (((isnull([ClientLastName],'')+', ')+isnull([ClientFirstName],''))+case when len(isnull([ClientMiddleName],''))>(0) then ' '+left([ClientMiddleName],(1)) else '' end) PERSISTED,
	[ClientAddress1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientAddress2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientAddress3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateProvinceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientDateOfBirth] [datetime] NULL,
	[GenderSSID] [int] NOT NULL,
	[ClientGenderDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientGenderDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MaritalStatusSSID] [int] NOT NULL,
	[ClientMaritalStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMaritalStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OccupationSSID] [int] NOT NULL,
	[ClientOccupationDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientOccupationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EthinicitySSID] [int] NOT NULL,
	[ClientEthinicityDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientEthinicityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DoNotCallFlag] [bit] NULL,
	[DoNotContactFlag] [bit] NULL,
	[IsHairModelFlag] [bit] NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[ClientEMailAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientTextMessageAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientPhone1] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Phone1TypeSSID] [int] NOT NULL,
	[ClientPhone1TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientPhone1TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientPhone2] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Phone2TypeSSID] [int] NOT NULL,
	[ClientPhone2TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientPhone2TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientPhone3] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Phone3TypeSSID] [int] NOT NULL,
	[ClientPhone3TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientPhone3TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [binary](8) NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[CurrentBioMatrixClientMembershipSSID] [uniqueidentifier] NULL,
	[CurrentSurgeryClientMembershipSSID] [uniqueidentifier] NULL,
	[CurrentExtremeTherapyClientMembershipSSID] [uniqueidentifier] NULL,
	[CenterSSID] [int] NULL,
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
) ON [FG1]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_DimClient] ON [bi_cms_dds].[DimClient]
(
	[ClientKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimClient_CenterSSID_IncludeClientARBalance] ON [bi_cms_dds].[DimClient]
(
	[CenterSSID] ASC
)
INCLUDE([ClientARBalance]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimClient_ClientKey_Name] ON [bi_cms_dds].[DimClient]
(
	[ClientKey] ASC
)
INCLUDE([ClientSSID],[ClientIdentifier],[ClientFullName],[ClientLastName],[ClientFirstName],[ClientMiddleName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimClient_ExpectedConversionDate_IncludeColumns] ON [bi_cms_dds].[DimClient]
(
	[ExpectedConversionDate] ASC
)
INCLUDE([ClientKey],[ClientIdentifier],[CurrentBioMatrixClientMembershipSSID],[CurrentSurgeryClientMembershipSSID],[CurrentExtremeTherapyClientMembershipSSID],[CenterSSID],[CurrentXtrandsClientMembershipSSID],[GenderSSID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimClient_RowIsCurrent_ClientSSID_ClientKey] ON [bi_cms_dds].[DimClient]
(
	[ClientSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([ClientKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimClient_SFDC_LeadID] ON [bi_cms_dds].[DimClient]
(
	[SFDC_Leadid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimClient_ClientIdentifier] ON [bi_cms_dds].[DimClient]
(
	[ClientIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
