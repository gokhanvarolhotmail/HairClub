/* CreateDate: 03/03/2022 13:54:35.160 , ModifyDate: 03/05/2022 13:04:15.513 */
GO
CREATE TABLE [SFStaging].[ServiceResourceSkill](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[SkillNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[ServiceResourceId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SkillId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SkillLevel] [decimal](2, 2) NULL,
	[EffectiveStartDate] [datetime2](7) NULL,
	[EffectiveEndDate] [datetime2](7) NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_ServiceResourceSkill] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
