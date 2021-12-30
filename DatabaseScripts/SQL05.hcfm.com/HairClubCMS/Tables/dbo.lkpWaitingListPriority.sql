/* CreateDate: 05/05/2020 17:42:55.373 , ModifyDate: 05/05/2020 17:43:16.173 */
GO
CREATE TABLE [dbo].[lkpWaitingListPriority](
	[WaitingListPriorityID] [int] NOT NULL,
	[WaitingListPrioritySortOrder] [int] NOT NULL,
	[WaitingListPriorityDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[WaitingListPriorityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpWaitingListPriority] PRIMARY KEY CLUSTERED
(
	[WaitingListPriorityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
