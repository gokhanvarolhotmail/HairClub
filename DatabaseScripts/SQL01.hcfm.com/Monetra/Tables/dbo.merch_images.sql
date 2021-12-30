/* CreateDate: 04/26/2021 12:28:48.797 , ModifyDate: 04/26/2021 12:28:48.797 */
GO
CREATE TABLE [dbo].[merch_images](
	[ref] [smallint] NOT NULL,
	[id] [bigint] NOT NULL,
	[type] [smallint] NOT NULL,
	[data] [varbinary](max) NOT NULL,
PRIMARY KEY CLUSTERED
(
	[ref] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
