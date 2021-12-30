/* CreateDate: 10/17/2007 08:55:07.510 , ModifyDate: 10/17/2007 08:55:07.513 */
GO
CREATE TABLE [dbo].[hcmtbl_tmproductivity](
	[Telemarketer] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date] [datetime] NULL,
	[Required Hours] [numeric](18, 0) NULL,
	[Inbound Hours] [numeric](18, 0) NULL,
	[Outbond Hours] [numeric](18, 0) NULL,
	[Total Hits] [numeric](18, 0) NULL,
	[Total Calls] [numeric](18, 0) NULL,
	[Dials] [numeric](18, 0) NULL
) ON [PRIMARY]
GO
