/* CreateDate: 06/20/2011 21:40:07.160 , ModifyDate: 12/03/2021 10:24:48.583 */
GO
CREATE TABLE [dbo].[cfgConfigurationEmployee](
	[ConfigurationEmployeeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[NotificationSoundFileName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[NotificationSoundFileName2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageID] [int] NULL,
	[ScanSuccessSoundFileName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cfgConfigurationEmployee] PRIMARY KEY CLUSTERED
(
	[ConfigurationEmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgConfigurationEmployee]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgConfigurationEmployee_cfgConfigurationEmployee] FOREIGN KEY([ConfigurationEmployeeID])
REFERENCES [dbo].[cfgConfigurationEmployee] ([ConfigurationEmployeeID])
GO
ALTER TABLE [dbo].[cfgConfigurationEmployee] CHECK CONSTRAINT [FK_cfgConfigurationEmployee_cfgConfigurationEmployee]
GO
ALTER TABLE [dbo].[cfgConfigurationEmployee]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgConfigurationEmployee_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[cfgConfigurationEmployee] CHECK CONSTRAINT [FK_cfgConfigurationEmployee_datEmployee]
GO
ALTER TABLE [dbo].[cfgConfigurationEmployee]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgConfigurationEmployee_lkpLanguage] FOREIGN KEY([LanguageID])
REFERENCES [dbo].[lkpLanguage] ([LanguageID])
GO
ALTER TABLE [dbo].[cfgConfigurationEmployee] CHECK CONSTRAINT [FK_cfgConfigurationEmployee_lkpLanguage]
GO
