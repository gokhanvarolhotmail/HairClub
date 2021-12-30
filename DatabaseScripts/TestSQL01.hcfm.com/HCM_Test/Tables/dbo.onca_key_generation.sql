/* CreateDate: 01/18/2005 09:34:07.610 , ModifyDate: 06/21/2012 10:00:56.753 */
GO
CREATE TABLE [dbo].[onca_key_generation](
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[column_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[key_value] [int] NULL,
 CONSTRAINT [pk_onca_key_generation] PRIMARY KEY CLUSTERED
(
	[table_name] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
