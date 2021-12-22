/* CreateDate: 08/27/2008 12:25:25.747 , ModifyDate: 12/07/2021 16:20:15.890 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpTimeZone](
	[TimeZoneID] [int] NOT NULL,
	[TimeZoneSortOrder] [int] NOT NULL,
	[TimeZoneDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeZoneDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UTCOffset] [int] NULL,
	[UsesDayLightSavingsFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpTimeZone] PRIMARY KEY CLUSTERED
(
	[TimeZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpTimeZone] ADD  CONSTRAINT [DF_lkpTimeZone_UsesDayLightSavingsFlag]  DEFAULT ((1)) FOR [UsesDayLightSavingsFlag]
GO
ALTER TABLE [dbo].[lkpTimeZone] ADD  CONSTRAINT [DF_lkpTimeZone_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
