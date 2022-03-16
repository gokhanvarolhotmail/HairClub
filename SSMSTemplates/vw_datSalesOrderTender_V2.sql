USE [HairClubCMSStaging_NoImg] ;
GO
/***********************************************************************

PROCEDURE: 	[vw_datSalesOrderTender]

DESTINATION SERVER:	   HCSQL2\SQL2005

DESTINATION DATABASE: Helios10

RELATED APPLICATION:  Surgery

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 07/01/2009

LAST REVISION DATE: 12/16/2009

-------------------------------------------------------------------------------------------------------------
NOTES: 12/16/2009 -- JH -- Added Canadian Dollars to selection for field (Amount)
							As Per Ticket Request 49040.
-------------------------------------------------------------------------------------------------------------
SAMPLE EXEC:  SELECT TOP 100 * FROM [vw_datSalesOrderTender]
-------------------------------------------------------------------------------------------------------------
***********************************************************************/
CREATE VIEW [dbo].[vw_datSalesOrderTender_V2]
AS
SELECT
    [dbo].[GetLocalFromUTC]([SO].[OrderDate], [UTCOffset], [UsesDayLightSavingsFlag]) AS [Date]

  --DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
  --                         WHEN DATEPART(WK, [SO].[OrderDate]) <= 10
  --                              OR DATEPART(WK, [SO].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
  --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
  --                    END, [SO].[OrderDate]) AS 'Date'
  , [cfgCenter].[CenterID]
  , [cfgCenter].[CenterDescription]
  , [cfgCenter].[CenterDescriptionFullCalc]
  , [cfgCenterClient].[CenterID] AS [ClientHomeCenterID]
  , [cfgCenterClient].[CenterDescriptionFullCalc] AS [ClientHomeCenterDescriptionFullCalc]
  , [cfgCenterClient].[CenterDescription] AS [ClientHomeCenterDescription]
  , [lkpRegion].[RegionID]
  , [RegionDescription]
  , [RegionSortOrder]
  , [lkpDoctorRegion].[DoctorRegionID]
  , [DoctorRegionDescription]
  , [lkpCenterType].[CenterTypeID]
  , [lkpCenterType].[CenterTypeDescription]
  , [lkpCenterType].[CenterTypeDescriptionShort]
  , [lkpCenterTypeTRX].[CenterTypeID] AS [CenterTypeIDTRX]
  , [lkpCenterTypeTRX].[CenterTypeDescription] AS [CenterTypeDescriptionTRX]
  , [lkpCenterTypeTRX].[CenterTypeDescriptionShort] AS [CenterTypeDescriptionShortTRX]
  , [datClient].[ClientGUID]
  , [ClientIdentifier]
  , [ClientNumber_Temp] AS [Helios10_ClientNo]
  , [datClient].[FirstName] AS [ClientFirstName]
  , [datClient].[LastName] AS [ClientLastName]
  , [ClientFullNameAltCalc]
  , [datClientMembership].[ClientMembershipGUID]
  , [BeginDate]
  , [EndDate]
  , [CancelDate]
  , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datClientMembership].[ContractPrice], [dbo].[GetLocalFromUTC]([SO].[OrderDate], [UTCOffset], [UsesDayLightSavingsFlag])
    --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
    --                         WHEN DATEPART(WK, [SO].[OrderDate]) <= 10
    --                              OR DATEPART(WK, [SO].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
    --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
    --	END, [SO].[OrderDate])
    ) AS [ContractPrice]
  , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [ContractPaidAmount], [dbo].[GetLocalFromUTC]([SO].[OrderDate], [UTCOffset], [UsesDayLightSavingsFlag])
    --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
    --                         WHEN DATEPART(WK, [SO].[OrderDate]) <= 10
    --                              OR DATEPART(WK, [SO].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
    --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
    --	END, [SO].[OrderDate])
    ) AS [ContractPaidAmount]
  , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datClientMembership].[MonthlyFee], [dbo].[GetLocalFromUTC]([SO].[OrderDate], [UTCOffset], [UsesDayLightSavingsFlag])
    --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
    --                         WHEN DATEPART(WK, [SO].[OrderDate]) <= 10
    --                              OR DATEPART(WK, [SO].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
    --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
    --	END, [SO].[OrderDate])
    ) AS [MonthlyFee]
  , [lkpClientMembershipStatus].[ClientMembershipStatusID]
  , [ClientMembershipStatusDescription]
  , [cfgMembership].[MembershipID]
  , [MembershipDescription]
  , [MembershipDescriptionShort]
  , [datEmployee0].[EmployeeInitials] AS [CashierInitials]
  , [datEmployee0].[EmployeeFullNameCalc] AS [Cashier]
  , [SO].[SalesOrderGUID]
  , [SO].[InvoiceNumber]
  , [SO].[TicketNumber_Temp]
  , [SO].[FulfillmentNumber]
  , [SO].[IsVoidedFlag]
  , [SO].[IsClosedFlag]
  , [SO].[RegisterCloseGUID]
  , [SO].[IsWrittenOffFlag]
  , [SalesOrderTenderGUID]
  , [datSalesOrderTender].[TenderTypeID]
  , [TenderTypeDescription]
  , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [Amount], [dbo].[GetLocalFromUTC]([SO].[OrderDate], [UTCOffset], [UsesDayLightSavingsFlag])
    --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
    --                         WHEN DATEPART(WK, [SO].[OrderDate]) <= 10
    --                              OR DATEPART(WK, [SO].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
    --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
    --	END, [SO].[OrderDate])
    ) AS [Amount]
  , [Amount] AS [CanadianAmount]
  , [CheckNumber]
  , [CreditCardLast4Digits]
  , [ApprovalCode]
  , [datSalesOrderTender].[CreditCardTypeID]
  , [CreditCardTypeDescription]
  , [datSalesOrderTender].[FinanceCompanyID]
  , [FinanceCompanyDescription]
  , [datSalesOrderTender].[InterCompanyReasonID]
  , [InterCompanyReasonDescription]
  , [SC].[SalesCodeDescription]
  , [SC].[SalesCodeDescriptionShort]
  , [datEmployee0].[PayrollNumber]
  , [datEmployee0].[EmployeePayrollID]
