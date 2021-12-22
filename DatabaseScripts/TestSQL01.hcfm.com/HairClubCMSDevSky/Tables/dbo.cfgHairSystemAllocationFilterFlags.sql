/* CreateDate: 05/12/2019 23:17:23.000 , ModifyDate: 05/04/2020 10:41:16.367 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationFilterFlags](
	[HairSystemAllocationFilterFlagsID] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NOT NULL,
	[AllowSignatureHairline] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[AllowCuticleIntactHair] [bit] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemAllocationFilterFlags] PRIMARY KEY CLUSTERED
(
	[HairSystemAllocationFilterFlagsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_VendorID] UNIQUE NONCLUSTERED
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
