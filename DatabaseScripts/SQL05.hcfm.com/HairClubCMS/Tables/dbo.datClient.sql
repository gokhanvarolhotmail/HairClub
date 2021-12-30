/* CreateDate: 05/05/2020 17:42:45.880 , ModifyDate: 03/08/2021 10:59:46.000 */
GO
CREATE TABLE [dbo].[datClient](
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[ClientNumber_Temp] [int] NULL,
	[CenterID] [int] NULL,
	[CountryID] [int] NULL,
	[SalutationID] [int] NULL,
	[ContactID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleName] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateID] [int] NULL,
	[PostalCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARBalance] [money] NULL,
	[GenderID] [int] NULL,
	[DateOfBirth] [datetime] NULL,
	[DoNotCallFlag] [bit] NULL,
	[DoNotContactFlag] [bit] NULL,
	[IsHairModelFlag] [bit] NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[EMailAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TextMessageAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone2] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone3] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1TypeID] [int] NULL,
	[Phone2TypeID] [int] NULL,
	[Phone3TypeID] [int] NULL,
	[IsPhone1PrimaryFlag] [bit] NULL,
	[IsPhone2PrimaryFlag] [bit] NULL,
	[IsPhone3PrimaryFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsHairSystemClientFlag] [bit] NULL,
	[TaxExemptNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentBioMatrixClientMembershipGUID] [uniqueidentifier] NULL,
	[CurrentSurgeryClientMembershipGUID] [uniqueidentifier] NULL,
	[CurrentExtremeTherapyClientMembershipGUID] [uniqueidentifier] NULL,
	[IsAutoConfirmTextPhone1] [bit] NULL,
	[IsAutoConfirmTextPhone2] [bit] NULL,
	[IsAutoConfirmTextPhone3] [bit] NULL,
	[ImportCreateDate] [datetime] NULL,
	[ImportLastUpdate] [datetime] NULL,
	[ClientMembershipCounter] [int] NOT NULL,
	[RequiredNoteReview] [bit] NOT NULL,
	[SiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmergencyContactPhone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleyProcedureOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleyConsultOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAutoConfirmEmail] [bit] NULL,
	[IsEmailUndeliverable] [bit] NOT NULL,
	[AcquiredDate] [datetime] NULL,
	[CurrentXtrandsClientMembershipGUID] [uniqueidentifier] NULL,
	[ExpectedConversionDate] [datetime] NULL,
	[LanguageID] [int] NULL,
	[IsConfirmCallPhone1] [bit] NULL,
	[IsConfirmCallPhone2] [bit] NULL,
	[IsConfirmCallPhone3] [bit] NULL,
	[AnniversaryDate] [datetime] NULL,
	[CanConfirmAppointmentByEmail] [bit] NULL,
	[CanContactForPromotionsByEmail] [bit] NULL,
	[DoNotVisitInRoom] [bit] NOT NULL,
	[DoNotMoveAppointments] [bit] NOT NULL,
	[IsAutoRenewDisabled] [bit] NOT NULL,
	[KorvueID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesforceContactID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientFullNameAltCalc]  AS (((isnull([FirstName],'')+case when len(isnull([MiddleName],''))>(0) then ' '+left([MiddleName],(1)) else '' end)+' ')+isnull([LastName],'')),
	[ClientFullNameCalc]  AS ((((isnull([LastName],'')+', ')+isnull([FirstName],''))+case when len(isnull([MiddleName],''))>(0) then ' '+left([MiddleName],(1)) else '' end)+case when len(isnull(CONVERT([varchar](20),[ClientIdentifier],(0)),''))>(0) then (' ('+CONVERT([varchar](20),[ClientIdentifier],(0)))+')' else '' end),
	[ClientFullNameAlt2Calc]  AS (((isnull([LastName],'')+', ')+isnull([FirstName],''))+rtrim(' '+ltrim(left(isnull([MiddleName],'')+'',(1))))),
	[ClientFullNameAlt3Calc]  AS ((isnull([FirstName],'')+' ')+isnull([LastName],'')),
	[AgeCalc]  AS (case when datepart(month,[DateOfBirth])<datepart(month,getdate()) OR datepart(month,[DateOfBirth])=datepart(month,getdate()) AND datepart(day,[DateOfBirth])<=datepart(day,getdate()) then datediff(year,[DateOfBirth],getdate()) else datediff(year,[DateOfBirth],getdate())-(1) end),
	[IsBioGraftClient] [bit] NOT NULL,
	[CurrentMDPClientMembershipGUID] [uniqueidentifier] NULL,
	[LeadCreateDate] [date] NULL,
	[BosleySalesforceAccountID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientOriginalCenterID] [int] NULL,
 CONSTRAINT [PK_datClient] PRIMARY KEY CLUSTERED
(
	[ClientGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datClient_CenterID_INCL] ON [dbo].[datClient]
(
	[CenterID] ASC
)
INCLUDE([ClientGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datClient_ClientIdentifier] ON [dbo].[datClient]
(
	[ClientIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClient_SalesforceContactID_INCL] ON [dbo].[datClient]
(
	[SalesforceContactID] ASC
)
INCLUDE([ClientIdentifier],[SiebelID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
