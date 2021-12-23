/* CreateDate: 05/14/2012 17:33:39.150 , ModifyDate: 12/03/2021 10:24:48.543 */
GO
CREATE TABLE [dbo].[datAccountReceivableJoin](
	[AccountReceivableJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ARChargeID] [int] NOT NULL,
	[ARPaymentID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datAccountReceivableJoin] PRIMARY KEY CLUSTERED
(
	[AccountReceivableJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountReceivableJoin_ARChargeID_ARPaymentID] ON [dbo].[datAccountReceivableJoin]
(
	[ARChargeID] DESC,
	[ARPaymentID] DESC
)
INCLUDE([AccountReceivableJoinID],[Amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAccountReceivableJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_datAccountReceivableJoin_datAccountReceivable] FOREIGN KEY([ARPaymentID])
REFERENCES [dbo].[datAccountReceivable] ([AccountReceivableID])
GO
ALTER TABLE [dbo].[datAccountReceivableJoin] CHECK CONSTRAINT [FK_datAccountReceivableJoin_datAccountReceivable]
GO
ALTER TABLE [dbo].[datAccountReceivableJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_datAccountReceivableJoin_datAccountReceivable1] FOREIGN KEY([ARChargeID])
REFERENCES [dbo].[datAccountReceivable] ([AccountReceivableID])
GO
ALTER TABLE [dbo].[datAccountReceivableJoin] CHECK CONSTRAINT [FK_datAccountReceivableJoin_datAccountReceivable1]
GO
