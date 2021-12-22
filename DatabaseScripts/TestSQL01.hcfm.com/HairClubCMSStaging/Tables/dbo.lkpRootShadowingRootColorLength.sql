/* CreateDate: 05/04/2020 10:31:21.770 , ModifyDate: 05/04/2020 10:37:53.963 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpRootShadowingRootColorLength](
	[RootShadowingRootColorLengthID] [int] IDENTITY(1,1) NOT NULL,
	[RootShadowingRootColorLengthSortOrder] [int] NOT NULL,
	[RootShadowingRootColorLengthDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RootShadowingRootColorLengthDescriptionShort] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RootShadowingRootColorLengthValue] [decimal](10, 5) NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpRootShadowingRootColorLength] PRIMARY KEY CLUSTERED
(
	[RootShadowingRootColorLengthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
