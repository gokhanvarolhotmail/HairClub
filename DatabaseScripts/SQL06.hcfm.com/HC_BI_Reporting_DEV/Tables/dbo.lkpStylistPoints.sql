/* CreateDate: 07/19/2012 13:56:36.987 , ModifyDate: 07/20/2012 11:32:17.353 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpStylistPoints](
	[RowID] [int] NOT NULL,
	[ProgramType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Program] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Points] [numeric](6, 2) NULL,
	[MembershipKey] [int] NULL
) ON [PRIMARY]
GO
