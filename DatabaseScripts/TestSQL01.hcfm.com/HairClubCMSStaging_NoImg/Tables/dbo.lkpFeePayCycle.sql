/* CreateDate: 08/27/2008 11:59:04.530 , ModifyDate: 12/03/2021 10:24:48.673 */
GO
CREATE TABLE [dbo].[lkpFeePayCycle](
	[FeePayCycleID] [int] NOT NULL,
	[FeePayCycleSortOrder] [int] NOT NULL,
	[FeePayCycleDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FeePayCycleDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FeePayCycleValue] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpFeePayCycle] PRIMARY KEY CLUSTERED
(
	[FeePayCycleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpFeePayCycle] ADD  CONSTRAINT [DF_lkpEFTPayCycle_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
