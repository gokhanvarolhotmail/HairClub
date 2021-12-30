/* CreateDate: 01/25/2010 11:09:10.113 , ModifyDate: 06/18/2013 09:24:50.700 */
GO
CREATE TABLE [dbo].[onct_layer](
	[layer_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[updated_date] [datetime] NULL,
	[prefix_text] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_namespace] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[persist_assembly_modules] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onct_layer] PRIMARY KEY CLUSTERED
(
	[layer_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_layer] ADD  DEFAULT ('Y') FOR [persist_assembly_modules]
GO
