/****** Object:  Table [ODS].[CNCT_datAppointmentEmployee]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_datAppointmentEmployee]
(
	[AppointmentEmployeeGUID] [uniqueidentifier] NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](50) NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [AppointmentGUID] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO
