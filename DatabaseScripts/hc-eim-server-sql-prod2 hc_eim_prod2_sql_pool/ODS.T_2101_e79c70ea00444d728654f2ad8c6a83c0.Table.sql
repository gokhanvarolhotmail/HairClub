/****** Object:  Table [ODS].[T_2101_e79c70ea00444d728654f2ad8c6a83c0]    Script Date: 2/18/2022 8:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[T_2101_e79c70ea00444d728654f2ad8c6a83c0]
(
	[PhoneTypeID] [int] NULL,
	[PhoneTypeSortOrder] [int] NULL,
	[PhoneTypeDescription] [nvarchar](max) NULL,
	[PhoneTypeDescriptionShort] [nvarchar](max) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[CanTextMessageFlag] [bit] NULL,
	[PhoneSegmentId] [int] NULL,
	[DescriptionResourceKey] [nvarchar](max) NULL,
	[r6f6316385d134b77a7dc0f5229e82d66] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
