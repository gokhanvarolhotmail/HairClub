/* CreateDate: 03/17/2022 11:57:04.870 , ModifyDate: 03/17/2022 11:57:15.800 */
GO
CREATE TABLE [bi_cms_dds].[DimEmployeePositionJoin](
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[EmployeePositionID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [binary](8) NULL
) ON [FG1]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_DimEmployeePositionJoin] ON [bi_cms_dds].[DimEmployeePositionJoin]
(
	[EmployeeGUID] ASC,
	[EmployeePositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
