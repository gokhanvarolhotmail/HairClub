/* CreateDate: 10/03/2019 23:03:40.430 , ModifyDate: 07/06/2021 23:17:52.047 */
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
CREATE NONCLUSTERED INDEX [IX_DimEmployeePositionJoin_EmployeeGUID] ON [bi_cms_dds].[DimEmployeePositionJoin]
(
	[EmployeePositionID] ASC
)
INCLUDE([EmployeeGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
