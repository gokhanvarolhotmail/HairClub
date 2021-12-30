/* CreateDate: 10/04/2006 16:26:48.487 , ModifyDate: 10/23/2017 12:35:40.137 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_contact_saletype] ADD  CONSTRAINT [DF__csta_cont__activ__369C13AA]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_contact_saletype] ADD  CONSTRAINT [DF__csta_cont__selec__379037E3]  DEFAULT (' ') FOR [select_size_flag]
GO
ALTER TABLE [dbo].[csta_contact_saletype] ADD  CONSTRAINT [DF__csta_cont__size___38845C1C]  DEFAULT (' ') FOR [size_sets_price]
GO
ALTER TABLE [dbo].[csta_contact_saletype] ADD  CONSTRAINT [DF__csta_cont__lengt__39788055]  DEFAULT (' ') FOR [length_sets_price]
GO
ALTER TABLE [dbo].[csta_contact_saletype] ADD  CONSTRAINT [DF__csta_cont__base___3A6CA48E]  DEFAULT (' ') FOR [base_is_init_pay]
GO
