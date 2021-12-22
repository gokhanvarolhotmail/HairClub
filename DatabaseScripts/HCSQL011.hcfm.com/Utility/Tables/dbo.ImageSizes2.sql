/* CreateDate: 01/24/2017 19:37:29.850 , ModifyDate: 01/24/2017 19:37:29.850 */
GO
CREATE TABLE [dbo].[ImageSizes2](
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NULL,
	[AppointmentPhotoGUID] [uniqueidentifier] NOT NULL,
	[AppointmentPhotoLen] [bigint] NULL,
	[AppointmentPhotoModifiedLen] [bigint] NULL
) ON [PRIMARY]
GO
