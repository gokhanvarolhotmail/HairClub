/* CreateDate: 07/27/2015 15:37:09.943 , ModifyDate: 05/26/2020 10:49:14.367 */
GO
CREATE TABLE [dbo].[lkpAppointmentPriorityColor](
	[AppointmentPriorityColorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
