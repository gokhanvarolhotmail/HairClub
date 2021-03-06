/* CreateDate: 10/28/2008 13:59:55.040 , ModifyDate: 05/26/2020 10:49:49.460 */
GO
CREATE TABLE [dbo].[lkpAccumulatorActionType](
	[AccumulatorActionTypeID] [int] NOT NULL,
	[AccumulatorActionTypeSortOrder] [int] NOT NULL,
	[AccumulatorActionTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorActionTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAccumulatorAction] PRIMARY KEY CLUSTERED
(
	[AccumulatorActionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAccumulatorActionType] ADD  CONSTRAINT [DF_lkpAccumulatorActionType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
