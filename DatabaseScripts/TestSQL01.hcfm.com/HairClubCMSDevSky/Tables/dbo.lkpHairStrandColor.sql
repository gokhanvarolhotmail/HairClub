/* CreateDate: 02/26/2017 22:35:10.277 , ModifyDate: 12/29/2021 15:38:46.463 */
GO
CREATE TABLE [dbo].[lkpHairStrandColor](
	[HairStrandColorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairStrandColorSortOrder] [int] NOT NULL,
	[HairStrandColorDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairStrandColorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpHairStrandColor] PRIMARY KEY CLUSTERED
(
	[HairStrandColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
