/* CreateDate: 02/19/2009 15:57:28.733 , ModifyDate: 12/07/2021 16:20:16.280 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgEmployeePositionJoin](
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[EmployeePositionID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsActiveFlag] [bit] NOT NULL,
 CONSTRAINT [PK_cfgEmployeePositionJoin] PRIMARY KEY CLUSTERED
(
	[EmployeeGUID] ASC,
	[EmployeePositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_cfgEmployeePositionJoin_EmployeePositionID_IsActiveFlag_EmployeeGUID] ON [dbo].[cfgEmployeePositionJoin]
(
	[EmployeePositionID] ASC,
	[IsActiveFlag] DESC,
	[EmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgEmployeePositionJoin] ADD  CONSTRAINT [DF_cfgEmployeePositionJoin_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgEmployeePositionJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgEmployeePositionJoin_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[cfgEmployeePositionJoin] CHECK CONSTRAINT [FK_cfgEmployeePositionJoin_datEmployee]
GO
ALTER TABLE [dbo].[cfgEmployeePositionJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgEmployeePositionJoin_lkpEmployeePosition] FOREIGN KEY([EmployeePositionID])
REFERENCES [dbo].[lkpEmployeePosition] ([EmployeePositionID])
GO
ALTER TABLE [dbo].[cfgEmployeePositionJoin] CHECK CONSTRAINT [FK_cfgEmployeePositionJoin_lkpEmployeePosition]
GO
