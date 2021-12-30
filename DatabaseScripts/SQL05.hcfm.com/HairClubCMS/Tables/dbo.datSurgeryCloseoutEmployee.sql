/* CreateDate: 05/05/2020 17:42:51.993 , ModifyDate: 05/05/2020 18:41:08.783 */
GO
CREATE TABLE [dbo].[datSurgeryCloseoutEmployee](
	[SurgeryCloseoutEmployeeGUID] [uniqueidentifier] NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[CutCount] [int] NULL,
	[PlaceCount] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_SurgeryCloseoutEmployee] PRIMARY KEY CLUSTERED
(
	[SurgeryCloseoutEmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
