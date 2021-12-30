/* CreateDate: 01/24/2017 11:41:05.903 , ModifyDate: 05/18/2018 20:11:11.343 */
GO
CREATE TABLE [dbo].[datClientLeadMerge](
	[ClientLeadMergeID] [int] IDENTITY(1,1) NOT NULL,
	[ExportHeaderID] [int] NOT NULL,
	[RegionID] [int] NULL,
	[RegionName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
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
	[ClientIdentifier] [int] NULL,
	[LeadID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Timezone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateOfBirth] [datetime] NULL,
	[Age] [int] NULL,
	[AgeRange] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SiebelID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone2] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone2Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone3] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone3Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNCDate] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperienceCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamilyCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossInFamilyCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProduct] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpotCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromotionCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceMedia] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceFormat] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MarketingScore] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DiscStyle] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ethnicity] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoSaleReason] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceQuoted] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SolutionOffered] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Performer] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PerformerName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PerformerEmail] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityCreationDate] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityActionCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityResultCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivitySourceCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDueDate] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityStartTime] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityCompletionDate] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityCompletionTime] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrochureCreationDate] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrochureActionCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrochureResultCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrochureSourceCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrochureDueDate] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrochureStartTime] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrochureCompletionDate] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BrochureCompletionTime] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[NextAppointmentDate] [datetime] NULL,
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
	[IsAutoConfirmEmail] [bit] NULL,
	[DoNotContact] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotText] [bit] NULL,
	[DoNotEmail] [bit] NULL,
	[DoNotMail] [bit] NULL,
	[DoNotSolicit] [bit] NULL,
	[RecordStatus] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadCreateDate] [datetime] NULL,
	[ClientCreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LeadLastUpdate] [datetime] NULL,
	[ClientLastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NextAppointmentGUID] [uniqueidentifier] NULL,
	[StylistFirstName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StylistLastName] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NextAppointmentTime] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
	[LeadAddressID] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NextAppointmentCenterID] [int] NULL,
	[SMSPhoneNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanConfirmAppointmentByPhone1Text] [bit] NULL,
	[CanContactForPromotionsByPhone1Text] [bit] NULL,
	[CanConfirmAppointmentByPhone2Text] [bit] NULL,
	[CanContactForPromotionsByPhone2Text] [bit] NULL,
	[CanConfirmAppointmentByPhone3Text] [bit] NULL,
	[CanContactForPromotionsByPhone3Text] [bit] NULL,
	[CanConfirmConsultationByText] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datClientLeadMerge] PRIMARY KEY CLUSTERED
(
	[ClientLeadMergeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_CenterID] ON [dbo].[datClientLeadMerge]
(
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_CenterType] ON [dbo].[datClientLeadMerge]
(
	[CenterType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_ClientCreateDate] ON [dbo].[datClientLeadMerge]
(
	[ClientCreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_ClientIdentifier] ON [dbo].[datClientLeadMerge]
(
	[ClientIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_ClientLastUpdate] ON [dbo].[datClientLeadMerge]
(
	[ClientLastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_ExportHeaderID] ON [dbo].[datClientLeadMerge]
(
	[ExportHeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_LeadCreateDate] ON [dbo].[datClientLeadMerge]
(
	[LeadCreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_LeadID] ON [dbo].[datClientLeadMerge]
(
	[LeadID] ASC
)
INCLUDE([ClientIdentifier]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_LeadLastUpdate] ON [dbo].[datClientLeadMerge]
(
	[LeadLastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_RecordStatus] ON [dbo].[datClientLeadMerge]
(
	[RecordStatus] ASC
)
INCLUDE([ClientIdentifier]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientLeadMerge_RegionSSID] ON [dbo].[datClientLeadMerge]
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientLeadMerge] ADD  CONSTRAINT [DF_datClientLeadMerge_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[datClientLeadMerge] ADD  CONSTRAINT [DF_datClientLeadMerge_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
