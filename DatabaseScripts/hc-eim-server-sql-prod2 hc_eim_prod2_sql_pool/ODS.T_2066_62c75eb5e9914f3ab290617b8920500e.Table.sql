/****** Object:  Table [ODS].[T_2066_62c75eb5e9914f3ab290617b8920500e]    Script Date: 3/1/2022 8:53:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[T_2066_62c75eb5e9914f3ab290617b8920500e]
(
	[AppointmentDetailGUID] [nvarchar](max) NULL,
	[AppointmentGUID] [nvarchar](max) NULL,
	[SalesCodeID] [int] NULL,
	[AppointmentDetailDuration] [int] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](19, 4) NULL,
	[rc1792a2ac5254fd5a4f86f42ca9e5f74] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
