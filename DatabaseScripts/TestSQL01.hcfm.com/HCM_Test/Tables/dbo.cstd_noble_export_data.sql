/* CreateDate: 12/09/2008 00:11:16.673 , ModifyDate: 09/10/2019 22:38:45.703 */
GO
CREATE TABLE [dbo].[cstd_noble_export_data](
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
 CONSTRAINT [PK__cstd_noble_expor__6AC759D4] PRIMARY KEY CLUSTERED
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_noble_export_data_i2] ON [dbo].[cstd_noble_export_data]
(
	[OpenCallActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
