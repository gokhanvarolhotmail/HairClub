/* CreateDate: 01/18/2005 09:34:19.967 , ModifyDate: 06/21/2012 10:01:08.673 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_address_normalization](
	[address_normalization_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[abbreviation] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[full_word] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_address_normalization] PRIMARY KEY CLUSTERED
(
	[address_normalization_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
