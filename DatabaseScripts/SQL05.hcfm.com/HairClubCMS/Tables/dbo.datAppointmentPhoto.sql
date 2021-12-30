/* CreateDate: 06/11/2013 15:18:06.393 , ModifyDate: 03/01/2017 08:26:18.353 */
GO
CREATE TABLE [dbo].[datAppointmentPhoto](
	[AppointmentPhotoGUID] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[AppointmentPhoto] [varbinary](max) NOT NULL,
	[PhotoCaptionID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[AppointmentPhotoID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PhotoTypeID] [int] NOT NULL,
 CONSTRAINT [PK_datAppointmentPhoto] PRIMARY KEY CLUSTERED
(
	[AppointmentPhotoGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
