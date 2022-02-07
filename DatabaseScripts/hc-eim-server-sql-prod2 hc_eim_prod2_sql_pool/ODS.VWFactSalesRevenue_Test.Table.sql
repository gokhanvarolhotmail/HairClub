/****** Object:  Table [ODS].[VWFactSalesRevenue_Test]    Script Date: 2/7/2022 10:45:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[VWFactSalesRevenue_Test]
(
	[so_SalesOrderGUID] [nvarchar](2500) NULL,
	[so_TenderTransactionNumber_Temp] [int] NULL,
	[so_TicketNumber_Temp] [int] NULL,
	[so_CenterID] [int] NULL,
	[so_ClientHomeCenterID] [int] NULL,
	[so_SalesOrderTypeID] [int] NULL,
	[so_ClientGUID] [nvarchar](2500) NULL,
	[so_ClientMembershipGUID] [nvarchar](2500) NULL,
	[so_AppointmentGUID] [nvarchar](2500) NULL,
	[so_HairSystemOrderGUID] [nvarchar](2500) NULL,
	[so_OrderDate] [datetime2](7) NULL,
	[so_InvoiceNumber] [nvarchar](2500) NULL,
	[so_IsTaxExemptFlag] [bit] NULL,
	[so_IsVoidedFlag] [bit] NULL,
	[so_IsClosedFlag] [bit] NULL,
	[so_RegisterCloseGUID] [nvarchar](2500) NULL,
	[so_EmployeeGUID] [nvarchar](2500) NULL,
	[so_FulfillmentNumber] [nvarchar](2500) NULL,
	[so_IsWrittenOffFlag] [bit] NULL,
	[so_IsRefundedFlag] [bit] NULL,
	[so_RefundedSalesOrderGUID] [nvarchar](2500) NULL,
	[so_CreateDate] [datetime2](7) NULL,
	[so_CreateUser] [nvarchar](2500) NULL,
	[so_LastUpdate] [datetime2](7) NULL,
	[so_LastUpdateUser] [nvarchar](2500) NULL,
	[so_ParentSalesOrderGUID] [nvarchar](2500) NULL,
	[so_IsSurgeryReversalFlag] [bit] NULL,
	[so_IsGuaranteeFlag] [bit] NULL,
	[so_cashier_temp] [nvarchar](2500) NULL,
	[so_ctrOrderDate] [datetime2](7) NULL,
	[so_CenterFeeBatchGUID] [nvarchar](2500) NULL,
	[so_CenterDeclineBatchGUID] [nvarchar](2500) NULL,
	[so_RegisterID] [int] NULL,
	[so_EndOfDayGUID] [nvarchar](2500) NULL,
	[so_IncomingRequestID] [int] NULL,
	[so_WriteOffSalesOrderGUID] [nvarchar](2500) NULL,
	[so_NSFSalesOrderGUID] [nvarchar](2500) NULL,
	[so_ChargeBackSalesOrderGUID] [nvarchar](2500) NULL,
	[so_ChargebackReasonID] [int] NULL,
	[so_InterCompanyTransactionID] [int] NULL,
	[so_WriteOffReasonDescription] [nvarchar](2500) NULL,
	[sod_SalesOrderDetailGUID] [nvarchar](2500) NULL,
	[sod_TransactionNumber_Temp] [int] NULL,
	[sod_SalesOrderGUID] [nvarchar](255) NULL,
	[sod_SalesCodeID] [int] NULL,
	[sod_Quantity] [int] NULL,
	[sod_Price] [decimal](21, 6) NULL,
	[sod_Discount] [decimal](19, 4) NULL,
	[sod_Tax1] [decimal](19, 4) NULL,
	[sod_Tax2] [decimal](19, 4) NULL,
	[sod_TaxRate1] [decimal](6, 5) NULL,
	[sod_TaxRate2] [decimal](6, 5) NULL,
	[sod_IsRefundedFlag] [bit] NULL,
	[sod_RefundedSalesOrderDetailGUID] [nvarchar](255) NULL,
	[sod_RefundedTotalQuantity] [int] NULL,
	[sod_RefundedTotalPrice] [decimal](19, 4) NULL,
	[sod_Employee1GUID] [nvarchar](255) NULL,
	[sod_Employee2GUID] [nvarchar](255) NULL,
	[sod_Employee3GUID] [nvarchar](255) NULL,
	[sod_Employee4GUID] [nvarchar](255) NULL,
	[sod_PreviousClientMembershipGUID] [nvarchar](255) NULL,
	[sod_NewCenterID] [int] NULL,
	[sod_ExtendedPriceCalc] [decimal](33, 6) NULL,
	[sod_TotalTaxCalc] [decimal](19, 4) NULL,
	[sod_PriceTaxCalc] [decimal](35, 6) NULL,
	[sod_CreateDate] [datetime2](7) NULL,
	[sod_LastUpdate] [datetime2](7) NULL,
	[sod_Center_Temp] [int] NULL,
	[sod_Member1Price_temp] [decimal](21, 6) NULL,
	[sod_CancelReasonID] [int] NULL,
	[sod_EntrySortOrder] [int] NULL,
	[sod_HairSystemOrderGUID] [nvarchar](255) NULL,
	[sod_DiscountTypeID] [int] NULL,
	[sod_BenefitTrackingEnabledFlag] [bit] NULL,
	[sod_MembershipPromotionID] [int] NULL,
	[sod_MembershipOrderReasonID] [int] NULL,
	[sod_MembershipNotes] [nvarchar](255) NULL,
	[sod_GenericSalesCodeDescription] [nvarchar](255) NULL,
	[sod_SalesCodeSerialNumber] [nvarchar](255) NULL,
	[sod_WriteOffSalesOrderDetailGUID] [nvarchar](255) NULL,
	[sod_NSFBouncedDate] [datetime2](7) NULL,
	[sod_IsWrittenOffFlag] [bit] NULL,
	[sod_InterCompanyPrice] [decimal](19, 4) NULL,
	[sod_TaxType1ID] [int] NULL,
	[sod_TaxType2ID] [int] NULL,
	[sod_ClientMembershipAddOnID] [int] NULL,
	[sod_NCCMembershipPromotionID] [int] NULL,
	[sc_SalesCodeID] [int] NULL,
	[sc_SalesCodeSortOrder] [int] NULL,
	[sc_SalesCodeDescription] [nvarchar](2500) NULL,
	[sc_SalesCodeDescriptionShort] [nvarchar](2500) NULL,
	[sc_SalesCodeTypeID] [int] NULL,
	[sc_SalesCodeDepartmentID] [int] NULL,
	[sc_VendorID] [int] NULL,
	[sc_Barcode] [nvarchar](2500) NULL,
	[sc_PriceDefault] [numeric](19, 4) NULL,
	[sc_GLNumber] [int] NULL,
	[sc_ServiceDuration] [int] NULL,
	[sc_CanScheduleFlag] [bit] NULL,
	[sc_FactoryOrderFlag] [bit] NULL,
	[sc_IsRefundableFlag] [bit] NULL,
	[sc_InventoryFlag] [bit] NULL,
	[sc_SurgeryCloseoutFlag] [bit] NULL,
	[sc_TechnicalProfileFlag] [bit] NULL,
	[sc_AdjustContractPaidAmountFlag] [bit] NULL,
	[sc_IsPriceAdjustableFlag] [bit] NULL,
	[sc_IsDiscountableFlag] [bit] NULL,
	[sc_IsActiveFlag] [bit] NULL,
	[sc_CreateDate] [datetime2](7) NULL,
	[sc_CreateUser] [nvarchar](2500) NULL,
	[sc_LastUpdate] [datetime2](7) NULL,
	[sc_LastUpdateUser] [nvarchar](2500) NULL,
	[sc_IsARTenderRequiredFlag] [bit] NULL,
	[sc_CanOrderFlag] [bit] NULL,
	[sc_IsQuantityAdjustableFlag] [bit] NULL,
	[sc_IsPhotoEnabledFlag] [bit] NULL,
	[sc_IsEXTOnlyProductFlag] [bit] NULL,
	[sc_HairSystemID] [int] NULL,
	[sc_SaleCount] [int] NULL,
	[sc_IsSalesCodeKitFlag] [bit] NULL,
	[sc_BIOGeneralLedgerID] [int] NULL,
	[sc_EXTGeneralLedgerID] [int] NULL,
	[sc_SURGeneralLedgerID] [int] NULL,
	[sc_BrandID] [int] NULL,
	[sc_Product] [nvarchar](2500) NULL,
	[sc_Size] [nvarchar](2500) NULL,
	[sc_IsRefundablePayment] [bit] NULL,
	[sc_IsNSFChargebackFee] [bit] NULL,
	[sc_InterCompanyPrice] [numeric](19, 4) NULL,
	[sc_IsQuantityRequired] [bit] NULL,
	[sc_XTRGeneralLedgerID] [int] NULL,
	[sc_DescriptionResourceKey] [nvarchar](2500) NULL,
	[sc_IsBosleySalesCode] [bit] NULL,
	[sc_IsVisibleToConsultant] [bit] NULL,
	[sc_IsSerialized] [bit] NULL,
	[sc_SerialNumberRegEx] [nvarchar](2500) NULL,
	[sc_QuantityPerPack] [int] NULL,
	[sc_PackUnitOfMeasureID] [int] NULL,
	[sc_InventorySalesCodeID] [int] NULL,
	[sc_IsVisibleToClient] [bit] NULL,
	[sc_CanBeManagedByClient] [bit] NULL,
	[sc_IsManagedByClientOnly] [bit] NULL,
	[sc_ClientDescription] [nvarchar](2500) NULL,
	[sc_MDPGeneralLedgerID] [int] NULL,
	[sc_PackSKU] [nvarchar](2500) NULL,
	[sc_IsBackBarApproved] [bit] NULL,
	[cm_ClientMembershipGUID] [nvarchar](2500) NULL,
	[cm_Member1_ID_Temp] [int] NULL,
	[cm_ClientGUID] [nvarchar](2500) NULL,
	[cm_CenterID] [int] NULL,
	[cm_MembershipID] [int] NULL,
	[cm_ClientMembershipStatusID] [int] NULL,
	[cm_ContractPrice] [numeric](19, 4) NULL,
	[cm_ContractPaidAmount] [numeric](19, 4) NULL,
	[cm_MonthlyFee] [numeric](19, 4) NULL,
	[cm_BeginDate] [date] NULL,
	[cm_EndDate] [date] NULL,
	[cm_MembershipCancelReasonID] [int] NULL,
	[cm_CancelDate] [datetime2](7) NULL,
	[cm_IsGuaranteeFlag] [bit] NULL,
	[cm_IsRenewalFlag] [bit] NULL,
	[cm_IsMultipleSurgeryFlag] [bit] NULL,
	[cm_RenewalCount] [int] NULL,
	[cm_IsActiveFlag] [bit] NULL,
	[cm_CreateDate] [datetime2](7) NULL,
	[cm_CreateUser] [nvarchar](2500) NULL,
	[cm_LastUpdate] [datetime2](7) NULL,
	[cm_LastUpdateUser] [nvarchar](2500) NULL,
	[cm_ClientMembershipIdentifier] [nvarchar](2500) NULL,
	[cm_MembershipCancelReasonDescription] [nvarchar](2500) NULL,
	[cm_HasInHousePaymentPlan] [bit] NULL,
	[cm_NationalMonthlyFee] [numeric](19, 4) NULL,
	[cm_MembershipProfileTypeID] [int] NULL,
	[m_MembershipID] [int] NULL,
	[m_MembershipSortOrder] [int] NULL,
	[m_MembershipDescription] [nvarchar](2500) NULL,
	[m_MembershipDescriptionShort] [nvarchar](2500) NULL,
	[m_BusinessSegmentID] [int] NULL,
	[m_RevenueGroupID] [int] NULL,
	[m_GenderID] [int] NULL,
	[m_DurationMonths] [int] NULL,
	[m_ContractPrice] [numeric](19, 4) NULL,
	[m_MonthlyFee] [numeric](19, 4) NULL,
	[m_IsTaxableFlag] [bit] NULL,
	[m_IsDefaultMembershipFlag] [bit] NULL,
	[m_IsActiveFlag] [bit] NULL,
	[m_CreateDate] [datetime2](7) NULL,
	[m_CreateUser] [nvarchar](2500) NULL,
	[m_LastUpdate] [datetime2](7) NULL,
	[m_LastUpdateUser] [nvarchar](2500) NULL,
	[m_IsHairSystemOrderRushFlag] [bit] NULL,
	[m_HairSystemGeneralLedgerID] [int] NULL,
	[m_DefaultPaymentSalesCodeID] [int] NULL,
	[m_NumRenewalDays] [int] NULL,
	[m_NumDaysAfterCancelBeforeNew] [int] NULL,
	[m_CanCheckinForConsultation] [bit] NULL,
	[m_MaximumHairSystemHairLengthValue] [int] NULL,
	[m_ExpectedConversionDays] [int] NULL,
	[m_MinimumAge] [int] NULL,
	[m_MaximumAge] [int] NULL,
	[m_MaximumLongHairAddOnHairLengthValue] [int] NULL,
	[m_BOSSalesTypeCode] [nvarchar](2500) NULL,
	[a_AppointmentGUID] [uniqueidentifier] NULL,
	[a_AppointmentID_Temp] [int] NULL,
	[a_ClientGUID] [uniqueidentifier] NULL,
	[a_ClientMembershipGUID] [uniqueidentifier] NULL,
	[a_ParentAppointmentGUID] [uniqueidentifier] NULL,
	[a_CenterID] [int] NULL,
	[a_ClientHomeCenterID] [int] NULL,
	[a_ResourceID] [int] NULL,
	[a_ConfirmationTypeID] [int] NULL,
	[a_AppointmentTypeID] [int] NULL,
	[a_AppointmentDate] [date] NULL,
	[a_StartTime] [time](0) NULL,
	[a_EndTime] [time](0) NULL,
	[a_CheckinTime] [datetime] NULL,
	[a_CheckoutTime] [datetime] NULL,
	[a_AppointmentSubject] [nvarchar](500) NULL,
	[a_CanPrintCommentFlag] [bit] NULL,
	[a_IsNonAppointmentFlag] [bit] NULL,
	[a_RecurrenceRule] [varchar](1024) NULL,
	[a_StartDateTimeCalc] [datetime] NULL,
	[a_EndDateTimeCalc] [datetime] NULL,
	[a_AppointmentDurationCalc] [time](0) NULL,
	[a_CreateDate] [datetime] NULL,
	[a_CreateUser] [nvarchar](25) NULL,
	[a_LastUpdate] [datetime] NULL,
	[a_LastUpdateUser] [nvarchar](25) NULL,
	[a_AppointmentStatusID] [int] NULL,
	[a_IsDeletedFlag] [bit] NULL,
	[a_OnContactActivityID] [nchar](10) NULL,
	[a_OnContactContactID] [nchar](10) NULL,
	[a_CheckedInFlag] [bit] NULL,
	[a_IsAuthorizedFlag] [bit] NULL,
	[a_LastChangeUser] [nvarchar](25) NULL,
	[a_LastChangeDate] [datetime] NULL,
	[a_ScalpHealthID] [int] NULL,
	[a_AppointmentPriorityColorID] [int] NULL,
	[a_CompletedVisitTypeID] [int] NULL,
	[a_IsFullTrichoView] [bit] NULL,
	[a_SalesforceContactID] [nvarchar](18) NULL,
	[a_SalesforceTaskID] [nvarchar](18) NULL,
	[a_KorvueID] [int] NULL,
	[a_ServiceStartTime] [datetime] NULL,
	[a_ServiceEndTime] [datetime] NULL,
	[a_IsClientContactInformationConfirmed] [bit] NULL,
	[ad_AppointmentDetailGUID] [uniqueidentifier] NULL,
	[ad_AppointmentGUID] [uniqueidentifier] NULL,
	[ad_SalesCodeID] [int] NULL,
	[ad_AppointmentDetailDuration] [int] NULL,
	[ad_CreateDate] [datetime] NULL,
	[ad_CreateUser] [nvarchar](50) NULL,
	[ad_LastUpdate] [datetime] NULL,
	[ad_LastUpdateUser] [nvarchar](50) NULL,
	[ad_Quantity] [int] NULL,
	[ad_Price] [money] NULL,
	[ae_AppointmentEmployeeGUID] [uniqueidentifier] NULL,
	[ae_AppointmentGUID] [uniqueidentifier] NULL,
	[ae_EmployeeGUID] [uniqueidentifier] NULL,
	[ae_CreateDate] [datetime] NULL,
	[ae_CreateUser] [nvarchar](50) NULL,
	[ae_LastUpdate] [datetime] NULL,
	[ae_LastUpdateUser] [nvarchar](50) NULL,
	[de_EmployeeGUID] [nvarchar](2500) NULL,
	[de_CenterID] [int] NULL,
	[de_TrainingExerciseID] [int] NULL,
	[de_ResourceID] [int] NULL,
	[de_SalutationID] [int] NULL,
	[de_FirstName] [nvarchar](2500) NULL,
	[de_LastName] [nvarchar](2500) NULL,
	[de_EmployeeInitials] [nvarchar](2500) NULL,
	[de_UserLogin] [nvarchar](2500) NULL,
	[de_Address1] [nvarchar](2500) NULL,
	[de_Address2] [nvarchar](2500) NULL,
	[de_Address3] [nvarchar](2500) NULL,
	[de_City] [nvarchar](2500) NULL,
	[de_StateID] [int] NULL,
	[de_PostalCode] [nvarchar](2500) NULL,
	[de_PhoneMain] [nvarchar](2500) NULL,
	[de_PhoneAlternate] [nvarchar](2500) NULL,
	[de_EmergencyContact] [nvarchar](2500) NULL,
	[de_PayrollNumber] [nvarchar](2500) NULL,
	[de_TimeClockNumber] [nvarchar](2500) NULL,
	[de_LastLogin] [datetime2](7) NULL,
	[de_IsSchedulerViewOnlyFlag] [bit] NULL,
	[de_EmployeeFullNameCalc] [nvarchar](2500) NULL,
	[de_IsActiveFlag] [bit] NULL,
	[de_CreateDate] [datetime2](7) NULL,
	[de_CreateUser] [nvarchar](2500) NULL,
	[de_LastUpdate] [datetime2](7) NULL,
	[de_LastUpdateUser] [nvarchar](2500) NULL,
	[de_AbbreviatedNameCalc] [nvarchar](2500) NULL,
	[de_ActiveDirectorySID] [nvarchar](255) NULL,
	[de_EmployeePayrollID] [nvarchar](2500) NULL,
	[de_EmployeeTitleID] [int] NULL,
	[su_UserKey] [int] NULL,
	[su_UserId] [varchar](200) NULL,
	[su_UserLogin] [varchar](400) NULL,
	[su_UserName] [varchar](400) NULL,
	[su_CompanyName] [varchar](400) NULL,
	[su_Street] [varchar](400) NULL,
	[su_City] [varchar](400) NULL,
	[su_State] [varchar](400) NULL,
	[su_TeamName] [varchar](400) NULL,
	[su_cONEctUserLogin] [varchar](200) NULL,
	[su_cONEctGUID] [varchar](200) NULL,
	[su_CenterId] [varchar](50) NULL,
	[su_Hash] [varchar](256) NULL,
	[su_DWH_LoadDate] [datetime] NULL,
	[su_DWH_LastUpdateDate] [datetime] NULL,
	[su_IsActive] [bit] NULL,
	[su_SourceSystem] [varchar](100) NULL,
	[c_CenterKey] [int] NULL,
	[c_CenterID] [int] NULL,
	[c_CenterPayGroupID] [int] NULL,
	[c_CenterDescription] [varchar](500) NULL,
	[c_Address1] [varchar](500) NULL,
	[c_Address2] [varchar](500) NULL,
	[c_Address3] [varchar](500) NULL,
	[c_CenterGeographykey] [int] NULL,
	[c_CenterPostalCode] [varchar](500) NULL,
	[c_CenterPhone1] [varchar](200) NULL,
	[c_CenterPhone2] [varchar](200) NULL,
	[c_CenterPhone3] [varchar](200) NULL,
	[c_Phone1TypeID] [int] NULL,
	[c_Phone2TypeID] [int] NULL,
	[c_Phone3TypeID] [int] NULL,
	[c_IsPhone1PrimaryFlag] [bit] NULL,
	[c_IsPhone2PrimaryFlag] [bit] NULL,
	[c_IsPhone3PrimaryFlag] [bit] NULL,
	[c_IsActiveFlag] [bit] NULL,
	[c_CreateDate] [datetime] NULL,
	[c_LastUpdate] [datetime] NULL,
	[c_CenterNumber] [int] NULL,
	[c_CenterOwnershipID] [int] NULL,
	[c_CenterOwnershipSortOrder] [int] NULL,
	[c_CenterOwnershipDescription] [varchar](100) NULL,
	[c_CenterOwnershipDescriptionShort] [varchar](100) NULL,
	[c_OwnerLastName] [varchar](100) NULL,
	[c_OwnerFirstName] [varchar](500) NULL,
	[c_CorporateName] [varchar](500) NULL,
	[c_OwnershipAddress1] [varchar](500) NULL,
	[c_OwnershipAddress2] [varchar](100) NULL,
	[c_OwnershipGeographykey] [int] NULL,
	[c_OwnershipPostalCode] [varchar](50) NULL,
	[c_CenterTypeID] [int] NULL,
	[c_CenterTypeSortOrder] [int] NULL,
	[c_CenterTypeDescription] [varchar](50) NULL,
	[c_CenterTypeDescriptionShort] [varchar](10) NULL,
	[c_DWH_LoadDate] [datetime] NULL,
	[c_DWH_LastUpdateDate] [datetime] NULL,
	[c_IsActive] [int] NULL,
	[c_SourceSystem] [varchar](10) NULL,
	[c_TimeZoneID] [int] NULL,
	[c_ServiceTerritoryId] [varchar](100) NULL,
	[c_IsDeleted] [bit] NULL,
	[c_Region1] [varchar](50) NULL,
	[c_Region2] [varchar](50) NULL,
	[c_RegioAM] [nvarchar](100) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
