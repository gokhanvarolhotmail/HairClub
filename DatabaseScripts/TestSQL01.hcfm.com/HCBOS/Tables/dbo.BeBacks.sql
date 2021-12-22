/* CreateDate: 09/30/2009 11:26:39.953 , ModifyDate: 09/30/2009 11:26:39.957 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BeBacks](
	[contact_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Birthday] [datetime] NULL,
	[Age] [int] NULL,
	[Occupation] [int] NULL,
	[Ethnicity] [int] NULL,
	[MaritalStatus] [int] NULL,
	[Norwood] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ludwig] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SolutionOffered] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Performer] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoSaleReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceQuoted] [money] NULL
) ON [PRIMARY]
GO
