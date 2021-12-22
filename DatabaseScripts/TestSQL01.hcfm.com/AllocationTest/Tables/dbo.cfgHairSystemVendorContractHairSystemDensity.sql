/* CreateDate: 11/01/2019 09:34:53.390 , ModifyDate: 11/01/2019 09:34:53.390 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContractHairSystemDensity](
	[HairSystemVendorContractHairSystemDensityID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemVendorContractID] [int] NOT NULL,
	[HairSystemDensityID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemVendorContractHairSystemDensity] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorContractHairSystemDensityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
