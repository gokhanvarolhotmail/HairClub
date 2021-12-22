/* CreateDate: 04/13/2006 13:57:44.400 , ModifyDate: 06/21/2012 10:03:46.000 */
GO
CREATE TABLE [dbo].[oncw_module](
	[module_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[control_class] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[module_type] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_oncw_module] PRIMARY KEY CLUSTERED
(
	[module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
