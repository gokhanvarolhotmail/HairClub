/* CreateDate: 05/05/2020 17:42:55.127 , ModifyDate: 05/05/2020 17:43:16.143 */
GO
CREATE TABLE [dbo].[lkpReportResourceImage](
	[ReportResourceImageID] [int] NOT NULL,
	[ReportResourceImageName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportResourceImage] [varbinary](max) NOT NULL,
	[NorwoodScaleID] [int] NULL,
	[LudwigScaleID] [int] NULL,
	[ScalpHealthID] [int] NULL,
	[ScalpRegionID] [int] NULL,
	[EthnicityID] [int] NULL,
	[GenderID] [int] NULL,
	[MimeType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SorenessLevelID] [int] NULL,
	[SebumLevelID] [int] NULL,
	[FlakingLevelID] [int] NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[RRImageCategory] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpReportResourceImage] PRIMARY KEY CLUSTERED
(
	[ReportResourceImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
