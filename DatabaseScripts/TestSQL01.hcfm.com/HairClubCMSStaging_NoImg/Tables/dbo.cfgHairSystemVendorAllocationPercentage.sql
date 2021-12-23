/* CreateDate: 10/04/2010 12:08:45.230 , ModifyDate: 12/03/2021 10:24:48.613 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorAllocationPercentage](
	[HairSystemVendorAllocationPercentageID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VendorID] [int] NOT NULL,
	[AllocationPercent] [decimal](6, 5) NULL,
	[IsContractPriceActive] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemVendorAllocationPercentage] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorAllocationPercentageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorAllocationPercentage] ADD  DEFAULT ((1)) FOR [IsContractPriceActive]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorAllocationPercentage]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorAllocationPercentage_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorAllocationPercentage] CHECK CONSTRAINT [FK_cfgHairSystemVendorAllocationPercentage_cfgVendor]
GO
