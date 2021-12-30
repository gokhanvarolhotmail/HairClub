/* CreateDate: 05/05/2020 17:42:44.050 , ModifyDate: 05/05/2020 18:28:04.810 */
GO
CREATE TABLE [dbo].[cfgHairSystemSubstitute](
	[HairSystemSubstituteID] [int] NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[SubstituteHairSystemID] [int] NOT NULL,
	[Rank] [int] NOT NULL,
	[Comments] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemSubstitute] PRIMARY KEY CLUSTERED
(
	[HairSystemSubstituteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [UK_cfgHairSystemSubstitute_HairSystemID_SubstituteHairSystemID] UNIQUE NONCLUSTERED
(
	[HairSystemID] ASC,
	[SubstituteHairSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
