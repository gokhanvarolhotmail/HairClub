/* CreateDate: 06/08/2020 17:05:13.213 , ModifyDate: 06/08/2020 17:22:48.273 */
GO
CREATE TABLE [dbo].[tmpNobleCallDataTest](
	[appl] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceTask] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNISLead] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InbCtr] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[call_date] [datetime] NULL,
	[call_time] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ani_acode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ani_phone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tsr] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ani_country_id] [float] NULL,
	[time_connect] [float] NULL,
	[time_acwork] [float] NULL,
	[status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[addi_status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[time_holding] [float] NULL,
	[d_record_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_tmpNobleCallDataTest_call_date] ON [dbo].[tmpNobleCallDataTest]
(
	[call_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
