/* CreateDate: 02/18/2013 06:59:17.780 , ModifyDate: 12/03/2021 10:24:48.590 */
GO
CREATE TABLE [dbo].[datEndOfDay](
	[EndOfDayGUID] [uniqueidentifier] NOT NULL,
	[EndOfDayDate] [datetime] NOT NULL,
	[CenterID] [int] NOT NULL,
	[DepositID_Temp] [int] NULL,
	[DepositNumber] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[CloseDate] [datetime] NULL,
	[IsExportedToQuickBooks] [bit] NULL,
	[CloseNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datEndOfDay] PRIMARY KEY CLUSTERED
(
	[EndOfDayGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datEndOfDay_EndOfDayDate_CenterID] ON [dbo].[datEndOfDay]
(
	[EndOfDayDate] DESC,
	[CenterID] ASC
)
INCLUDE([DepositNumber],[EmployeeGUID],[CloseDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datEndOfDay]  WITH NOCHECK ADD  CONSTRAINT [FK_datEndOfDay_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datEndOfDay] CHECK CONSTRAINT [FK_datEndOfDay_cfgCenter]
GO
ALTER TABLE [dbo].[datEndOfDay]  WITH NOCHECK ADD  CONSTRAINT [FK_datEndOfDay_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datEndOfDay] CHECK CONSTRAINT [FK_datEndOfDay_datEmployee]
GO
