/* CreateDate: 02/26/2017 22:35:10.240 , ModifyDate: 12/29/2021 15:38:46.453 */
GO
CREATE TABLE [dbo].[lkpHairStrandGroup](
	[HairStrandGroupID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairStrandGroupSortOrder] [int] NOT NULL,
	[HairStrandGroupDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairStrandGroupDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpHairStrandGroup] PRIMARY KEY CLUSTERED
(
	[HairStrandGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
