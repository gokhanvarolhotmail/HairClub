/* CreateDate: 02/03/2014 08:50:42.613 , ModifyDate: 12/03/2021 10:24:48.723 */
GO
CREATE TABLE [dbo].[datInterCompanyTransaction](
	[InterCompanyTransactionId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterId] [int] NOT NULL,
	[ClientHomeCenterId] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[IsClosed] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_datInterCompanyTransaction] PRIMARY KEY CLUSTERED
(
	[InterCompanyTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInterCompanyTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datInterCompanyTransaction_cfgCenter] FOREIGN KEY([CenterId])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datInterCompanyTransaction] CHECK CONSTRAINT [FK_datInterCompanyTransaction_cfgCenter]
GO
ALTER TABLE [dbo].[datInterCompanyTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datInterCompanyTransaction_cfgCenter1] FOREIGN KEY([ClientHomeCenterId])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datInterCompanyTransaction] CHECK CONSTRAINT [FK_datInterCompanyTransaction_cfgCenter1]
GO
ALTER TABLE [dbo].[datInterCompanyTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datInterCompanyTransaction_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datInterCompanyTransaction] CHECK CONSTRAINT [FK_datInterCompanyTransaction_datAppointment]
GO
ALTER TABLE [dbo].[datInterCompanyTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datInterCompanyTransaction_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datInterCompanyTransaction] CHECK CONSTRAINT [FK_datInterCompanyTransaction_datClient]
GO
ALTER TABLE [dbo].[datInterCompanyTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datInterCompanyTransaction_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datInterCompanyTransaction] CHECK CONSTRAINT [FK_datInterCompanyTransaction_datClientMembership]
GO
ALTER TABLE [dbo].[datInterCompanyTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datInterCompanyTransaction_datSalesOrder] FOREIGN KEY([SalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datInterCompanyTransaction] CHECK CONSTRAINT [FK_datInterCompanyTransaction_datSalesOrder]
GO
