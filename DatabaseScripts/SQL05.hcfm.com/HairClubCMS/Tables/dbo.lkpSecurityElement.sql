/* CreateDate: 05/05/2020 17:42:45.003 , ModifyDate: 05/05/2020 18:41:10.613 */
GO
CREATE TABLE [dbo].[lkpSecurityElement](
	[SecurityElementID] [int] NOT NULL,
	[SecurityElementSortOrder] [int] NOT NULL,
	[SecurityElementDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SecurityElementDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[SecurityElementDescriptionFull] [nvarchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsTabletElement] [bit] NOT NULL,
 CONSTRAINT [PK_lkpSecurityElement] PRIMARY KEY CLUSTERED
(
	[SecurityElementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
