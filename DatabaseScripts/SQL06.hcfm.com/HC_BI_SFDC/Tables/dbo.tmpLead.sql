/* CreateDate: 05/17/2021 15:25:23.167 , ModifyDate: 05/17/2021 15:25:23.167 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpLead](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadCreatedDateEST] [datetime] NULL
) ON [PRIMARY]
GO
