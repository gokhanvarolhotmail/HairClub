/* CreateDate: 05/03/2010 12:22:42.583 , ModifyDate: 11/26/2018 15:56:57.890 */
GO
CREATE TABLE [bi_mktg_dqa].[DimEmployee](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeLastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeTitle] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionSetCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeDepartmentSSID] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeDepartmentDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeJobFunctionSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeJobFunctionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
 CONSTRAINT [PK_DimEmployee] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_dqa].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
