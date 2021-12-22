CREATE TABLE [dbo].[CMSDepartment](
	[number] [tinyint] NOT NULL,
	[description] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Discount] [tinyint] NULL,
	[RefundDepartmentNo] [int] NULL,
	[IsRevenue] [bit] NULL,
	[CMS50Dept] [int] NULL,
	[LastAction] [datetime] NULL
) ON [PRIMARY]
