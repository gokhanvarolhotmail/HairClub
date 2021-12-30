/* CreateDate: 01/18/2005 09:34:07.750 , ModifyDate: 10/23/2017 12:35:40.133 */
GO
CREATE TABLE [dbo].[onca_phone_type](
	[phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[device_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_entity_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_is_cell_phone] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_phone_type] PRIMARY KEY CLUSTERED
(
	[phone_type_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_phone_type] ADD  CONSTRAINT [DF_onca_phone_type_cst_is_cell_phone]  DEFAULT ('N') FOR [cst_is_cell_phone]
GO