FROM [dbo].[datSalesOrder] AS [SO]
INNER JOIN [dbo].[datSalesOrderDetail] AS [SOD] ON [SO].[SalesOrderGUID] = [SOD].[SalesOrderGUID]
INNER JOIN [dbo].[cfgSalesCode] AS [SC] ON [SOD].[SalesCodeID] = [SC].[SalesCodeID]
INNER JOIN [dbo].[cfgCenter] ON [SO].[CenterID] = [cfgCenter].[CenterID]
LEFT OUTER JOIN [dbo].[cfgCenter] AS [cfgCenterClient] ON [SO].[ClientHomeCenterID] = [cfgCenterClient].[CenterID]
INNER JOIN [dbo].[lkpTimeZone] ON [cfgCenterClient].[TimeZoneID] = [lkpTimeZone].[TimeZoneID]
INNER JOIN [dbo].[lkpRegion] ON [cfgCenterClient].[RegionID] = [lkpRegion].[RegionID]
LEFT OUTER JOIN [dbo].[lkpDoctorRegion] ON [cfgCenterClient].[DoctorRegionID] = [lkpDoctorRegion].[DoctorRegionID]
INNER JOIN [dbo].[datClient] ON [SO].[ClientGUID] = [datClient].[ClientGUID]
INNER JOIN [dbo].[datClientMembership] ON [SO].[ClientMembershipGUID] = [datClientMembership].[ClientMembershipGUID]
INNER JOIN [dbo].[lkpClientMembershipStatus] ON [datClientMembership].[ClientMembershipStatusID] = [lkpClientMembershipStatus].[ClientMembershipStatusID]
INNER JOIN [dbo].[cfgMembership] ON [datClientMembership].[MembershipID] = [cfgMembership].[MembershipID]
LEFT OUTER JOIN [dbo].[datEmployee] AS [datEmployee0] ON [SO].[EmployeeGUID] = [datEmployee0].[EmployeeGUID]
LEFT OUTER JOIN [dbo].[datSalesOrderTender] ON [SO].[SalesOrderGUID] = [datSalesOrderTender].[SalesOrderGUID]
INNER JOIN [dbo].[lkpTenderType] ON [datSalesOrderTender].[TenderTypeID] = [lkpTenderType].[TenderTypeID]
LEFT OUTER JOIN [dbo].[lkpCreditCardType] ON [datSalesOrderTender].[CreditCardTypeID] = [lkpCreditCardType].[CreditCardTypeID]
LEFT OUTER JOIN [dbo].[lkpFinanceCompany] ON [datSalesOrderTender].[FinanceCompanyID] = [lkpFinanceCompany].[FinanceCompanyID]
LEFT OUTER JOIN [dbo].[lkpInterCompanyReason] ON [datSalesOrderTender].[InterCompanyReasonID] = [lkpInterCompanyReason].[InterCompanyReasonID]
INNER JOIN [dbo].[lkpCenterType] ON [cfgCenterClient].[CenterTypeID] = [lkpCenterType].[CenterTypeID]
INNER JOIN [dbo].[lkpCenterType] AS [lkpCenterTypeTRX] ON [cfgCenter].[CenterTypeID] = [lkpCenterTypeTRX].[CenterTypeID]
WHERE [SO].[IsClosedFlag] = 1 ;
GO
EmployeeID

