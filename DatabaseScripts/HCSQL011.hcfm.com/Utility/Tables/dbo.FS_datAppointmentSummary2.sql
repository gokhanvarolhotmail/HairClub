/* CreateDate: 09/19/2019 12:56:51.460 , ModifyDate: 09/19/2019 12:56:51.587 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FS_datAppointmentSummary2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[AppointmentPhotoCount] [int] NULL,
	[ModifiedPhotoCount] [int] NULL,
	[PhotoSizeInKB] [int] NULL,
	[CenterID] [int] NULL,
	[AppointmentDate] [date] NULL,
	[CreateDate] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
 CONSTRAINT [PK_FS_datAppointmentSummary2] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
