/* CreateDate: 05/13/2009 06:37:43.917 , ModifyDate: 05/26/2020 10:49:09.967 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mtnActiveDirectoryImport](
	[ActiveDirectoryID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ADSID] [varbinary](100) NULL,
	[ADUserLogin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADCenter] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADLastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[EmployeePositionID] [int] NULL,
	[EmployeeInitials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[EmployeePayrollID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeTitleID] [int] NULL,
 CONSTRAINT [PK_mtnActiveDirectoryImport] PRIMARY KEY CLUSTERED
(
	[ActiveDirectoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
