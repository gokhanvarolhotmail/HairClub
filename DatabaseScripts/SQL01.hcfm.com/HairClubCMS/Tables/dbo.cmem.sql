CREATE TABLE [dbo].[cmem](
	[centerid] [int] NULL,
	[clientmembershipguid] [uniqueidentifier] NOT NULL,
	[membershipdescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clientguid] [uniqueidentifier] NULL,
	[enddate] [date] NULL,
	[MemStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[clientfullnamecalc] [nvarchar](127) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
