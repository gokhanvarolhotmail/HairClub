/* CreateDate: 07/03/2014 12:08:27.047 , ModifyDate: 07/03/2014 12:08:27.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dashbdActivePCP](
	[Center] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientKey] [int] NULL,
	[Client] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneType] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Membership] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
