CREATE TABLE [dbo].[ImageIssue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HC_AppointmentGUID] [uniqueidentifier] NULL,
	[TV_AppointmentPhotoGUID] [uniqueidentifier] NULL,
	[HC_AppointmentPhotoGUID] [uniqueidentifier] NULL,
	[FileStream_PhotoLen] [int] NULL,
	[HC_PhotoSizeInBytes] [int] NULL,
 CONSTRAINT [PK_ImageIssue] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
