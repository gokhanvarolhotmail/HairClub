/* CreateDate: 05/05/2020 17:42:41.677 , ModifyDate: 05/05/2020 18:41:08.923 */
GO
CREATE TABLE [dbo].[cfgEmployeePositionJoin](
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[EmployeePositionID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [binary](8) NULL,
	[IsActiveFlag] [bit] NOT NULL,
 CONSTRAINT [PK_cfgEmployeePositionJoin_1] PRIMARY KEY NONCLUSTERED
(
	[EmployeeGUID] ASC,
	[EmployeePositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_cfgEmployeePositionJoin] ON [dbo].[cfgEmployeePositionJoin]
(
	[EmployeeGUID] ASC,
	[EmployeePositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_cfgEmployeePositionJoin_EmployeePositionID_IsActiveFlag_EmployeeGUID] ON [dbo].[cfgEmployeePositionJoin]
(
	[EmployeePositionID] ASC,
	[IsActiveFlag] DESC,
	[EmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
