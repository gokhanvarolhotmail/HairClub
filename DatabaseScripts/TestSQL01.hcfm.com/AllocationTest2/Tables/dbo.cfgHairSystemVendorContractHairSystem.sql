/* CreateDate: 10/31/2019 20:53:42.557 , ModifyDate: 11/01/2019 09:57:48.980 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContractHairSystem](
	[HairSystemVendorContractHairSystemID] [int] IDENTITY(1,1) NOT NULL,
	[HairSystemVendorContractID] [int] NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
