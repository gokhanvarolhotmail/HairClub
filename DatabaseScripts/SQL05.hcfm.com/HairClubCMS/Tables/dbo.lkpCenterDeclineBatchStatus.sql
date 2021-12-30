/* CreateDate: 05/05/2020 17:42:46.907 , ModifyDate: 05/05/2020 17:43:05.843 */
GO
CREATE TABLE [dbo].[lkpCenterDeclineBatchStatus](
	[CenterDeclineBatchStatusID] [int] NOT NULL,
	[CenterDeclineBatchStatusSortOrder] [int] NOT NULL,
	[CenterDeclineBatchStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterDeclineBatchStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpCenterDeclineBatchStatusID] PRIMARY KEY CLUSTERED
(
	[CenterDeclineBatchStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
