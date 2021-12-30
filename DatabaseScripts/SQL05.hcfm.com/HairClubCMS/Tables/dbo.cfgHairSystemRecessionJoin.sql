/* CreateDate: 05/05/2020 17:42:43.850 , ModifyDate: 05/05/2020 17:43:02.363 */
GO
CREATE TABLE [dbo].[cfgHairSystemRecessionJoin](
	[HairSystemRecessionJoinID] [int] NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemRecessionID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemRecessionJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemRecessionJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
