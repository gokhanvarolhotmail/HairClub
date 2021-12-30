/* CreateDate: 09/19/2019 12:32:17.657 , ModifyDate: 09/19/2019 12:33:05.010 */
GO
CREATE TABLE [dbo].[FS_datAppointmentSummary](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[AppointmentPhotoGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[AppointmentPhotoCount] [int] NULL,
	[ModifiedPhotoCount] [int] NULL,
	[PhotoSizeInBytes] [int] NULL,
	[AppointmentDate] [date] NULL,
	[CreateDate] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
 CONSTRAINT [PK_FS_datAppointmentSummary] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
