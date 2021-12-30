/* CreateDate: 05/05/2020 17:42:41.170 , ModifyDate: 05/05/2020 17:42:59.890 */
GO
CREATE TABLE [dbo].[cfgCenterTrichoView](
	[CenterTrichoViewID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[IsProfileAvailable] [bit] NOT NULL,
	[IsScalpAvailable] [bit] NOT NULL,
	[IsScopeAvailable] [bit] NOT NULL,
	[IsDensityAvailable] [bit] NOT NULL,
	[IsWidthAvailable] [bit] NOT NULL,
	[IsScaleAvailable] [bit] NOT NULL,
	[IsHealthAvailable] [bit] NOT NULL,
	[IsHMIAvailable] [bit] NOT NULL,
	[IsSurveyAvailable] [bit] NOT NULL,
	[IsTrichoViewReportAvailable] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsImageEditorAvailable] [bit] NOT NULL,
	[IsSebumAvailable] [bit] NOT NULL,
	[IsScalpHealthAvailable] [bit] NOT NULL,
	[IsHighResUploadAvailable] [bit] NOT NULL,
 CONSTRAINT [PK_cfgCenterTrichoView] PRIMARY KEY CLUSTERED
(
	[CenterTrichoViewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
