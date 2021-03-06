/****** Object:  Table [ODS].[VWTaskOld]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[VWTaskOld]
(
	[id] [varchar](8000) NULL,
	[Result__c] [varchar](8000) NULL,
	[CreatedDate] [varchar](8000) NULL,
	[Action__c] [varchar](8000) NULL,
	[ActivityDate] [varchar](8000) NULL,
	[SourceCode__c] [varchar](8000) NULL,
	[CenterNumber__c] [varchar](8000) NULL,
	[WhoId] [varchar](8000) NULL,
	[Accommodation__c] [varchar](8000) NULL,
	[CompletionDate__c] [varchar](8000) NULL,
	[EndTime__c] [varchar](8000) NULL,
	[IsNew] [varchar](8000) NULL,
	[IsDeleted] [varchar](8000) NULL,
	[IsOld] [varchar](8000) NULL,
	[ContactKey] [varchar](8000) NULL,
	[ContactId] [varchar](8000) NULL,
	[ReferralCode__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
