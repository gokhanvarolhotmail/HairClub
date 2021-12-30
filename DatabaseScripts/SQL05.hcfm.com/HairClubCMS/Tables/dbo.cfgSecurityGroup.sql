/* CreateDate: 05/05/2020 17:42:45.060 , ModifyDate: 05/05/2020 18:41:10.230 */
GO
CREATE TABLE [dbo].[cfgSecurityGroup](
	[SecurityGroupID] [int] NOT NULL,
	[EmployeePositionID] [int] NULL,
	[SecurityElementID] [int] NULL,
	[HasAccessFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgSecurityPosition] PRIMARY KEY CLUSTERED
(
	[SecurityGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
