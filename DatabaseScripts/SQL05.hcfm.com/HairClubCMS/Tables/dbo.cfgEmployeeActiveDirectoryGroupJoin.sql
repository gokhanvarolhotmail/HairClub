/* CreateDate: 05/05/2020 17:42:41.630 , ModifyDate: 12/29/2021 19:00:21.317 */
GO
CREATE TABLE [dbo].[cfgEmployeeActiveDirectoryGroupJoin](
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[ActiveDirectoryGroupID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgEmployeeActiveDirectoryGroupJoin] PRIMARY KEY CLUSTERED
(
	[EmployeeGUID] ASC,
	[ActiveDirectoryGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
