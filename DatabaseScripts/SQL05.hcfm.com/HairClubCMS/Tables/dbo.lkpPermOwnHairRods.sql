/* CreateDate: 05/05/2020 17:42:52.867 , ModifyDate: 05/05/2020 17:43:14.773 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
