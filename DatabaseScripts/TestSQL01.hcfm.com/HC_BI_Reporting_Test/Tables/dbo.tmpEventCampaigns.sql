/* CreateDate: 05/07/2020 15:53:12.860 , ModifyDate: 05/07/2020 16:59:52.793 */
GO
CREATE TABLE [dbo].[tmpEventCampaigns](
	[Campaign Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Campaign Type] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [bit] NOT NULL,
	[Start Date] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[End Date] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Campaign Status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceName (L)] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Channel] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Media] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Source Code] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Campaign ID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
