/* CreateDate: 01/31/2017 23:49:22.180 , ModifyDate: 01/31/2017 23:49:22.180 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImageSizes3](
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NULL,
	[AppointmentPhotoGUID] [uniqueidentifier] NOT NULL,
	[AppointmentPhotoLen] [bigint] NULL,
	[AppointmentPhotoModifiedLen] [bigint] NULL
) ON [PRIMARY]
GO
