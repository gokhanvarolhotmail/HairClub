/* CreateDate: 05/05/2020 17:42:49.807 , ModifyDate: 04/08/2021 19:14:42.190 */
GO
CREATE TABLE [dbo].[datEmployeeCenter](
	[EmployeeCenterGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[SequenceNumber] [int] NOT NULL,
 CONSTRAINT [PK_datEmployeeCenter2] PRIMARY KEY NONCLUSTERED
(
	[EmployeeCenterGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [UK_datEmployeeCenter] UNIQUE CLUSTERED
(
	[EmployeeGUID] ASC,
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datEmployeeCenter_IsActiveFlag_CenterID] ON [dbo].[datEmployeeCenter]
(
	[IsActiveFlag] ASC,
	[CenterID] ASC
)
INCLUDE([EmployeeGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
