/* CreateDate: 05/05/2020 17:42:41.483 , ModifyDate: 05/05/2020 17:43:00.137 */
GO
CREATE TABLE [dbo].[cfgConfigurationEmployee](
	[ConfigurationEmployeeID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
