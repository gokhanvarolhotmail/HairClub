/* CreateDate: 10/31/2019 20:53:42.460 , ModifyDate: 11/01/2019 09:57:48.970 */
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationFilterCurl](
	[HairSystemAllocationFilterCurlID] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NOT NULL,
	[HairSystemCurlID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
