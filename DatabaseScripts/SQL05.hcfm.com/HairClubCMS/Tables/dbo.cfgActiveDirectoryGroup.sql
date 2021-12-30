/* CreateDate: 05/05/2020 17:42:38.300 , ModifyDate: 05/05/2020 18:41:10.733 */
GO
CREATE TABLE [dbo].[cfgActiveDirectoryGroup](
	[ActiveDirectoryGroupID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ActiveDirectoryGroup] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgActiveDirectoryGroup] PRIMARY KEY CLUSTERED
(
	[ActiveDirectoryGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
