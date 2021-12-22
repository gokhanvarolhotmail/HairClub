/* CreateDate: 06/11/2014 08:04:32.537 , ModifyDate: 10/28/2015 10:43:03.967 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datWaitingListDetail](
	[WaitingListDetailID] [int] IDENTITY(1,1) NOT NULL,
	[WaitingListID] [int] NOT NULL,
	[SalesCodeID] [int] NOT NULL,
	[ServiceDuration] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datWaitingListDetail] PRIMARY KEY CLUSTERED
(
	[WaitingListDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datWaitingListDetail_WaitingListID] ON [dbo].[datWaitingListDetail]
(
	[WaitingListID] DESC
)
INCLUDE([WaitingListDetailID],[SalesCodeID],[ServiceDuration],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datWaitingListDetail]  WITH CHECK ADD  CONSTRAINT [FK_datWaitingListDetail_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datWaitingListDetail] CHECK CONSTRAINT [FK_datWaitingListDetail_cfgSalesCode]
GO
ALTER TABLE [dbo].[datWaitingListDetail]  WITH CHECK ADD  CONSTRAINT [FK_datWaitingListDetail_datWaitingList] FOREIGN KEY([WaitingListID])
REFERENCES [dbo].[datWaitingList] ([WaitingListID])
GO
ALTER TABLE [dbo].[datWaitingListDetail] CHECK CONSTRAINT [FK_datWaitingListDetail_datWaitingList]
GO
