/* CreateDate: 07/11/2012 14:00:38.080 , ModifyDate: 07/11/2012 14:00:38.080 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_ent_dds].[DimBroadcastDate-save](
	[DateKey] [int] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[Year] [int] NOT NULL,
	[Quarter] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[MonthName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Week] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[BroadcastYearBroadcastQuarter] [int] NULL,
	[BroadcastYearBroadcastMonth] [int] NULL,
	[BroadcastYearBroadcastWeek] [int] NULL,
	[BroadcastYearQtrMonthWeekDay] [bigint] NULL,
	[BroadcastYearQtrMonth] [int] NULL,
	[BroadcastYearShortName] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BroadcastYearLongName] [varchar](19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BroadcastYeartName] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BroadcastQuarterName] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BroadcastWeekName] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BroadcastDayName] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL
) ON [FG1]
GO
