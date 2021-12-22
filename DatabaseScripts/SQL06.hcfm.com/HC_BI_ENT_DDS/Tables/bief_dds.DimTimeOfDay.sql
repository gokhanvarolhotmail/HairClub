/* CreateDate: 01/08/2021 15:21:54.073 , ModifyDate: 01/08/2021 15:21:55.537 */
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
