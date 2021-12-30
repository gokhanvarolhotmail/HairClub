/* CreateDate: 05/05/2020 17:42:53.547 , ModifyDate: 05/05/2020 17:43:15.973 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
