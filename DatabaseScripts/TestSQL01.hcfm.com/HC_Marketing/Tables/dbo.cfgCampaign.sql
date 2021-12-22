/* CreateDate: 04/26/2016 14:32:13.180 , ModifyDate: 04/26/2016 14:32:13.323 */
GO
CREATE TABLE [dbo].[cfgCampaign](
	[CampaignID] [int] IDENTITY(1,1) NOT NULL,
	[CampaignDescription] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CampaignDescriptionFullCalc]  AS ((CONVERT([nvarchar](50),[CampaignID],(0))+' - ')+[CampaignDescription]),
	[OfferType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BeginDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgCampaign] PRIMARY KEY CLUSTERED
(
	[CampaignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCampaign] ADD  CONSTRAINT [DF_cfgCampaign_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgCampaign] ADD  CONSTRAINT [DF_cfgCampaign_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[cfgCampaign] ADD  CONSTRAINT [DF_cfgCampaign_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
