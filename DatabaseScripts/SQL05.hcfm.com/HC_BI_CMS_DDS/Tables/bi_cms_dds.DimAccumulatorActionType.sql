/* CreateDate: 05/03/2010 12:17:22.997 , ModifyDate: 03/17/2022 11:56:40.613 */
GO
CREATE TABLE [bi_cms_dds].[DimAccumulatorActionType](
	[AccumulatorActionTypeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AccumulatorActionTypeSSID] [int] NOT NULL,
	[AccumulatorActionTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorActionTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimAccumulatorActionType] PRIMARY KEY CLUSTERED
(
	[AccumulatorActionTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulatorActionType] ADD  CONSTRAINT [MSrepl_tran_version_default_F3A3B667_8830_467A_9B0E_FD2A5BF2B9A0_37575172]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
