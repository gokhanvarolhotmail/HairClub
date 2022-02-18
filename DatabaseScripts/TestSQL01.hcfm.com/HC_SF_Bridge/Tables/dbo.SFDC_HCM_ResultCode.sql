/* CreateDate: 11/21/2017 15:43:57.507 , ModifyDate: 11/21/2017 15:43:57.643 */
GO
CREATE TABLE [dbo].[SFDC_HCM_ResultCode](
	[OnContact_ResultCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OnContact_Description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SF_ResultCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SFDC_HCM_ResultCode] ADD  CONSTRAINT [DF_SFDC_HCM_ResultCode_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[SFDC_HCM_ResultCode] ADD  CONSTRAINT [DF_SFDC_HCM_ResultCode_CreateUser]  DEFAULT (N'sa') FOR [CreateUser]
GO
ALTER TABLE [dbo].[SFDC_HCM_ResultCode] ADD  CONSTRAINT [DF_SFDC_HCM_ResultCode_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [dbo].[SFDC_HCM_ResultCode] ADD  CONSTRAINT [DF_SFDC_HCM_ResultCode_LastUpdateUser]  DEFAULT (N'sa') FOR [LastUpdateUser]
GO
