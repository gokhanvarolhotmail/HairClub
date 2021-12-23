/* CreateDate: 03/20/2009 10:29:24.960 , ModifyDate: 12/03/2021 10:24:48.700 */
GO
CREATE TABLE [dbo].[datClient](
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientIdentifier] [int] IDENTITY(1000,1) NOT FOR REPLICATION NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClient_ClientIdentifier] ON [dbo].[datClient]
(
	[ClientIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClient_ContactID_SiebelID] ON [dbo].[datClient]
(
	[ContactID] ASC,
	[SiebelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClient_CurrentBioMatrixClientMembershipGUID] ON [dbo].[datClient]
(
	[CurrentBioMatrixClientMembershipGUID] ASC
)
INCLUDE([ClientGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClient_CurrentExtremeTherapyClientMembershipGUID] ON [dbo].[datClient]
(
	[CurrentExtremeTherapyClientMembershipGUID] ASC
)
INCLUDE([ClientGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClient_CurrentSurgeryClientMembershipGUID] ON [dbo].[datClient]
(
	[CurrentSurgeryClientMembershipGUID] ASC
)
INCLUDE([ClientGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClient_CurrentXtrandsClientMembershipGUID] ON [dbo].[datClient]
(
	[CurrentXtrandsClientMembershipGUID] ASC
)
INCLUDE([ClientGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClient_FirstName_LastName] ON [dbo].[datClient]
(
	[FirstName] ASC,
	[LastName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datClient_SalesforceContactID] ON [dbo].[datClient]
(
	[SalesforceContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datClient_CenterID_ClientGUID] ON [dbo].[datClient]
(
	[CenterID] ASC,
	[ClientGUID] ASC
)
INCLUDE([ARBalance],[ClientIdentifier],[FirstName],[LastName],[Phone1],[Phone2],[CurrentBioMatrixClientMembershipGUID],[CurrentSurgeryClientMembershipGUID],[CurrentExtremeTherapyClientMembershipGUID],[CurrentXtrandsClientMembershipGUID],[ClientFullNameCalc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datClient_ClientIdentifier] ON [dbo].[datClient]
(
	[ClientIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UK_datClient_IncludeNameInfo] ON [dbo].[datClient]
(
	[ClientGUID] ASC
)
INCLUDE([CenterID],[ClientFullNameCalc],[ClientIdentifier],[FirstName],[LastName],[MiddleName],[IsAutoRenewDisabled]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClient] ADD  CONSTRAINT [DF_datClient_ARBalance]  DEFAULT ((0)) FOR [ARBalance]
GO
ALTER TABLE [dbo].[datClient] ADD  CONSTRAINT [DF_datClient_DoNotCallFlag]  DEFAULT ((0)) FOR [DoNotCallFlag]
GO
ALTER TABLE [dbo].[datClient] ADD  CONSTRAINT [DF_datClient_DoNotContactFlag]  DEFAULT ((0)) FOR [DoNotContactFlag]
GO
ALTER TABLE [dbo].[datClient] ADD  CONSTRAINT [DF_datClient_IsHairModelFlag]  DEFAULT ((0)) FOR [IsHairModelFlag]
GO
ALTER TABLE [dbo].[datClient] ADD  CONSTRAINT [DF_datClient_IsTaxExemptFlag]  DEFAULT ((0)) FOR [IsTaxExemptFlag]
GO
ALTER TABLE [dbo].[datClient] ADD  CONSTRAINT [DF_datClient_IsPhone1PrimaryFlag]  DEFAULT ((0)) FOR [IsPhone1PrimaryFlag]
GO
ALTER TABLE [dbo].[datClient] ADD  CONSTRAINT [DF_datClient_IsPhone2PrimaryFlag]  DEFAULT ((0)) FOR [IsPhone2PrimaryFlag]
GO
ALTER TABLE [dbo].[datClient] ADD  CONSTRAINT [DF_datClient_IsPhone3PrimaryFlag]  DEFAULT ((0)) FOR [IsPhone3PrimaryFlag]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [IsHairSystemClientFlag]
GO
ALTER TABLE [dbo].[datClient] ADD  CONSTRAINT [DF_datClient_ClientMembershipCounter]  DEFAULT ((0)) FOR [ClientMembershipCounter]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [RequiredNoteReview]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [IsEmailUndeliverable]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [AcquiredDate]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [IsConfirmCallPhone1]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [IsConfirmCallPhone2]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [IsConfirmCallPhone3]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [DoNotVisitInRoom]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [DoNotMoveAppointments]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [IsAutoRenewDisabled]
GO
ALTER TABLE [dbo].[datClient] ADD  DEFAULT ((0)) FOR [IsBioGraftClient]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_cfgCenter]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_CurrentMDPClientMembershipGUID] FOREIGN KEY([CurrentMDPClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_CurrentMDPClientMembershipGUID]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_datClientMembership_CurrentBioMatrixClientMembershipGUID] FOREIGN KEY([CurrentBioMatrixClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_datClientMembership_CurrentBioMatrixClientMembershipGUID]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_datClientMembership_CurrentExtremeTherapyClientMembershipGUID] FOREIGN KEY([CurrentExtremeTherapyClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_datClientMembership_CurrentExtremeTherapyClientMembershipGUID]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_datClientMembership_CurrentSurgeryClientMembershipGUID] FOREIGN KEY([CurrentSurgeryClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_datClientMembership_CurrentSurgeryClientMembershipGUID]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_datClientMembership_CurrentXtrandsClientMembershipGUID] FOREIGN KEY([CurrentXtrandsClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_datClientMembership_CurrentXtrandsClientMembershipGUID]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_lkpCountry] FOREIGN KEY([CountryID])
REFERENCES [dbo].[lkpCountry] ([CountryID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_lkpCountry]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_lkpGender] FOREIGN KEY([GenderID])
REFERENCES [dbo].[lkpGender] ([GenderID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_lkpGender]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_lkpLanguage] FOREIGN KEY([LanguageID])
REFERENCES [dbo].[lkpLanguage] ([LanguageID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_lkpLanguage]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_lkpSalutation] FOREIGN KEY([SalutationID])
REFERENCES [dbo].[lkpSalutation] ([SalutationID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_lkpSalutation]
GO
ALTER TABLE [dbo].[datClient]  WITH CHECK ADD  CONSTRAINT [FK_datClient_lkpState] FOREIGN KEY([StateID])
REFERENCES [dbo].[lkpState] ([StateID])
GO
ALTER TABLE [dbo].[datClient] CHECK CONSTRAINT [FK_datClient_lkpState]
GO
