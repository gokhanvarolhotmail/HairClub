/* CreateDate: 08/29/2016 07:25:09.420 , ModifyDate: 03/04/2022 16:09:12.783 */
GO
CREATE TABLE [dbo].[lkpHairSystemCurlGroup](
	[HairSystemCurlGroupID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemCurlGroupSortOrder] [int] NOT NULL,
	[HairSystemCurlGroupDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemCurlGroupDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemCurlGroup] PRIMARY KEY CLUSTERED
(
	[HairSystemCurlGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
