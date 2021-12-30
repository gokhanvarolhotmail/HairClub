/* CreateDate: 01/03/2018 16:31:33.527 , ModifyDate: 11/08/2018 11:05:01.467 */
GO
CREATE TABLE [dbo].[onca_department](
	[department_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_department_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_department_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_department] PRIMARY KEY CLUSTERED
(
	[department_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
