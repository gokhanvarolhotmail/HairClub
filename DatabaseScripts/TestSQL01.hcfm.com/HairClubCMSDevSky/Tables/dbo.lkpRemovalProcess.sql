/* CreateDate: 08/27/2008 12:16:40.230 , ModifyDate: 12/07/2021 16:20:16.280 */
GO
CREATE TABLE [dbo].[lkpRemovalProcess](
	[RemovalProcessID] [int] NOT NULL,
	[RemovalProcessSortOrder] [int] NOT NULL,
	[RemovalProcessDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RemovalProcessDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpRemovalProcess] PRIMARY KEY CLUSTERED
(
	[RemovalProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpRemovalProcess] ADD  CONSTRAINT [DF_lkpRemovalProcess_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
