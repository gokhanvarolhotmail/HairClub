/* CreateDate: 10/30/2008 10:42:15.573 , ModifyDate: 12/07/2021 16:20:15.817 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAppointmentType] ADD  CONSTRAINT [DF_lkpAppointmentType_IsCompanyFlag]  DEFAULT ((0)) FOR [IsCompanyFlag]
GO
ALTER TABLE [dbo].[lkpAppointmentType] ADD  CONSTRAINT [DF_lkpAppointmentType_IsCenterFlag]  DEFAULT ((0)) FOR [IsCenterFlag]
GO
ALTER TABLE [dbo].[lkpAppointmentType] ADD  CONSTRAINT [DF_lkpAppointmentType_IsEmployeeFlag]  DEFAULT ((0)) FOR [IsEmployeeFlag]
GO
ALTER TABLE [dbo].[lkpAppointmentType] ADD  CONSTRAINT [DF_lkpAppointmentType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
