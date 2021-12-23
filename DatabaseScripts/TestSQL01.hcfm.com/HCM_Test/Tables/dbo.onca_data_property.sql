/* CreateDate: 01/18/2005 09:34:20.340 , ModifyDate: 06/21/2012 10:01:04.780 */
GO
CREATE TABLE [dbo].[onca_data_property](
	[data_property_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[data_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[property_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[property_value] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_data_property] PRIMARY KEY CLUSTERED
(
	[data_property_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_data_property]  WITH NOCHECK ADD  CONSTRAINT [data_data_propert_325] FOREIGN KEY([data_code])
REFERENCES [dbo].[onca_data] ([data_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_data_property] CHECK CONSTRAINT [data_data_propert_325]
GO
