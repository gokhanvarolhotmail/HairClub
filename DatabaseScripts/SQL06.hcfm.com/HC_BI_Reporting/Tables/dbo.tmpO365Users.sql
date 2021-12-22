/* CreateDate: 07/10/2019 17:53:38.213 , ModifyDate: 07/15/2019 15:49:43.520 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpO365Users](
	[FirstName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserPrincipalName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectId] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Office] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Department] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
