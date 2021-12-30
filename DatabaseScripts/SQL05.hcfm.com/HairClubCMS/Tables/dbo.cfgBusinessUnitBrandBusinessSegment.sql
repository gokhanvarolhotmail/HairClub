/* CreateDate: 02/12/2019 22:53:21.683 , ModifyDate: 02/12/2019 23:28:52.800 */
GO
CREATE TABLE [dbo].[cfgBusinessUnitBrandBusinessSegment](
	[BusinessUnitBrandBusinessSegmentID] [int] NOT NULL,
	[BusinessUnitBrandID] [int] NOT NULL,
	[BusinessSegmentID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NOT NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_cfgBusinessUnitBrandBusinessSegment] ON [dbo].[cfgBusinessUnitBrandBusinessSegment]
(
	[BusinessUnitBrandBusinessSegmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_cfgBusinessUnitBrandBusinessSegment_BusinessUnitBrandID_BusinessSegmentID] ON [dbo].[cfgBusinessUnitBrandBusinessSegment]
(
	[BusinessUnitBrandID] ASC,
	[BusinessSegmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
