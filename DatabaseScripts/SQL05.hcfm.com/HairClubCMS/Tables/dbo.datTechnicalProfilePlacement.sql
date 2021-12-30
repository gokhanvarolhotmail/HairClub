/* CreateDate: 05/05/2020 17:42:53.147 , ModifyDate: 05/05/2020 18:28:46.743 */
GO
CREATE TABLE [dbo].[datTechnicalProfilePlacement](
	[TechnicalProfilePlacementID] [int] NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[ScalpRegionID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfilePlacement] PRIMARY KEY CLUSTERED
(
	[TechnicalProfilePlacementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [UK_datTechnicalProfilePlacement_TechnicalProfileID_ScalpRegionID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC,
	[ScalpRegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
