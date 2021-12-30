/* CreateDate: 03/05/2013 10:16:15.210 , ModifyDate: 10/03/2019 22:32:03.643 */
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
	[JobClassification] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
