/* CreateDate: 05/23/2016 16:21:51.960 , ModifyDate: 12/16/2019 08:36:41.580 */
GO
CREATE TABLE [dbo].[datClientReferral](
	[ClientReferralID] [int] IDENTITY(1,1) NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientReferredGUID] [uniqueidentifier] NOT NULL,
	[EnteredBy] [uniqueidentifier] NOT NULL,
	[Amount] [money] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[RequirementsMetDate] [date] NULL,
 CONSTRAINT [PK_datClientReferral] PRIMARY KEY CLUSTERED
(
	[ClientReferralID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datClientReferral_ClientGUID] UNIQUE NONCLUSTERED
(
	[ClientReferredGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientReferral]  WITH CHECK ADD  CONSTRAINT [FK_datClientReferral_datClient_ClientGUID] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientReferral] CHECK CONSTRAINT [FK_datClientReferral_datClient_ClientGUID]
GO
ALTER TABLE [dbo].[datClientReferral]  WITH CHECK ADD  CONSTRAINT [FK_datClientReferral_datClient_ClientReferredGUID] FOREIGN KEY([ClientReferredGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientReferral] CHECK CONSTRAINT [FK_datClientReferral_datClient_ClientReferredGUID]
GO
ALTER TABLE [dbo].[datClientReferral]  WITH CHECK ADD  CONSTRAINT [FK_datClientReferral_datEmployee] FOREIGN KEY([EnteredBy])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datClientReferral] CHECK CONSTRAINT [FK_datClientReferral_datEmployee]
GO
ALTER TABLE [dbo].[datClientReferral]  WITH CHECK ADD  CONSTRAINT [FK_datClientReferral_datEmployee_EmployeeGUID] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datClientReferral] CHECK CONSTRAINT [FK_datClientReferral_datEmployee_EmployeeGUID]
GO
