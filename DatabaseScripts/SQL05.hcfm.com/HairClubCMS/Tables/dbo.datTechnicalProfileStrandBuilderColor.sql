/* CreateDate: 05/05/2020 17:42:53.360 , ModifyDate: 05/05/2020 18:28:46.903 */
GO
CREATE TABLE [dbo].[datTechnicalProfileStrandBuilderColor](
	[TechnicalProfileStrandBuilderColorID] [int] NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[StrandBuilderColorID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfileStrandBuilderColor] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileStrandBuilderColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [UK_datTechnicalProfileStrandBuilderColor_TechnicalProfileID_StrandBuilderColorID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC,
	[StrandBuilderColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
