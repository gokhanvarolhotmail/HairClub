/* CreateDate: 10/31/2019 20:53:42.510 , ModifyDate: 11/01/2019 09:57:48.977 */
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationFilterHairLength](
	[HairSystemAllocationFilterHairLengthID] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NOT NULL,
	[HairSystemHairLengthID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
