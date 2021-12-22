/* CreateDate: 05/03/2010 12:08:47.817 , ModifyDate: 09/16/2019 09:25:18.163 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_ent_dds].[DimTimeZone](
	[TimeZoneKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TimeZoneSSID] [int] NOT NULL,
	[TimeZoneDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeZoneDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UTCOffset] [int] NULL,
	[UsesDayLightSavingsFlag] [bit] NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimTimeZone] PRIMARY KEY CLUSTERED
(
	[TimeZoneKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimTimeZone_RowIsCurrent_TimeZoneSSID_TimeZoneKey] ON [bi_ent_dds].[DimTimeZone]
(
	[TimeZoneSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([TimeZoneKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_dds].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_UsesDayLightSavingsFlag]  DEFAULT ((1)) FOR [UsesDayLightSavingsFlag]
GO
ALTER TABLE [bi_ent_dds].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_ent_dds].[DimTimeZone] ADD  CONSTRAINT [MSrepl_tran_version_default_52565760_C871_4620_B435_A277F8101726_341576255]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
