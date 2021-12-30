/* CreateDate: 01/18/2005 09:34:20.437 , ModifyDate: 06/21/2012 10:00:56.760 */
GO
CREATE TABLE [dbo].[onca_knowledge_exclusion](
	[exclusion_word] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_knowledge_exclusion] PRIMARY KEY CLUSTERED
(
	[exclusion_word] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
