/* CreateDate: 06/07/2011 13:15:26.210 , ModifyDate: 06/07/2011 13:15:26.210 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.vw_SurgerySalesOrderTender
AS
SELECT     SO.OrderDate AS 'Date', SO.CenterSSID AS 'TrxCenterID', CTR.CenterDescription AS 'TrxCenterDescription',
                      CTR.CenterDescriptionNumber AS 'TrxCenterDescriptionFullCalc', CLM.CenterSSID AS 'ClientHomeCenterID',
                      CLHMCTR.CenterDescription AS 'ClientHomeCenterDescription', CLHMCTR.CenterDescriptionNumber AS 'ClientHomeCenterDescriptionFullCalc',
                      CTRREG.RegionSSID AS 'RegionID', CTRREG.RegionDescription, DOCREG.DoctorRegionSSID AS 'DoctorRegionID', DOCREG.DoctorRegionDescription,
                      DOCREG.DoctorRegionDescriptionShort, CTRTYPE.CenterTypeSSID AS 'TrxCenterTypeID', CTRTYPE.CenterTypeDescription AS 'TrxCenterTypeDescription',
                      CTRTYPE.CenterTypeDescriptionShort AS 'TrxCenterTypeDescriptionShort', CL.ClientSSID AS 'ClientGUID', CL.ClientIdentifier, CL.ClientNumber_Temp,
                      CL.ClientFirstName, CL.ClientLastName, CL.ClientFullName, CLM.ClientMembershipSSID AS 'ClientMembershipGUID',
                      CLM.ClientMembershipBeginDate AS 'BeginDate', CLM.ClientMembershipEndDate AS 'EndDate', CLM.ClientMembershipCancelDate AS 'CancelDate',
                      CLM.ClientMembershipContractPrice AS 'ContractPrice', CLM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount',
                      CLM.ClientMembershipMonthlyFee AS 'MonthlyFee', CLM.ClientMembershipStatusSSID AS 'ClientMembershipStatusID', CLM.ClientMembershipStatusDescription,
                      MEM.MembershipSSID AS 'MembershipID', MEM.MembershipDescription, ISNULL(EMP.EmployeeInitials, 'XX') AS 'CashierInitials', ISNULL(EMP.EmployeeFullName,
                      'Unknown, Unknown') AS 'Cashier', SO.SalesOrderSSID AS 'SalesOrderGUID', SO.InvoiceNumber, SO.TicketNumber_Temp, SO.FulfillmentNumber, SO.IsVoidedFlag,
                      SO.IsClosedFlag, SO.IsWrittenOffFlag, SOT.SalesOrderTenderSSID AS 'SalesOrderTenderGUID', SOT.TenderTypeSSID AS 'TenderTypeID',
                      SOT.TenderTypeDescription, SOT.TenderTypeDescriptionShort, SOT.Amount, SOT.CheckNumber, SOT.CreditCardLast4Digits, SOT.ApprovalCode,
                      SOT.CreditCardTypeSSID AS 'CreditCardTypeID', SOT.CreditCardTypeDescription AS 'CreditCardTypeDesription', SOT.CreditCardTypeDescriptionShort,
                      SOT.FinanceCompanySSID AS 'FinanceCompanyID', SOT.FinanceCompanyDescription, SOT.FinanceCompanyDescriptionShort,
                      SOT.InterCompanyReasonSSID AS 'IntercompanyReasonID', SOT.InterCompanyReasonDescription AS 'IntercompanyReasonDescription',
                      SOT.InterCompanyReasonDescriptionShort AS 'IntercompanyReasonDescriptionShort'
FROM         dbo.synHC_CMS_DDS_vwDimSalesOrderTender AS SOT INNER JOIN
                      dbo.synHC_CMS_DDS_vwDimSalesOrder AS SO ON SOT.SalesOrderKey = SO.SalesOrderKey LEFT OUTER JOIN
                      dbo.synHC_CMS_DDS_vwDimEmployee AS EMP ON SO.EmployeeKey = EMP.EmployeeKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimCenter AS CTR ON SO.CenterKey = CTR.CenterKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimRegion AS CTRREG ON CTR.RegionKey = CTRREG.RegionKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimCenterType AS CTRTYPE ON CTR.CenterTypeKey = CTRTYPE.CenterTypeKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimDoctorRegion AS DOCREG ON CTR.DoctorRegionKey = DOCREG.DoctorRegionKey INNER JOIN
                      dbo.synHC_CMS_DDS_vwDimClient AS CL ON SO.ClientKey = CL.ClientKey INNER JOIN
                      dbo.synHC_CMS_DDS_vwDimClientMembership AS CLM ON SO.ClientMembershipKey = CLM.ClientMembershipKey INNER JOIN
                      dbo.synHC_CMS_DDS_vwDimMembership AS MEM ON CLM.MembershipKey = MEM.MembershipKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimCenter AS CLHMCTR ON CLM.CenterKey = CLHMCTR.CenterKey
GO
