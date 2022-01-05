/* CreateDate: 02/20/2009 09:17:41.397 , ModifyDate: 01/04/2022 10:56:36.723 */
GO
CREATE TABLE [dbo].[lkpDoctorRegion](
	[DoctorRegionID] [int] NOT NULL,
	[DoctorRegionSortOrder] [int] NOT NULL,
	[DoctorRegionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DoctorRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ExternalSchedulerResourceID] [int] NULL,
 CONSTRAINT [PK_lkpDoctorRegion] PRIMARY KEY CLUSTERED
(
	[DoctorRegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpDoctorRegion] ADD  CONSTRAINT [DF_lkpDoctorRegion_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
