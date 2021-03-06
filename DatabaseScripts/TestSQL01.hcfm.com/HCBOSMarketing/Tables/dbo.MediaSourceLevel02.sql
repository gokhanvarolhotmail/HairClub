/* CreateDate: 06/09/2008 13:10:06.207 , ModifyDate: 06/14/2009 09:00:16.090 */
GO
CREATE TABLE [dbo].[MediaSourceLevel02](
	[Level02ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Level02LocationCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level02Location] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediaID] [smallint] NULL,
 CONSTRAINT [PK_Level01ID] PRIMARY KEY CLUSTERED
(
	[Level02ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
