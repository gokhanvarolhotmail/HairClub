/* CreateDate: 10/20/2014 07:53:40.340 , ModifyDate: 07/18/2016 07:45:55.927 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpFeedbackSurveyMonth7Plus](
	[FeedbackSurveyMonth7PlusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FeedbackSurveyMonth7PlusSortOrder] [int] NOT NULL,
	[FeedbackSurveyMonth7PlusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FeedbackSurveyMonth7PlusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpFeedbackSurveyMonth7Plus] PRIMARY KEY CLUSTERED
(
	[FeedbackSurveyMonth7PlusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
