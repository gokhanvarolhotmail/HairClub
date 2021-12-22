CREATE TABLE [dbo].[datTelemedicineCollaborationComment](
	[TelemedicineCollaborationCommentGUID] [uniqueidentifier] NOT NULL,
	[TelemedicineCollaborationGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[Details] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datTelemedicineCollaborationComment] PRIMARY KEY CLUSTERED
(
	[TelemedicineCollaborationCommentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTelemedicineCollaborationComment]  WITH CHECK ADD  CONSTRAINT [FK_datTelemedicineCollaborationComment_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datTelemedicineCollaborationComment] CHECK CONSTRAINT [FK_datTelemedicineCollaborationComment_datEmployee]
