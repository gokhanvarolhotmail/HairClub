/* CreateDate: 05/05/2020 17:42:38.120 , ModifyDate: 05/05/2020 17:42:58.207 */
GO
CREATE TABLE [dbo].[lkpAccumulatorJoinType](
	[AccumulatorJoinTypeID] [int] NOT NULL,
	[AccumulatorJoinTypeSortOrder] [int] NOT NULL,
	[AccumulatorJoinTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorJoinTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAccumulatorJoinType] PRIMARY KEY CLUSTERED
(
	[AccumulatorJoinTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
