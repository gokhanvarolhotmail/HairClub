/* CreateDate: 06/06/2005 17:18:57.020 , ModifyDate: 06/21/2012 10:04:45.340 */
GO
CREATE TABLE [dbo].[oncs_client_db_exclusion](
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncs_client_db_exclusion] PRIMARY KEY CLUSTERED
(
	[table_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
