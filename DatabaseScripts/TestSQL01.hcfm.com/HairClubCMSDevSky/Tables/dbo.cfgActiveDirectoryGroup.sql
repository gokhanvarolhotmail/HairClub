/* CreateDate: 07/30/2012 09:01:56.287 , ModifyDate: 12/07/2021 16:20:16.250 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
