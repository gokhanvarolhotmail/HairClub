/* CreateDate: 07/07/2017 09:42:40.940 , ModifyDate: 07/07/2017 14:15:02.717 */
GO
CREATE TABLE [dbo].[datClientExport](
	[ClientExportID] [int] IDENTITY(1,1) NOT NULL,
	[ExportHeaderID] [int] NOT NULL,
	[RegionSSID] [int] NULL,
	[RegionName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterSSID] [int] NULL,
	[CenterName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress1] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterCity] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterZipCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterCountry] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterPhoneNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterManagingDirector] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterManagingDirectorEmail] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [int] NULL,
	[ClientFirstName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientLastName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientAddress1] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientAddress2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientCity] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientZipCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientCountry] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientTimezone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanConfirmAppointmentByPhone1Text] [bit] NULL,
	[CanContactForPromotionsByPhone1Text] [bit] NULL,
	[Phone2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone2Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanConfirmAppointmentByPhone2Text] [bit] NULL,
	[CanContactForPromotionsByPhone2Text] [bit] NULL,
	[Phone3] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone3Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanConfirmAppointmentByPhone3Text] [bit] NULL,
	[CanContactForPromotionsByPhone3Text] [bit] NULL,
	[SMSPhoneNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientDateOfBirth] [datetime] NULL,
	[ClientAge] [int] NULL,
	[ClientEmailAddress] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientGender] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SiebelID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicitySSID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientEthinicityDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationSSID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientOccupationDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusSSID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMaritalStatusDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InitialSaleDate] [datetime] NULL,
	[NBConsultant] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NBConsultantName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NBConsultantEmail] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InitialApplicationDate] [datetime] NULL,
	[ConversionDate] [datetime] NULL,
	[MembershipAdvisor] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipAdvisorName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipAdvisorEmail] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstAppointmentDate] [datetime] NULL,
	[LastAppointmentDate] [datetime] NULL,
	[NextAppointmentGUID] [uniqueidentifier] NULL,
	[NextAppointmentCenterID] [int] NULL,
	[NextAppointmentDate] [datetime] NULL,
	[NextAppointmentTime] [datetime] NULL,
	[StylistFirstName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StylistLastName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstEXTServiceDate] [datetime] NULL,
	[FirstXtrandServiceDate] [datetime] NULL,
	[BIO_Membership] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BIO_BeginDate] [datetime] NULL,
	[BIO_EndDate] [datetime] NULL,
	[BIO_MembershipStatus] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BIO_MonthlyFee] [money] NULL,
	[BIO_ContractPrice] [money] NULL,
	[BIO_CancelDate] [datetime] NULL,
	[BIO_CancelReasonDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_Membership] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_BeginDate] [datetime] NULL,
	[EXT_EndDate] [datetime] NULL,
	[EXT_MembershipStatus] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_MonthlyFee] [money] NULL,
	[EXT_ContractPrice] [money] NULL,
	[EXT_CancelDate] [datetime] NULL,
	[EXT_CancelReasonDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_Membership] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_BeginDate] [datetime] NULL,
	[XTR_EndDate] [datetime] NULL,
	[XTR_MembershipStatus] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_MonthlyFee] [money] NULL,
	[XTR_ContractPrice] [money] NULL,
	[XTR_CancelDate] [datetime] NULL,
	[XTR_CancelReasonDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_Membership] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_BeginDate] [datetime] NULL,
	[SUR_EndDate] [datetime] NULL,
	[SUR_MembershipStatus] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_MonthlyFee] [money] NULL,
	[SUR_ContractPrice] [money] NULL,
	[SUR_CancelDate] [datetime] NULL,
	[SUR_CancelReasonDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotCallFlag] [bit] NULL,
	[DoNotContactFlag] [bit] NULL,
	[IsAutoConfirmEmail] [bit] NULL,
	[Mosaic_Household] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Household_Group] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Household_Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Zip] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Zip_Group] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Zip_Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Gender] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Combined_Age] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Education_Model] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Marital_Status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Occupation_Group_V2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Latitude] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Longitude] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Match_Level_For_Geo_Data] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Est_Household_Income_V5] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_NCOA_Move_Update_Code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Mail_Responder] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_MOR_Bank_Upscale_Merchandise_Buyer] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_MOR_Bank_Health_And_Fitness_Magazine] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Ethnic_Pop_White_Only] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Ethnic_Pop_Black_Only] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Ethnic_Pop_Asian_Only] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Ethnic_Pop_Hispanic] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_Lang_HH_Spanish_Speaking] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_Cape_INC_HH_Median_Family_Household_Income] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_MatchStatus] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datClientExport] PRIMARY KEY CLUSTERED
(
	[ClientExportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientExport_CenterSSID] ON [dbo].[datClientExport]
(
	[CenterSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClientExport_CenterType] ON [dbo].[datClientExport]
(
	[CenterType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientExport_ClientIdentifier] ON [dbo].[datClientExport]
(
	[ClientIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientExport_CreateDate] ON [dbo].[datClientExport]
(
	[CreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientExport_ExportHeaderID] ON [dbo].[datClientExport]
(
	[ExportHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientExport_LastUpdate] ON [dbo].[datClientExport]
(
	[LastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClientExport_LeadID] ON [dbo].[datClientExport]
(
	[LeadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientExport_RegionSSID] ON [dbo].[datClientExport]
(
	[RegionSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
