/* CreateDate: 08/27/2012 08:40:09.563 , ModifyDate: 05/26/2020 10:49:17.923 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationFilterColor](
	[HairSystemAllocationFilterColorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VendorID] [int] NOT NULL,
	[HairSystemHairColorID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemAllocationFilterColor] PRIMARY KEY CLUSTERED
(
	[HairSystemAllocationFilterColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterColor]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemAllocationFilterColor_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterColor] CHECK CONSTRAINT [FK_cfgHairSystemAllocationFilterColor_cfgVendor]
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterColor]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemAllocationFilterColor_lkpHairSystemHairColor] FOREIGN KEY([HairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterColor] CHECK CONSTRAINT [FK_cfgHairSystemAllocationFilterColor_lkpHairSystemHairColor]
GO
