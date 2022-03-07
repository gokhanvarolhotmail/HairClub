/* CreateDate: 03/03/2022 13:53:56.420 , ModifyDate: 03/05/2022 13:04:16.603 */
GO
CREATE TABLE [SF].[OpportunityLineItemSchedule](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OpportunityLineItemId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Revenue] [decimal](16, 2) NULL,
	[Quantity] [decimal](16, 2) NULL,
	[Description] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScheduleDate] [date] NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [pk_OpportunityLineItemSchedule] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[OpportunityLineItemSchedule]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[OpportunityLineItemSchedule]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
