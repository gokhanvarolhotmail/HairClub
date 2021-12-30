/* CreateDate: 01/03/2018 16:31:35.973 , ModifyDate: 11/08/2018 11:05:01.410 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
