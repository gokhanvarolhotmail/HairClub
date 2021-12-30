/* CreateDate: 05/05/2020 17:42:41.430 , ModifyDate: 05/05/2020 17:42:59.923 */
GO
CREATE TABLE [dbo].[cfgConfigurationCenterPC](
	[ConfigurationCenterPCID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[PCName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DefaultDirectory] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgConfigurationCenterPC] PRIMARY KEY CLUSTERED
(
	[ConfigurationCenterPCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
