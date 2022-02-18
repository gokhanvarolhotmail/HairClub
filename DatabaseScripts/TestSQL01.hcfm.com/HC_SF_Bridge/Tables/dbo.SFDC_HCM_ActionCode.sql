/* CreateDate: 11/21/2017 15:49:08.793 , ModifyDate: 11/21/2017 15:49:08.907 */
GO
CREATE TABLE [dbo].[SFDC_HCM_ActionCode](
	[OnContact_ActionCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnContact_Description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SF_ActionCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SFDC_HCM_ActionCode] ADD  CONSTRAINT [DF_SFDC_HCM_ActionCode_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[SFDC_HCM_ActionCode] ADD  CONSTRAINT [DF_SFDC_HCM_ActionCode_CreateUser]  DEFAULT (N'sa') FOR [CreateUser]
GO
ALTER TABLE [dbo].[SFDC_HCM_ActionCode] ADD  CONSTRAINT [DF_SFDC_HCM_ActionCode_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [dbo].[SFDC_HCM_ActionCode] ADD  CONSTRAINT [DF_SFDC_HCM_ActionCode_LastUpdateUser]  DEFAULT (N'sa') FOR [LastUpdateUser]
GO
