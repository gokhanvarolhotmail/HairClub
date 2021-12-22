/* CreateDate: 03/25/2018 17:49:03.713 , ModifyDate: 05/05/2019 08:47:48.470 */
GO
CREATE TABLE [dbo].[cfgBusinessUnitBrandBusinessSegment](
	[BusinessUnitBrandBusinessSegmentID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessUnitBrandID] [int] NOT NULL,
	[BusinessSegmentID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgBusinessUnitBrandBusinessSegment] PRIMARY KEY CLUSTERED
(
	[BusinessUnitBrandBusinessSegmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_cfgBusinessUnitBrandBusinessSegment_BusinessUnitBrandID_BusinessSegmentID] UNIQUE NONCLUSTERED
(
	[BusinessUnitBrandID] ASC,
	[BusinessSegmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgBusinessUnitBrandBusinessSegment]  WITH CHECK ADD  CONSTRAINT [FK_cfgBusinessUnitBrandBusinessSegment_lkpBusinessSegment] FOREIGN KEY([BusinessSegmentID])
REFERENCES [dbo].[lkpBusinessSegment] ([BusinessSegmentID])
GO
ALTER TABLE [dbo].[cfgBusinessUnitBrandBusinessSegment] CHECK CONSTRAINT [FK_cfgBusinessUnitBrandBusinessSegment_lkpBusinessSegment]
GO
ALTER TABLE [dbo].[cfgBusinessUnitBrandBusinessSegment]  WITH CHECK ADD  CONSTRAINT [FK_cfgBusinessUnitBrandBusinessSegment_lkpBusinessUnitBrand] FOREIGN KEY([BusinessUnitBrandID])
REFERENCES [dbo].[lkpBusinessUnitBrand] ([BusinessUnitBrandID])
GO
ALTER TABLE [dbo].[cfgBusinessUnitBrandBusinessSegment] CHECK CONSTRAINT [FK_cfgBusinessUnitBrandBusinessSegment_lkpBusinessUnitBrand]
GO
