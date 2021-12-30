/* CreateDate: 01/03/2014 07:07:46.487 , ModifyDate: 01/03/2014 07:07:46.497 */
GO
CREATE TABLE [core].[wait_categories](
	[category_id] [smallint] NOT NULL,
	[category_name] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ignore] [bit] NOT NULL,
 CONSTRAINT [PK_categories] PRIMARY KEY CLUSTERED
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
