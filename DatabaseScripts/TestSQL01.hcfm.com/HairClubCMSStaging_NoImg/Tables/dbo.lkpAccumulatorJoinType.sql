/* CreateDate: 10/21/2008 18:09:07.303 , ModifyDate: 12/28/2021 09:20:54.627 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAccumulatorJoinType] ADD  CONSTRAINT [DF_lkpAccumulatorJoinType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
