/* CreateDate: 09/10/2014 07:53:57.443 , ModifyDate: 02/02/2022 10:07:50.643 */
GO
CREATE TABLE [dbo].[cfgConfigurationCenterPC](
	[ConfigurationCenterPCID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgConfigurationCenterPC]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenterPC_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenterPC] CHECK CONSTRAINT [FK_cfgConfigurationCenterPC_cfgCenter]
GO
