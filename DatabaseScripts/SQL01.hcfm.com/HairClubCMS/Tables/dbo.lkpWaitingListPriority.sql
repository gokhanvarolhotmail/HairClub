/* CreateDate: 06/11/2014 08:04:32.227 , ModifyDate: 05/26/2020 10:49:23.787 */
GO
CREATE TABLE [dbo].[lkpWaitingListPriority](
	[WaitingListPriorityID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
