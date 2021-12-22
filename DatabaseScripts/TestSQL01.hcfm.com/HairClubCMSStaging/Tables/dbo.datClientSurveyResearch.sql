/* CreateDate: 10/20/2014 07:50:33.883 , ModifyDate: 10/20/2014 07:50:34.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datClientSurveyResearch](
	[ClientSurveyResearchID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientSurveyID] [int] NOT NULL,
	[lkpClientSurveyResearchID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientSurveyResearch] PRIMARY KEY CLUSTERED
(
	[ClientSurveyResearchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientSurveyResearch]  WITH CHECK ADD  CONSTRAINT [FK_datClientSurveyResearch_datClientSurvey] FOREIGN KEY([ClientSurveyID])
REFERENCES [dbo].[datClientSurvey] ([ClientSurveyID])
GO
ALTER TABLE [dbo].[datClientSurveyResearch] CHECK CONSTRAINT [FK_datClientSurveyResearch_datClientSurvey]
GO
ALTER TABLE [dbo].[datClientSurveyResearch]  WITH CHECK ADD  CONSTRAINT [FK_datClientSurveyResearch_lkpClientSurveyResearch] FOREIGN KEY([lkpClientSurveyResearchID])
REFERENCES [dbo].[lkpClientSurveyResearch] ([ClientSurveyResearchID])
GO
ALTER TABLE [dbo].[datClientSurveyResearch] CHECK CONSTRAINT [FK_datClientSurveyResearch_lkpClientSurveyResearch]
GO
