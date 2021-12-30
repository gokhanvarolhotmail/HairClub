/* CreateDate: 11/08/2012 14:04:13.117 , ModifyDate: 11/08/2012 14:04:13.117 */
GO
CREATE TABLE [dbo].[onca_contract_status](
	[contract_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
