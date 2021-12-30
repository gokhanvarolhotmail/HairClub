/* CreateDate: 05/05/2020 17:42:47.110 , ModifyDate: 05/05/2020 17:43:06.057 */
GO
CREATE TABLE [dbo].[lkpAppointmentType](
	[AppointmentTypeID] [int] NOT NULL,
	[AppointmentTypeSortOrder] [int] NULL,
	[AppointmentTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsCompanyFlag] [bit] NULL,
	[IsCenterFlag] [bit] NULL,
	[IsEmployeeFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAppointmentType] PRIMARY KEY CLUSTERED
(
	[AppointmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
