/* CreateDate: 07/13/2011 09:10:24.107 , ModifyDate: 11/30/2012 11:02:03.790 */
GO
CREATE TABLE [bi_cms_stage].[DimEmployee](
	[DataPkgKey] [int] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeSSID] [uniqueidentifier] NULL,
	[CenterSSID] [int] NULL,
	[EmployeeFullName]  AS ((isnull([EmployeeLastName],'')+', ')+isnull([EmployeeFirstName],'')) PERSISTED NOT NULL,
	[EmployeeFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeLastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeInitials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalutationSSID] [int] NULL,
	[EmployeeSalutationDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeSalutationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeAddress1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeAddress2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeAddress3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserLogin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeePhoneMain] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeePhoneAlternate] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeEmergencyContact] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeePayrollNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeTimeClockNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[EmployeePayrollID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimEmployee_EmployeeSSID_DataPkgKey] ON [bi_cms_stage].[DimEmployee]
(
	[DataPkgKey] ASC,
	[EmployeeSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimEmployee] ADD  CONSTRAINT [DF_DimEmployee_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
