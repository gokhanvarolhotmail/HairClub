/* CreateDate: 05/14/2012 17:41:16.977 , ModifyDate: 12/07/2021 16:20:16.200 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
