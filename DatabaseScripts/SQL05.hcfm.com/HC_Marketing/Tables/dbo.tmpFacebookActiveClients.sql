/* CreateDate: 03/27/2018 14:03:00.847 , ModifyDate: 03/27/2018 14:09:35.927 */
GO
CREATE TABLE [dbo].[tmpFacebookActiveClients](
	[CenterName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber] [int] NULL,
	[ConsultationDate] [datetime] NOT NULL,
	[Membership] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TotalRevenue] [money] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tmpFacebookActiveClients_CenterNumber] ON [dbo].[tmpFacebookActiveClients]
(
	[CenterNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
