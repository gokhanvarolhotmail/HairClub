/* CreateDate: 01/25/2010 11:09:10.177 , ModifyDate: 10/30/2016 01:29:41.877 */
GO
CREATE TABLE [dbo].[onca_invoice_time_adjust](
	[invoice_time_adjust_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_invoice_time_adjust] PRIMARY KEY CLUSTERED
(
	[invoice_time_adjust_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
