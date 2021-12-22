/* CreateDate: 10/22/2013 11:24:21.867 , ModifyDate: 10/22/2013 11:24:21.867 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[backup_cstd_noble_export_data](
	[ContactID] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FirstName] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateName] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCode] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeZone] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CntryCodePrePri] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaCodePri] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumberPri] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneTypeCodePri] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CntryCodePreBus] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaCodeBus] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumberBus] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneTypeCodeBus] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CntryCodePreHM] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaCodeHM] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumberHM] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneTypeCodeHM] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CntryCodePreCL] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaCodeCL] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumberCL] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneTypeCodeCL] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CntryCodePreHM2] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaCodeHM2] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumberHM2] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneTypeCodeHM2] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PrimaryCenterNum] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PrimaryCenterName] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeRangeDesc] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossAltDesc] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageDesc] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderDesc] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriSourceCodeDesc] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentSourceCode] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromoCodeDesc] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadCreationDate] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastActvityDate] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastResultDesc] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpenCallActivityId] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCodeDesc] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DueDate] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartTime] [nchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrOpenApptDate] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrOpenApptTime] [nchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateOfLastAppt] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastApptResultDesc] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TotalNumOfAppts] [int] NULL,
	[NumOfNoShowAppts] [int] NULL,
	[NumOfShowSaleAppts] [int] NULL,
	[NumOfCancelAppts] [int] NULL,
	[NumOfReschedAppts] [int] NULL,
	[CurrOpenApptType] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadCreatedBy] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__backup_cstd_noble_expor__6AC759D4] PRIMARY KEY CLUSTERED
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
