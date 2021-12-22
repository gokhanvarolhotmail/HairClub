/* CreateDate: 08/27/2008 11:27:57.550 , ModifyDate: 12/07/2021 16:20:15.997 */
GO
CREATE TABLE [dbo].[lkpBusinessSegment](
	[BusinessSegmentID] [int] NOT NULL,
	[BusinessSegmentSortOrder] [int] NOT NULL,
	[BusinessSegmentDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegmentDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpBusinessSegment] PRIMARY KEY CLUSTERED
(
	[BusinessSegmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpBusinessSegment] ADD  CONSTRAINT [DF_lkpBusinessSegment_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
