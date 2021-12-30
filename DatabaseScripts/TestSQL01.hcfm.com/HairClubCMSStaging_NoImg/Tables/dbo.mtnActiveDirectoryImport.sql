/* CreateDate: 05/13/2009 06:37:43.917 , ModifyDate: 12/28/2021 09:20:54.477 */
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
