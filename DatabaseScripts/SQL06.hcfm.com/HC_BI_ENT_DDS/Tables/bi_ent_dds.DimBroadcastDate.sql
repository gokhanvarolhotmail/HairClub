CREATE TABLE [bi_ent_dds].[DimBroadcastDate](
	[DateKey] [int] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[Year] [int] NOT NULL,
	[Quarter] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[MonthName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Week] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[BroadcastYearBroadcastQuarter]  AS (CONVERT([int],CONVERT([varchar](4),[Year],(0))+right('00'+CONVERT([varchar](2),[Quarter],(0)),(2)),(0))) PERSISTED,
	[BroadcastYearBroadcastMonth]  AS (CONVERT([int],CONVERT([varchar](4),[Year],(0))+right('00'+CONVERT([varchar](2),[Month],(0)),(2)),(0))) PERSISTED,
	[BroadcastYearBroadcastWeek]  AS (CONVERT([int],(CONVERT([varchar](4),[Year],(0))+right('00'+CONVERT([varchar](2),[Month],(0)),(2)))+right('00'+CONVERT([varchar](2),[Week],(0)),(2)),(0))) PERSISTED,
	[BroadcastYearQtrMonthWeekDay]  AS (CONVERT([bigint],(((CONVERT([varchar](4),[Year],(0))+right('00'+CONVERT([varchar](2),[Quarter],(0)),(2)))+right('00'+CONVERT([varchar](2),[Month],(0)),(2)))+right('00'+CONVERT([varchar](2),[Week],(0)),(2)))+right('00'+CONVERT([varchar](2),[Day],(0)),(2)),(0))) PERSISTED,
	[BroadcastYearQtrMonth]  AS (CONVERT([int],(CONVERT([varchar](4),[Year],(0))+right('00'+CONVERT([varchar](2),[Quarter],(0)),(2)))+right('00'+CONVERT([varchar](2),[Month],(0)),(2)),(0))) PERSISTED,
	[BroadcastYearShortName]  AS ('BCY '+right('0000'+CONVERT([varchar](4),[Year],(0)),(4))) PERSISTED,
	[BroadcastYearLongName]  AS ('Broadcast Year '+right('0000'+CONVERT([varchar](4),[Year],(0)),(4))) PERSISTED,
	[BroadcastYeartName]  AS ('BCY '+right('0000'+CONVERT([varchar](4),[Year],(0)),(4))) PERSISTED,
	[BroadcastQuarterName]  AS ((('BCQ'+CONVERT([char](1),[Quarter],(0)))+', ')+right('0000'+CONVERT([varchar](4),[Year],(0)),(4))) PERSISTED,
	[BroadcastWeekName]  AS ('BCWeek '+CONVERT([char](1),[Week],(0))) PERSISTED,
	[BroadcastDayName]  AS ('BCDay '+right('0 '+CONVERT([varchar](2),[Day],(0)),(2))) PERSISTED,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Dates_Broadcast] PRIMARY KEY CLUSTERED
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
