/* CreateDate: 03/22/2022 08:26:04.133 , ModifyDate: 03/22/2022 08:26:04.133 */
GO
CREATE TABLE [dbo].[Survey_Response__c](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Lead__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Id__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Contact__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Contact_Id__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[First_Name__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Last_Name__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email__c] [nvarchar](105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Postal_Code__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Region_Code__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Region_Name__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country_Code__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country_Name__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey_Name__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Full_Text__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Trigger_Task_Id__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordTypeId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Start_Time__c] [datetime] NULL,
	[Completion_Time__c] [datetime] NULL,
	[Status__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Review_Status__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Reviewed_By__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[API_ID__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Case__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Case_Id__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Chat_Transcript__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Chat_Transcript_Id__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF1_10__c] [int] NULL,
	[GF1_20__c] [int] NULL,
	[GF1_30__c] [int] NULL,
	[GF1_40__c] [int] NULL,
	[GF1_50__c] [int] NULL,
	[GF1_60__c] [int] NULL,
	[GF1_70__c] [int] NULL,
	[GF1_80__c] [int] NULL,
	[GF1_90__c] [int] NULL,
	[GF1_100__c] [int] NULL,
	[GF2_10__c] [int] NULL,
	[GF2_20__c] [int] NULL,
	[GF2_30__c] [int] NULL,
	[GF2_40__c] [int] NULL,
	[GF2_50__c] [int] NULL,
	[GF2_60__c] [int] NULL,
	[GF2_70__c] [int] NULL,
	[GF2_80__c] [int] NULL,
	[GF2_90__c] [int] NULL,
	[GF310__c] [int] NULL,
	[GF3100__c] [int] NULL,
	[GF3110__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF3120__c] [int] NULL,
	[GF3130__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF3140__c] [int] NULL,
	[GF3150__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF3160__c] [int] NULL,
	[GF3170__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF3180__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF3190__c] [int] NULL,
	[GF320__c] [int] NULL,
	[GF3200__c] [int] NULL,
	[GF3210__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF3220__c] [int] NULL,
	[GF3230__c] [int] NULL,
	[GF330__c] [int] NULL,
	[GF340__c] [int] NULL,
	[GF350__c] [int] NULL,
	[GF360__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF370__c] [int] NULL,
	[GF380__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF390__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF410__c] [int] NULL,
	[GF4100__c] [int] NULL,
	[GF4110__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF4120__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF4130__c] [int] NULL,
	[GF4140__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF4150__c] [int] NULL,
	[GF4160__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF4170__c] [int] NULL,
	[GF4180__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF4190__c] [int] NULL,
	[GF420__c] [int] NULL,
	[GF4200__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF4210__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF4220__c] [int] NULL,
	[GF4230__c] [int] NULL,
	[GF4240__c] [int] NULL,
	[GF4250__c] [int] NULL,
	[GF4260__c] [int] NULL,
	[GF4270__c] [int] NULL,
	[GF4280__c] [int] NULL,
	[GF4290__c] [int] NULL,
	[GF430__c] [int] NULL,
	[GF4300__c] [int] NULL,
	[GF4310__c] [int] NULL,
	[GF4320__c] [int] NULL,
	[GF440__c] [int] NULL,
	[GF450__c] [int] NULL,
	[GF460__c] [int] NULL,
	[GF470__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GF480__c] [int] NULL,
	[GF490__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gf_id__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gf_unique__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IP_Address__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Link_to_Response__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Link_to_Summary_Report__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
