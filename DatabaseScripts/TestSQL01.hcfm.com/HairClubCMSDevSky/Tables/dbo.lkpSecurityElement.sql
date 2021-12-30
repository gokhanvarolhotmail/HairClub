/* CreateDate: 02/18/2009 08:20:18.440 , ModifyDate: 12/29/2021 15:38:46.413 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpSecurityElement] ADD  DEFAULT ((0)) FOR [IsTabletElement]
GO
