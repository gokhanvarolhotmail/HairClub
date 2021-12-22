CREATE TABLE [dbo].[lkpDaylightSavings](
	[DaylightSavingsID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Year] [int] NOT NULL,
	[DSTStartDate] [datetime] NOT NULL,
	[DSTEndDate] [datetime] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpDaylightSavings] PRIMARY KEY CLUSTERED
(
	[DaylightSavingsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_lkpDaylightSavings_Year] ON [dbo].[lkpDaylightSavings]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpDaylightSavings] ADD  CONSTRAINT [DF_lkpDaylightSavings_CreateDate]  DEFAULT (getutcdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[lkpDaylightSavings] ADD  CONSTRAINT [DF_lkpDaylightSavings_LastUpdate]  DEFAULT (getutcdate()) FOR [LastUpdate]
