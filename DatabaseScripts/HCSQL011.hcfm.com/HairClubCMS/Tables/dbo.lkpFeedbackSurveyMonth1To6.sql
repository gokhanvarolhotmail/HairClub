/* CreateDate: 10/20/2014 07:53:40.333 , ModifyDate: 07/18/2016 07:45:55.863 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpFeedbackSurveyMonth1To6](
	[FeedbackSurveyMonth1To6ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FeedbackSurveyMonth1To6SortOrder] [int] NOT NULL,
	[FeedbackSurveyMonth1To6Description] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FeedbackSurveyMonth1To6DescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpFeedbackSurveyMonth1To6] PRIMARY KEY CLUSTERED
(
	[FeedbackSurveyMonth1To6ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
