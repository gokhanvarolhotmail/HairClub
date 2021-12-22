/* CreateDate: 01/18/2005 09:34:19.780 , ModifyDate: 06/21/2012 10:04:33.450 */
GO
CREATE TABLE [dbo].[oncs_transport](
	[transport_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[transport_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_transport] PRIMARY KEY CLUSTERED
(
	[transport_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
