/* CreateDate: 10/04/2010 12:08:45.110 , ModifyDate: 12/07/2021 16:20:15.973 */
GO
CREATE TABLE [dbo].[cfgAppointmentManagementConfiguration](
	[AppointmentManagementConfigurationID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppointmentManagementConfigurationSortOrder] [int] NOT NULL,
	[AppointmentManagementConfigurationDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AppointmentManagementConfigurationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AppointmentManagementConfigurationValue] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgAppointmentManagementConfiguration] PRIMARY KEY CLUSTERED
(
	[AppointmentManagementConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgAppointmentManagementConfiguration] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
