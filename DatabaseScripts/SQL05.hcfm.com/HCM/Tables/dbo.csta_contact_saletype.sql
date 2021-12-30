/* CreateDate: 01/03/2018 16:31:32.710 , ModifyDate: 11/08/2018 11:05:01.833 */
GO
CREATE TABLE [dbo].[csta_contact_saletype](
	[saletype_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[frame] [int] NULL,
	[price] [decimal](15, 4) NULL,
	[select_size_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[size_sets_price] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[length_sets_price] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[base_is_init_pay] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[percentage] [int] NULL,
	[message_under] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[message_over] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[systems] [int] NULL,
	[BusinessSegmentID] [int] NULL,
 CONSTRAINT [pk_csta_contact_saletype] PRIMARY KEY NONCLUSTERED
(
	[saletype_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
