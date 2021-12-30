/* CreateDate: 05/05/2020 17:42:53.263 , ModifyDate: 11/07/2020 20:06:34.370 */
GO
CREATE TABLE [dbo].[datTechnicalProfileScalpPreparation](
	[TechnicalProfileScalpPreparationID] [int] NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[ScalpPreparationID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NOT NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_datTechnicalProfileScalpPreparation] ON [dbo].[datTechnicalProfileScalpPreparation]
(
	[TechnicalProfileScalpPreparationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datTechnicalProfileScalpPreparation_TechnicalProfileID] ON [dbo].[datTechnicalProfileScalpPreparation]
(
	[TechnicalProfileID] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
