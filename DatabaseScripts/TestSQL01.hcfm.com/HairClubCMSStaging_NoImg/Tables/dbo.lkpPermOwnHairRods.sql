/* CreateDate: 02/18/2013 06:40:48.923 , ModifyDate: 12/28/2021 09:20:54.553 */
GO
CREATE TABLE [dbo].[lkpPermOwnHairRods](
	[PermOwnHairRodsID] [int] NOT NULL,
	[PermOwnHairRodsSortOrder] [int] NOT NULL,
	[PermOwnHairRodsDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PermOwnHairRodsDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpPermOwnHairRods] PRIMARY KEY CLUSTERED
(
	[PermOwnHairRodsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
