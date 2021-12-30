/* CreateDate: 05/03/2010 12:09:05.233 , ModifyDate: 05/03/2010 12:09:05.693 */
GO
CREATE TABLE [bi_ent_dqa].[DimCenterOwnership](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NOT NULL,
	[CenterOwnershipKey] [int] NULL,
	[CenterOwnershipSSID] [int] NULL,
	[CenterOwnershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterOwnershipDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerLastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CorporateName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
 CONSTRAINT [PK_DimCenterOwnership] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_dqa].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
