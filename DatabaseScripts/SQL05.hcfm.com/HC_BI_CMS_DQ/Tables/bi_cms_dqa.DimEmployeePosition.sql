/* CreateDate: 08/02/2012 13:38:54.040 , ModifyDate: 08/02/2012 13:38:54.790 */
GO
CREATE TABLE [bi_cms_dqa].[DimEmployeePosition](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[EmployeePositionKey] [int] NULL,
	[EmployeePositionSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeePositionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeePositionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeePositionSortOrder] [int] NULL,
	[ActiveDirectoryGroup] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAdministratorFlag] [bit] NULL,
	[IsEmployeeOneFlag] [bit] NULL,
	[IsEmployeeTwoFlag] [bit] NULL,
	[IsEmployeeThreeFlag] [bit] NULL,
	[IsEmployeeFourFlag] [bit] NULL,
	[CanScheduleFlag] [bit] NULL,
	[ApplicationTimeoutMinutes] [int] NULL,
	[UseDefaultCenterFlag] [bit] NULL,
	[IsSurgeryCenterEmployeeFlag] [bit] NULL,
	[IsNonSurgeryCenterEmployeeFlag] [bit] NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
 CONSTRAINT [PK_DimEmployeePosition] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
