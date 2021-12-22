/* CreateDate: 10/04/2010 12:08:46.263 , ModifyDate: 12/03/2021 10:24:48.673 */
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationDaysDelay](
	[HairSystemAllocationDaysDelayID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemAllocationDaysDelay_HairSystemAllocationDaysDelayDescription] ON [dbo].[cfgHairSystemAllocationDaysDelay]
(
	[HairSystemAllocationDaysDelayDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemAllocationDaysDelay_HairSystemAllocationDaysDelayDescriptionShort] ON [dbo].[cfgHairSystemAllocationDaysDelay]
(
	[HairSystemAllocationDaysDelayDescriptionShort] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemAllocationDaysDelay_HairSystemAllocationDaysDelaySortOrder] ON [dbo].[cfgHairSystemAllocationDaysDelay]
(
	[HairSystemAllocationDaysDelaySortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
