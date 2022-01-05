/* CreateDate: 10/04/2010 12:08:45.200 , ModifyDate: 01/04/2022 10:56:36.813 */
GO
CREATE TABLE [dbo].[cfgVendorContact](
	[VendorContactID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VendorID] [int] NOT NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailMain] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAlternative] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactPhone] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactMobile] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactFax] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgVendorContact] PRIMARY KEY CLUSTERED
(
	[VendorContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgVendorContact_FirstName] ON [dbo].[cfgVendorContact]
(
	[FirstName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgVendorContact_LastName] ON [dbo].[cfgVendorContact]
(
	[LastName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgVendorContact] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgVendorContact]  WITH CHECK ADD  CONSTRAINT [FK_cfgVendorContact_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgVendorContact] CHECK CONSTRAINT [FK_cfgVendorContact_cfgVendor]
GO
