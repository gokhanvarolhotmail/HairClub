/* CreateDate: 04/05/2013 08:36:55.123 , ModifyDate: 10/03/2019 22:32:03.477 */
GO
CREATE TABLE [dbo].[FactReceivables](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterKey] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[Balance] [float] NULL,
	[PrePaid] [money] NULL,
PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactReceivables_CtrDateClient] ON [dbo].[FactReceivables]
(
	[CenterKey] ASC,
	[DateKey] ASC,
	[ClientKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO