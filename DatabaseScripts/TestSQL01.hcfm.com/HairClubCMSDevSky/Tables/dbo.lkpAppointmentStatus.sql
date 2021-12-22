/* CreateDate: 07/23/2009 00:10:06.970 , ModifyDate: 12/07/2021 16:20:15.970 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpAppointmentStatus](
	[AppointmentStatusID] [int] NOT NULL,
	[AppointmentStatusSortOrder] [int] NOT NULL,
	[AppointmentStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AppointmentStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAppointmentStatusID] PRIMARY KEY CLUSTERED
(
	[AppointmentStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAppointmentStatus] ADD  CONSTRAINT [DF_lkpAppointmentStatus_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
