/* CreateDate: 08/18/2011 16:00:53.180 , ModifyDate: 08/18/2011 16:00:53.180 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalespersonGroups](
	[SalesPersonGroupsId] [int] NOT NULL,
	[Groups] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
