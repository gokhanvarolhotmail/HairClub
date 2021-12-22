/* CreateDate: 01/24/2017 19:23:23.610 , ModifyDate: 01/24/2017 19:23:23.610 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImageSizes](
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NULL,
	[AppointmentPhotoGUID] [uniqueidentifier] NOT NULL,
	[AppointmentPhotoLen] [bigint] NULL,
	[AppointmentPhotoModifiedLen] [bigint] NULL
) ON [PRIMARY]
GO
