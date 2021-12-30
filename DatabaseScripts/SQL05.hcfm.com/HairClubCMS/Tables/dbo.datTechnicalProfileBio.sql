/* CreateDate: 05/05/2020 17:42:52.347 , ModifyDate: 05/05/2020 18:28:46.470 */
GO
CREATE TABLE [dbo].[datTechnicalProfileBio](
	[TechnicalProfileBioID] [int] NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[HairSystemID] [int] NULL,
	[AdhesiveFront1ID] [int] NULL,
	[AdhesiveFront2ID] [int] NULL,
	[AdhesivePerimeter1ID] [int] NULL,
	[AdhesivePerimeter2ID] [int] NULL,
	[AdhesivePerimeter3ID] [int] NULL,
	[RemovalProcessID] [int] NULL,
	[AdhesiveSolventID] [int] NULL,
	[IsClientUsingOwnHairline] [bit] NULL,
	[DistanceHairlineToNose] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastTemplateDate] [datetime] NULL,
	[LastTrimDate] [datetime] NULL,
	[ApplicationDuration] [int] NULL,
	[ApplicationTimeUnitID] [int] NULL,
	[FullServiceDuration] [int] NULL,
	[FullServiceTimeUnitID] [int] NULL,
	[OtherServiceSalesCodeID] [int] NULL,
	[OtherServiceDuration] [int] NULL,
	[OtherServiceTimeUnitID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsHairOrderReviewRequired] [bit] NULL,
	[IsHairSystemColorRequired] [bit] NULL,
	[IsHairSystemHighlightRequired] [bit] NULL,
 CONSTRAINT [PK_datTechnicalProfileBio] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileBioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [UK_datTechnicalProfileBio_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
