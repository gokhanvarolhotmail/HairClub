/* CreateDate: 06/11/2014 08:04:32.647 , ModifyDate: 10/28/2015 10:42:59.680 */
GO
CREATE TABLE [dbo].[datWaitingListEmployee](
	[WaitingListEmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[WaitingListID] [int] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datWaitingListEmployee] PRIMARY KEY CLUSTERED
(
	[WaitingListEmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datWaitingListEmployee_WaitingListID] ON [dbo].[datWaitingListEmployee]
(
	[WaitingListID] DESC
)
INCLUDE([WaitingListEmployeeID],[EmployeeGUID],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datWaitingListEmployee]  WITH NOCHECK ADD  CONSTRAINT [FK_datWaitingListEmployee_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datWaitingListEmployee] CHECK CONSTRAINT [FK_datWaitingListEmployee_datEmployee]
GO
ALTER TABLE [dbo].[datWaitingListEmployee]  WITH NOCHECK ADD  CONSTRAINT [FK_datWaitingListEmployee_datWaitingList] FOREIGN KEY([WaitingListID])
REFERENCES [dbo].[datWaitingList] ([WaitingListID])
GO
ALTER TABLE [dbo].[datWaitingListEmployee] CHECK CONSTRAINT [FK_datWaitingListEmployee_datWaitingList]
GO
