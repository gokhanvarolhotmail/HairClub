/* CreateDate: 06/03/2014 08:34:30.943 , ModifyDate: 12/07/2021 16:20:15.920 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgCenterTrichoView](
	[CenterTrichoViewID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterTrichoView] ADD  DEFAULT ((0)) FOR [IsImageEditorAvailable]
GO
ALTER TABLE [dbo].[cfgCenterTrichoView] ADD  DEFAULT ((0)) FOR [IsSebumAvailable]
GO
ALTER TABLE [dbo].[cfgCenterTrichoView] ADD  DEFAULT ((0)) FOR [IsScalpHealthAvailable]
GO
ALTER TABLE [dbo].[cfgCenterTrichoView] ADD  DEFAULT ((0)) FOR [IsHighResUploadAvailable]
GO
ALTER TABLE [dbo].[cfgCenterTrichoView]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterTrichoView_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenterTrichoView] CHECK CONSTRAINT [FK_cfgCenterTrichoView_cfgCenter]
GO
