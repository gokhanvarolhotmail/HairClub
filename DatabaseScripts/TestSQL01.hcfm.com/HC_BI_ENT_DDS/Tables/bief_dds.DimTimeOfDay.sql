/* CreateDate: 05/03/2010 12:08:47.477 , ModifyDate: 09/16/2019 09:25:18.263 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bief_dds].[DimTimeOfDay](
	[TimeOfDayKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Time] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Time24] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hour] [smallint] NULL,
	[HourName] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Minute] [smallint] NULL,
	[MinuteKey] [smallint] NULL,
	[MinuteName] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Second] [smallint] NULL,
	[Hour24] [smallint] NULL,
	[AM] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimTimeOfDay] PRIMARY KEY CLUSTERED
(
	[TimeOfDayKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bief_dds].[DimTimeOfDay] ADD  CONSTRAINT [MSrepl_tran_version_default_0229C83F_EAB4_4907_A67E_1BBD75E3618D_2121058592]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
