/* CreateDate: 07/11/2011 15:45:17.287 , ModifyDate: 07/11/2011 15:45:17.287 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCertipay](
	[LastName] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JobCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PayGroup] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomeDepartment] [int] NULL,
	[EmployeeID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HireDate] [datetime] NULL,
	[TerminationDate] [datetime] NULL,
	[EmployeeType] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommissionFlag] [tinyint] NULL,
	[PerformerHomeCenter] [int] NULL,
	[ImportDate] [datetime] NULL,
	[GeneralLedger] [int] NULL,
	[JobClassification] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
