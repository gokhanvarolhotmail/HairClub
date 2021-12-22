/* CreateDate: 11/22/2019 14:57:35.390 , ModifyDate: 11/22/2019 14:57:35.390 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dba].[Orders](
	[TableName] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[@EndDate] [datetime] NULL,
	[@TotalCount] [int] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[VendorID] [int] NOT NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemPrice] [money] NOT NULL,
	[TemplateArea] [decimal](23, 8) NOT NULL,
	[LowestPrice] [money] NOT NULL,
	[HighestPrice] [money] NOT NULL
) ON [PRIMARY]
GO
