/* CreateDate: 05/03/2010 12:17:22.980 , ModifyDate: 11/21/2019 15:17:45.300 */
GO
CREATE TABLE [bi_cms_dds].[DimAccumulator](
	[AccumulatorKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AccumulatorSSID] [int] NOT NULL,
	[AccumulatorDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorDataTypeSSID] [int] NOT NULL,
	[AccumulatorDataTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorDataTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SchedulerActionTypeSSID] [int] NOT NULL,
	[SchedulerActionTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SchedulerActionTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SchedulerAdjustmentTypeSSID] [int] NOT NULL,
	[SchedulerAdjustmentTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SchedulerAdjustmentTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimAccumulator] PRIMARY KEY CLUSTERED
(
	[AccumulatorKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_AccumulatorDataTypeSSID]  DEFAULT ((-2)) FOR [AccumulatorDataTypeSSID]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_AccumulatorDataTypeSSID1]  DEFAULT ((-2)) FOR [SchedulerActionTypeSSID]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_SchedulerActionTypeSSID1]  DEFAULT ((-2)) FOR [SchedulerAdjustmentTypeSSID]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulator] ADD  CONSTRAINT [MSrepl_tran_version_default_24A44229_0AC5_48BD_84D8_9D8041435179_21575115]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
