/* CreateDate: 05/05/2020 17:42:47.007 , ModifyDate: 05/05/2020 17:43:06.043 */
GO
CREATE TABLE [dbo].[lkpAppointmentPriorityColor](
	[AppointmentPriorityColorID] [int] NOT NULL,
	[AppointmentPriorityColorSortOrder] [int] NOT NULL,
	[AppointmentPriorityColorDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AppointmentPriorityColorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpAppointmentPriorityColor] PRIMARY KEY CLUSTERED
(
	[AppointmentPriorityColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
