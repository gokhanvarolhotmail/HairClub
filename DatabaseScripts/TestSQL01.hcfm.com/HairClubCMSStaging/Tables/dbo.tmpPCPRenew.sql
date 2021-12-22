/* CreateDate: 04/11/2018 11:00:21.453 , ModifyDate: 04/11/2018 11:00:21.453 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpPCPRenew](
	[CenterID] [float] NULL,
	[CenterName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [float] NULL,
	[FirstName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
