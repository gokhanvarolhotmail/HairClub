/* CreateDate: 02/18/2013 06:40:48.877 , ModifyDate: 12/07/2021 16:20:16.033 */
GO
CREATE TABLE [dbo].[datTelemedicineCollaboration](
	[TelemedicineCollaborationGUID] [uniqueidentifier] NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Expectations] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MedicalHistory] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datTelemedicineColaboration] PRIMARY KEY CLUSTERED
(
	[TelemedicineCollaborationGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTelemedicineCollaboration]  WITH NOCHECK ADD  CONSTRAINT [FK_datTelemedicineColaboration_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datTelemedicineCollaboration] CHECK CONSTRAINT [FK_datTelemedicineColaboration_datAppointment]
GO
