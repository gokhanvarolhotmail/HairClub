CREATE TABLE [bi_mktg_dds].[FactActivity](
	[ActivityDateKey] [int] NOT NULL,
	[ActivityKey] [int] NOT NULL,
	[ActivityTimeKey] [int] NOT NULL,
	[ActivityCompletedDateKey] [int] NOT NULL,
	[ActivityCompletedTimeKey] [int] NOT NULL,
	[ActivityDueDateKey] [int] NOT NULL,
	[ActivityStartTimeKey] [int] NOT NULL,
	[GenderKey] [int] NOT NULL,
	[EthnicityKey] [int] NOT NULL,
	[OccupationKey] [int] NOT NULL,
	[MaritalStatusKey] [int] NOT NULL,
	[AgeRangeKey] [int] NOT NULL,
	[HairLossTypeKey] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[ContactKey] [int] NOT NULL,
	[ActionCodeKey] [int] NOT NULL,
	[ResultCodeKey] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[ActivityTypeKey] [int] NOT NULL,
	[CompletedByEmployeeKey] [int] NOT NULL,
	[StartedByEmployeeKey] [int] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[ActivityEmployeeKey] [int] NULL,
 CONSTRAINT [PK_FactActivity] PRIMARY KEY CLUSTERED
(
	[ActivityDateKey] ASC,
	[ActivityKey] ASC,
	[ActivityTimeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
