CREATE TABLE [dbo].[datEmployeeCenter](
	[EmployeeCenterGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[SequenceNumber] [int] NOT NULL,
 CONSTRAINT [PK_datEmployeeCenter2] PRIMARY KEY NONCLUSTERED
(
	[EmployeeCenterGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datEmployeeCenter] UNIQUE CLUSTERED
(
	[EmployeeGUID] ASC,
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datEmployeeCenter_CenterID] ON [dbo].[datEmployeeCenter]
(
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datEmployeeCenter_IsActiveFlag_CenterID] ON [dbo].[datEmployeeCenter]
(
	[IsActiveFlag] ASC,
	[CenterID] ASC
)
INCLUDE([EmployeeGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datEmployeeCenter_IsActiveFlag_EmployeeGUID_CenterID] ON [dbo].[datEmployeeCenter]
(
	[IsActiveFlag] DESC
)
INCLUDE([EmployeeGUID],[CenterID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datEmployeeCenter] ADD  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[datEmployeeCenter] ADD  DEFAULT ((1)) FOR [SequenceNumber]
GO
ALTER TABLE [dbo].[datEmployeeCenter]  WITH CHECK ADD  CONSTRAINT [FK_datEmployeeCenter_cfgCenter2] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datEmployeeCenter] CHECK CONSTRAINT [FK_datEmployeeCenter_cfgCenter2]
GO
ALTER TABLE [dbo].[datEmployeeCenter]  WITH CHECK ADD  CONSTRAINT [FK_datEmployeeCenter_datEmployee2] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datEmployeeCenter] CHECK CONSTRAINT [FK_datEmployeeCenter_datEmployee2]
