/****** Object:  Table [ODS].[CNCT_CenterOwnership]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_CenterOwnership]
(
	[CenterOwnershipID] [int] NULL,
	[CenterOwnershipSortOrder] [int] NULL,
	[CenterOwnershipDescription] [varchar](8000) NULL,
	[CenterOwnershipDescriptionShort] [varchar](8000) NULL,
	[OwnerLastName] [varchar](8000) NULL,
	[OwnerFirstName] [varchar](8000) NULL,
	[CorporateName] [varchar](8000) NULL,
	[Address1] [varchar](8000) NULL,
	[Address2] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[StateID] [int] NULL,
	[PostalCode] [varchar](8000) NULL,
	[CountryID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[IsClientExperienceSurveyEnabled] [bit] NULL,
	[ClientExperienceSurveyDelayDays] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