,[SalesCodeDescription]
,[SalesCodeDescriptionShort]

SELECT
    [#Centers].[CenterNumber]
  , [#Centers].[CenterTypeDescription]
  , [ClientIdentifier]
  , [E].[ClientMembershipGUID]
  , [E].[ClientFullNameAltCalc]
  , [SO].[OrderDate]
  , [SO].[InvoiceNumber]
  , [SC].[SalesCodeID]
  , [SC].[SalesCodeDescription]
  , [SC].[SalesCodeDescriptionShort]
  , [DEPT].[SalesCodeDepartmentDescription]
  , [DIV].[SalesCodeDivisionDescription]
  , SUM(ISNULL([SC].[PriceDefault], 0)) AS [ServiceAmt]
  , ROW_NUMBER() OVER ( PARTITION BY [E].[ClientIdentifier] ORDER BY [SO].[OrderDate] ASC ) AS [ServiceRank]
FROM [dbo].[datSalesOrder] AS [SO]
INNER JOIN [#Employees] AS [E] ON [SO].[ClientMembershipGUID] = [E].[ClientMembershipGUID]
INNER JOIN [dbo].[datSalesOrderDetail] AS [SOD] ON [SO].[SalesOrderGUID] = [SOD].[SalesOrderGUID]
INNER JOIN [dbo].[datClientMembership] AS [CM] ON [SO].[ClientMembershipGUID] = [CM].[ClientMembershipGUID]
INNER JOIN [dbo].[cfgCenter] AS [C] ON [CM].[CenterID] = [C].[CenterID] --KEEP HomeCenter Based
INNER JOIN [#Centers] ON [C].[CenterID] = [#Centers].[CenterID]
INNER JOIN [dbo].[cfgSalesCode] AS [SC] ON [SOD].[SalesCodeID] = [SC].[SalesCodeID]
INNER JOIN [dbo].[cfgMembership] AS [M] ON [CM].[MembershipID] = [M].[MembershipID]
INNER JOIN [dbo].[lkpSalesCodeDepartment] AS [DEPT] ON [DEPT].[SalesCodeDepartmentID] = [SC].[SalesCodeDepartmentID]
INNER JOIN [dbo].[lkpSalesCodeDivision] AS [DIV] ON [DIV].[SalesCodeDivisionID] = [DEPT].[SalesCodeDivisionID]
WHERE [SO].[OrderDate] BETWEEN [CM].[BeginDate] AND [CM].[EndDate] --Services within the membership
  AND [DEPT].[SalesCodeDivisionID] = 50 --Services
  AND [SC].[SalesCodeDescription] NOT LIKE '%Application%' AND [SC].[SalesCodeDescription] NOT LIKE '%Salon%Visit%' AND [SC].[SalesCodeDescriptionShort] <> 'NB1A' AND [SC].[SalesCodeDescriptionShort] NOT LIKE 'APP%' AND [SC].[SalesCodeID] NOT IN (665, 654, 393, 668) AND [SO].[IsVoidedFlag] = 0
GROUP BY [#Centers].[CenterNumber]
       , [#Centers].[CenterTypeDescription]
       , [E].[ClientIdentifier]
       , [E].[ClientMembershipGUID]
       , [E].[ClientFullNameAltCalc]
       , [SO].[OrderDate]
       , [SO].[InvoiceNumber]
       , [SC].[SalesCodeID]
       , [SC].[SalesCodeDescription]
       , [SC].[SalesCodeDescriptionShort]
       , [DEPT].[SalesCodeDepartmentDescription]
       , [DIV].[SalesCodeDivisionDescription] ;
