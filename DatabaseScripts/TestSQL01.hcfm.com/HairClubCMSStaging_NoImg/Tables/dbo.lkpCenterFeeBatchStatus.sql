/* CreateDate: 05/14/2012 17:29:16.200 , ModifyDate: 03/04/2022 16:09:12.880 */
GO
CREATE TABLE [dbo].[lkpCenterFeeBatchStatus](
	[CenterFeeBatchStatusID] [int] NOT NULL,
	[CenterFeeBatchStatusSortOrder] [int] NOT NULL,
	[CenterFeeBatchStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterFeeBatchStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpCenterFeeBatchStatusID] PRIMARY KEY CLUSTERED
(
	[CenterFeeBatchStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
