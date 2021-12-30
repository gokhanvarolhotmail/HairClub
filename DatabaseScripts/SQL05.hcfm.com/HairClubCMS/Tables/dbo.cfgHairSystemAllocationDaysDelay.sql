/* CreateDate: 05/05/2020 17:42:41.727 , ModifyDate: 05/05/2020 17:43:00.567 */
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationDaysDelay](
	[HairSystemAllocationDaysDelayID] [int] NOT NULL,
	[HairSystemAllocationDaysDelaySortOrder] [int] NOT NULL,
	[HairSystemAllocationDaysDelayDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemAllocationDaysDelayDescriptionShort] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MinimumValue] [int] NULL,
	[MaximumValue] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemAllocationDaysDelay] PRIMARY KEY CLUSTERED
(
	[HairSystemAllocationDaysDelayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
