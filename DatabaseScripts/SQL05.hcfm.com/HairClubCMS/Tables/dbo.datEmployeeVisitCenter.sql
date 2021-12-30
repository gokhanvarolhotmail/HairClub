/* CreateDate: 05/05/2020 17:42:49.900 , ModifyDate: 05/05/2020 17:43:09.783 */
GO
CREATE TABLE [dbo].[datEmployeeVisitCenter](
	[EmployeeCenterGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datEmployeeCenter] PRIMARY KEY CLUSTERED
(
	[EmployeeCenterGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
