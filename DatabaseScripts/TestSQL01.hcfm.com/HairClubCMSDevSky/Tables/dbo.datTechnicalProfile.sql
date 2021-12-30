/* CreateDate: 02/26/2017 22:35:10.313 , ModifyDate: 12/29/2021 15:38:46.467 */
GO
CREATE TABLE [dbo].[datTechnicalProfile](
	[TechnicalProfileID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileDate] [datetime] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[Notes] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfile] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datTechnicalProfile_ClientGUID] ON [dbo].[datTechnicalProfile]
(
	[ClientGUID] ASC
)
INCLUDE([TechnicalProfileID],[TechnicalProfileDate],[EmployeeGUID],[SalesOrderGUID],[Notes],[LastUpdateUser]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datTechnicalProfile_ClientGUID_TechnicalProfileDate] ON [dbo].[datTechnicalProfile]
(
	[ClientGUID] ASC,
	[TechnicalProfileDate] DESC
)
INCLUDE([TechnicalProfileID],[EmployeeGUID],[SalesOrderGUID],[Notes],[LastUpdateUser]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfile]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfile_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datTechnicalProfile] CHECK CONSTRAINT [FK_datTechnicalProfile_datClient]
GO
ALTER TABLE [dbo].[datTechnicalProfile]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfile_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datTechnicalProfile] CHECK CONSTRAINT [FK_datTechnicalProfile_datEmployee]
GO
ALTER TABLE [dbo].[datTechnicalProfile]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfile_datSalesOrder] FOREIGN KEY([SalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datTechnicalProfile] CHECK CONSTRAINT [FK_datTechnicalProfile_datSalesOrder]
GO
