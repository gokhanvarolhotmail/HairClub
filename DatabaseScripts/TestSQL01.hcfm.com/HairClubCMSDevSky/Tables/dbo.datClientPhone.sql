/* CreateDate: 05/21/2017 22:04:30.363 , ModifyDate: 12/29/2021 15:38:46.177 */
GO
CREATE TABLE [dbo].[datClientPhone](
	[ClientPhoneID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[PhoneTypeID] [int] NOT NULL,
	[PhoneNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanConfirmAppointmentByCall] [bit] NULL,
	[CanConfirmAppointmentByText] [bit] NULL,
	[CanContactForPromotionsByCall] [bit] NULL,
	[CanContactForPromotionsByText] [bit] NULL,
	[ClientPhoneSortOrder] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datClientPhone] PRIMARY KEY CLUSTERED
(
	[ClientPhoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClientPhone] ON [dbo].[datClientPhone]
(
	[PhoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NC_datClientPhone_ClientGUID] ON [dbo].[datClientPhone]
(
	[ClientGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientPhone]  WITH CHECK ADD  CONSTRAINT [FK_datClientPhone_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientPhone] CHECK CONSTRAINT [FK_datClientPhone_datClient]
GO
ALTER TABLE [dbo].[datClientPhone]  WITH CHECK ADD  CONSTRAINT [FK_datClientPhone_lkpPhoneType] FOREIGN KEY([PhoneTypeID])
REFERENCES [dbo].[lkpPhoneType] ([PhoneTypeID])
GO
ALTER TABLE [dbo].[datClientPhone] CHECK CONSTRAINT [FK_datClientPhone_lkpPhoneType]
GO
