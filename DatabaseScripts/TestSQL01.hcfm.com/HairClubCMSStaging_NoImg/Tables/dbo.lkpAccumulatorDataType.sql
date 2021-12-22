/* CreateDate: 10/21/2008 17:34:26.387 , ModifyDate: 12/03/2021 10:24:48.697 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpAccumulatorDataType](
	[AccumulatorDataTypeID] [int] NOT NULL,
	[AccumulatorDataTypeSortOrder] [int] NOT NULL,
	[AccumulatorDataTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorDataTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAccumulatorDataType] PRIMARY KEY CLUSTERED
(
	[AccumulatorDataTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAccumulatorDataType] ADD  CONSTRAINT [DF_lkpAccumulatorDataType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
