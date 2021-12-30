/* CreateDate: 05/05/2020 17:42:53.597 , ModifyDate: 05/05/2020 17:43:15.980 */
GO
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
