/* CreateDate: 05/05/2020 17:42:43.273 , ModifyDate: 05/05/2020 17:43:01.900 */
GO
CREATE TABLE [dbo].[cfgHairSystemHairLengthJoin](
	[HairSystemHairLengthJoinID] [int] NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemHairLengthID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemHairLengthJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemHairLengthJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
