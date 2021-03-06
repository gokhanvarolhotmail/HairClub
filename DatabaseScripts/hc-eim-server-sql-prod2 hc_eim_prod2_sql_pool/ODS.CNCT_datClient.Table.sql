/****** Object:  Table [ODS].[CNCT_datClient]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_datClient]
(
	[ClientGUID] [varchar](8000) NULL,
	[ClientIdentifier] [int] NULL,
	[ClientNumber_Temp] [int] NULL,
	[CenterID] [int] NULL,
	[CountryID] [int] NULL,
	[SalutationID] [int] NULL,
	[ContactID] [varchar](8000) NULL,
	[FirstName] [varchar](8000) NULL,
	[MiddleName] [varchar](8000) NULL,
	[LastName] [varchar](8000) NULL,
	[Address1] [varchar](8000) NULL,
	[Address2] [varchar](8000) NULL,
	[Address3] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[StateID] [int] NULL,
	[PostalCode] [varchar](8000) NULL,
	[ARBalance] [numeric](19, 4) NULL,
	[GenderID] [int] NULL,
	[DateOfBirth] [datetime2](7) NULL,
	[DoNotCallFlag] [bit] NULL,
	[DoNotContactFlag] [bit] NULL,
	[IsHairModelFlag] [bit] NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[EMailAddress] [varchar](8000) NULL,
	[TextMessageAddress] [varchar](8000) NULL,
	[Phone1] [varchar](8000) NULL,
	[Phone2] [varchar](8000) NULL,
	[Phone3] [varchar](8000) NULL,
	[Phone1TypeID] [int] NULL,
	[Phone2TypeID] [int] NULL,
	[Phone3TypeID] [int] NULL,
	[IsPhone1PrimaryFlag] [bit] NULL,
	[IsPhone2PrimaryFlag] [bit] NULL,
	[IsPhone3PrimaryFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[IsHairSystemClientFlag] [bit] NULL,
	[TaxExemptNumber] [varchar](8000) NULL,
	[CurrentBioMatrixClientMembershipGUID] [varchar](8000) NULL,
	[CurrentSurgeryClientMembershipGUID] [varchar](8000) NULL,
	[CurrentExtremeTherapyClientMembershipGUID] [varchar](8000) NULL,
	[IsAutoConfirmTextPhone1] [bit] NULL,
	[IsAutoConfirmTextPhone2] [bit] NULL,
	[IsAutoConfirmTextPhone3] [bit] NULL,
	[ImportCreateDate] [datetime2](7) NULL,
	[ImportLastUpdate] [datetime2](7) NULL,
	[ClientMembershipCounter] [int] NULL,
	[RequiredNoteReview] [bit] NULL,
	[SiebelID] [varchar](8000) NULL,
	[EmergencyContactPhone] [varchar](8000) NULL,
	[BosleyProcedureOffice] [varchar](8000) NULL,
	[BosleyConsultOffice] [varchar](8000) NULL,
	[IsAutoConfirmEmail] [bit] NULL,
	[IsEmailUndeliverable] [bit] NULL,
	[AcquiredDate] [datetime2](7) NULL,
	[CurrentXtrandsClientMembershipGUID] [varchar](8000) NULL,
	[ExpectedConversionDate] [datetime2](7) NULL,
	[LanguageID] [int] NULL,
	[IsConfirmCallPhone1] [bit] NULL,
	[IsConfirmCallPhone2] [bit] NULL,
	[IsConfirmCallPhone3] [bit] NULL,
	[AnniversaryDate] [datetime2](7) NULL,
	[CanConfirmAppointmentByEmail] [bit] NULL,
	[CanContactForPromotionsByEmail] [bit] NULL,
	[DoNotVisitInRoom] [bit] NULL,
	[DoNotMoveAppointments] [bit] NULL,
	[IsAutoRenewDisabled] [bit] NULL,
	[KorvueID] [varchar](8000) NULL,
	[SalesforceContactID] [varchar](8000) NULL,
	[ClientFullNameAltCalc] [varchar](8000) NULL,
	[ClientFullNameCalc] [varchar](8000) NULL,
	[ClientFullNameAlt2Calc] [varchar](8000) NULL,
	[ClientFullNameAlt3Calc] [varchar](8000) NULL,
	[AgeCalc] [int] NULL,
	[IsBioGraftClient] [bit] NULL,
	[CurrentMDPClientMembershipGUID] [varchar](8000) NULL,
	[LeadCreateDate] [date] NULL,
	[BosleySalesforceAccountID] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
