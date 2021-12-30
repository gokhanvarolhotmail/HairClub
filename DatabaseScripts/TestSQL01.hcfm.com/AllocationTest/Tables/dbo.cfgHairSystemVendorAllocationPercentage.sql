/* CreateDate: 11/01/2019 09:34:53.363 , ModifyDate: 11/01/2019 09:34:53.543 */
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
