/* CreateDate: 05/03/2010 12:22:42.550 , ModifyDate: 09/10/2020 11:17:33.940 */
GO
CREATE TABLE [bi_mktg_dqa].[DimContactSource](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[ContactSourceKey] [int] NULL,
	[ContactSourceSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediaCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssignmentDate] [date] NULL,
	[AssignmentTime] [time](0) NULL,
	[PrimaryFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNIS_Number] [int] NULL,
	[SubSourceCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimContactSource_1] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_dqa].[DimContactSource] ADD  CONSTRAINT [DF_DimContactSource_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
