/* CreateDate: 10/28/2008 14:00:56.643 , ModifyDate: 12/29/2021 15:38:46.517 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAccumulatorAdjustmentType] ADD  CONSTRAINT [DF_lkpAccumulatorAdjustmentType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
