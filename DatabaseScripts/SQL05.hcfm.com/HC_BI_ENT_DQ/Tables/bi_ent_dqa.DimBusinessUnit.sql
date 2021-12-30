/* CreateDate: 05/03/2010 12:09:05.180 , ModifyDate: 05/03/2010 12:09:05.543 */
GO
CREATE TABLE [bi_ent_dqa].[DimBusinessUnit](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[BusinessUnitKey] [int] NULL,
	[BusinessUnitSSID] [int] NULL,
	[BusinessUnitDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessUnitDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessUnitBrandKey] [int] NULL,
	[BusinessUnitBrandSSID] [int] NULL,
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
 CONSTRAINT [PK_DimBusinessUnit] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
