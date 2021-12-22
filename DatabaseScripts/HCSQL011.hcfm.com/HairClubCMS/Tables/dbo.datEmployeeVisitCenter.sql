/* CreateDate: 07/15/2008 12:59:04.427 , ModifyDate: 05/26/2020 10:49:42.507 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datEmployeeVisitCenter](
	[EmployeeCenterGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datEmployeeCenter] PRIMARY KEY CLUSTERED
(
	[EmployeeCenterGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datEmployeeVisitCenter]  WITH CHECK ADD  CONSTRAINT [FK_datEmployeeCenter_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datEmployeeVisitCenter] CHECK CONSTRAINT [FK_datEmployeeCenter_cfgCenter]
GO
ALTER TABLE [dbo].[datEmployeeVisitCenter]  WITH CHECK ADD  CONSTRAINT [FK_datEmployeeCenter_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datEmployeeVisitCenter] CHECK CONSTRAINT [FK_datEmployeeCenter_datEmployee]
GO
