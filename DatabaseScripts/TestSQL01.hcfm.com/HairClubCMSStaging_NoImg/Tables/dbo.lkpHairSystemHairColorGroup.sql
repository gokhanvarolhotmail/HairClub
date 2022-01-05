/* CreateDate: 08/29/2016 07:24:23.957 , ModifyDate: 01/04/2022 10:56:36.843 */
GO
CREATE TABLE [dbo].[lkpHairSystemHairColorGroup](
	[HairSystemHairColorGroupID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemHairColorGroupSortOrder] [int] NOT NULL,
	[HairSystemHairColorGroupDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHairColorGroupDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemHairColorGroup] PRIMARY KEY CLUSTERED
(
	[HairSystemHairColorGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
