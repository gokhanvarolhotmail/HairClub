/* CreateDate: 10/04/2010 12:08:45.320 , ModifyDate: 12/07/2021 16:20:16.040 */
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationFilterHairLength](
	[HairSystemAllocationFilterHairLengthID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VendorID] [int] NOT NULL,
	[HairSystemHairLengthID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemAllocationFilterHairLength] PRIMARY KEY CLUSTERED
(
	[HairSystemAllocationFilterHairLengthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterHairLength]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemAllocationFilterHairLength_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterHairLength] CHECK CONSTRAINT [FK_cfgHairSystemAllocationFilterHairLength_cfgVendor]
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterHairLength]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemAllocationFilterHairLength_lkpHairSystemHairLength] FOREIGN KEY([HairSystemHairLengthID])
REFERENCES [dbo].[lkpHairSystemHairLength] ([HairSystemHairLengthID])
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterHairLength] CHECK CONSTRAINT [FK_cfgHairSystemAllocationFilterHairLength_lkpHairSystemHairLength]
GO
