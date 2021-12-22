/* CreateDate: 11/02/2015 10:07:03.150 , ModifyDate: 11/02/2015 10:07:03.387 */
GO
CREATE TABLE [dbo].[csta_skip_trace_import_type](
	[skip_trace_import_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[skip_trace_import_type_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_skip_trace_import_type] ADD  CONSTRAINT [df_csta_skip_trace_import_type_active]  DEFAULT ('Y') FOR [active]
GO
