/* CreateDate: 10/04/2010 12:08:45.350 , ModifyDate: 05/26/2020 10:49:28.393 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationFilterCurl](
	[HairSystemAllocationFilterCurlID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VendorID] [int] NOT NULL,
	[HairSystemCurlID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemAllocationFilterCurl] PRIMARY KEY CLUSTERED
(
	[HairSystemAllocationFilterCurlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterCurl]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemAllocationFilterCurl_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterCurl] CHECK CONSTRAINT [FK_cfgHairSystemAllocationFilterCurl_cfgVendor]
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterCurl]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemAllocationFilterCurl_lkpHairSystemCurl] FOREIGN KEY([HairSystemCurlID])
REFERENCES [dbo].[lkpHairSystemCurl] ([HairSystemCurlID])
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterCurl] CHECK CONSTRAINT [FK_cfgHairSystemAllocationFilterCurl_lkpHairSystemCurl]
GO
