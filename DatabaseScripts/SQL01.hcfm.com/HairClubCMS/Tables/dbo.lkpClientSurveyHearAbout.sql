/* CreateDate: 10/20/2014 07:50:33.990 , ModifyDate: 07/18/2016 07:45:55.757 */
GO
CREATE TABLE [dbo].[lkpClientSurveyHearAbout](
	[ClientSurveyHearAboutID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientSurveyHearAboutSortOrder] [int] NOT NULL,
	[ClientSurveyHearAboutDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientSurveyHearAboutDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpClientSurveyHearAbout] PRIMARY KEY CLUSTERED
(
	[ClientSurveyHearAboutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
