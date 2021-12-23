/* CreateDate: 10/20/2014 07:50:33.870 , ModifyDate: 09/20/2018 05:43:39.283 */
GO
CREATE TABLE [dbo].[datClientSurveyAreaAffected](
	[ClientSurveyAreaAffectedID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientSurveyID] [int] NOT NULL,
	[lkpClientSurveyAreaAffectedID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientSurveyAreaAffected] PRIMARY KEY CLUSTERED
(
	[ClientSurveyAreaAffectedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientSurveyAreaAffected]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientSurveyAreaAffected_datClientSurvey] FOREIGN KEY([ClientSurveyID])
REFERENCES [dbo].[datClientSurvey] ([ClientSurveyID])
GO
ALTER TABLE [dbo].[datClientSurveyAreaAffected] CHECK CONSTRAINT [FK_datClientSurveyAreaAffected_datClientSurvey]
GO
ALTER TABLE [dbo].[datClientSurveyAreaAffected]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientSurveyAreaAffected_lkpClientSurveyAreaAffected] FOREIGN KEY([lkpClientSurveyAreaAffectedID])
REFERENCES [dbo].[lkpClientSurveyAreaAffected] ([ClientSurveyAreaAffectedID])
GO
ALTER TABLE [dbo].[datClientSurveyAreaAffected] CHECK CONSTRAINT [FK_datClientSurveyAreaAffected_lkpClientSurveyAreaAffected]
GO
