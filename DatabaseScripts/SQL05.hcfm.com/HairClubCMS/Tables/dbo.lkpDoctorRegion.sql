/* CreateDate: 05/05/2020 17:42:39.253 , ModifyDate: 05/05/2020 18:41:02.640 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
