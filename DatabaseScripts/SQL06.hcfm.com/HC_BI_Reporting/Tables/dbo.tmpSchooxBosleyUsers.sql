/* CreateDate: 06/04/2018 15:13:15.013 , ModifyDate: 06/13/2019 15:20:32.967 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpSchooxBosleyUsers](
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Username] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Password] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AboveUnit] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JobName] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeGUID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
