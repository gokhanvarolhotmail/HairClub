/* CreateDate: 05/05/2020 17:42:37.327 , ModifyDate: 05/05/2020 17:42:57.907 */
GO
CREATE TABLE [dbo].[lkpAccumulatorAdjustmentType](
	[AccumulatorAdjustmentTypeID] [int] NOT NULL,
	[AccumulatorAdjustmentTypeSortOrder] [int] NOT NULL,
	[AccumulatorAdjustmentTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorAdjustmentTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAccumulatorProcessColumn] PRIMARY KEY CLUSTERED
(
	[AccumulatorAdjustmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
