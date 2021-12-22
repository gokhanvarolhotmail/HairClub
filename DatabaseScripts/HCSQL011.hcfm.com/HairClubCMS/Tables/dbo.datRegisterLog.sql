/* CreateDate: 02/18/2013 06:59:50.513 , ModifyDate: 06/12/2020 08:58:43.267 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datRegisterLog](
	[RegisterLogGUID] [uniqueidentifier] NOT NULL,
	[RegisterID] [int] NOT NULL,
	[EndOfDayGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[OpeningBalance] [money] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datRegisterLog] PRIMARY KEY CLUSTERED
(
	[RegisterLogGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datRegisterLog_EndOfDayGUID] ON [dbo].[datRegisterLog]
(
	[EndOfDayGUID] ASC
)
INCLUDE([RegisterLogGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [NK_datRegisterLog] ON [dbo].[datRegisterLog]
(
	[RegisterID] ASC,
	[EndOfDayGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datRegisterLog]  WITH CHECK ADD  CONSTRAINT [FK_datRegisterLog_cfgRegister] FOREIGN KEY([RegisterID])
REFERENCES [dbo].[cfgRegister] ([RegisterID])
GO
ALTER TABLE [dbo].[datRegisterLog] CHECK CONSTRAINT [FK_datRegisterLog_cfgRegister]
GO
ALTER TABLE [dbo].[datRegisterLog]  WITH CHECK ADD  CONSTRAINT [FK_datRegisterLog_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datRegisterLog] CHECK CONSTRAINT [FK_datRegisterLog_datEmployee]
GO
ALTER TABLE [dbo].[datRegisterLog]  WITH CHECK ADD  CONSTRAINT [FK_datRegisterLog_datEndOfDay] FOREIGN KEY([EndOfDayGUID])
REFERENCES [dbo].[datEndOfDay] ([EndOfDayGUID])
GO
ALTER TABLE [dbo].[datRegisterLog] CHECK CONSTRAINT [FK_datRegisterLog_datEndOfDay]
GO
