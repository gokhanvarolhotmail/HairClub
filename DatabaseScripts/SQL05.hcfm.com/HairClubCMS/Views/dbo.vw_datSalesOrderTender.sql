/* CreateDate: 12/18/2012 11:45:45.490 , ModifyDate: 12/18/2012 11:45:45.490 */
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
CREATE  VIEW [dbo].[vw_datSalesOrderTender]
AS
SELECT  DATEADD(Hour, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
                           WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
                                OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
                           ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
                      END, [datSalesOrder].[OrderDate]) AS 'Date'
,       [cfgCenter].[CenterID]
,		[cfgCenter].[CenterDescription]
,       [cfgCenter].[CenterDescriptionFullCalc]
,		cfgCenterClient.[CenterID] AS 'ClientHomeCenterID'
,		cfgCenterClient.[CenterDescriptionFullCalc] AS 'ClientHomeCenterDescriptionFullCalc'
,		cfgCenterclient.CenterDescription AS 'ClientHomeCenterDescription'
,       [lkpRegion].[RegionID]
,       [lkpRegion].[RegionDescription]
,       [lkpRegion].[RegionSortOrder]
,       [lkpDoctorRegion].[DoctorRegionID]
,       [lkpDoctorRegion].[DoctorRegionDescription]
,		[lkpCenterType].[CenterTypeID]
,		[lkpCenterType].[CenterTypeDescription]
,		[lkpCenterType].[CenterTypeDescriptionShort]
,		[lkpCenterTypeTRX].[CenterTypeID] AS 'CenterTypeIDTRX'
,		[lkpCenterTypeTRX].[CenterTypeDescription] AS 'CenterTypeDescriptionTRX'
,		[lkpCenterTypeTRX].[CenterTypeDescriptionShort] AS 'CenterTypeDescriptionShortTRX'
,       [datClient].[ClientGUID]
,       [datClient].[ClientIdentifier]
,       [datClient].[ClientNumber_Temp] AS 'Helios10_ClientNo'
,		[datClient].[FirstName] AS 'ClientFirstName'
,		[datClient].[LastName] AS 'ClientLastName'
,       [datClient].[ClientFullNameAltCalc]
,       [datClientMembership].[ClientMembershipGUID]
,       [datClientMembership].[BeginDate]
,       [datClientMembership].[EndDate]
,       [datClientMembership].[CancelDate]
,       [dbo].[CanadianConversion](
			cfgCenterClient.[CenterID]
		,	[datClientMembership].[ContractPrice]
		,	DATEADD(Hour, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
                           WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
                                OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
                           ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
			END, [datSalesOrder].[OrderDate])
		) AS 'ContractPrice'
,       [dbo].[CanadianConversion](
			cfgCenterClient.[CenterID]
		,	[datClientMembership].[ContractPaidAmount]
		,	DATEADD(Hour, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
                           WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
                                OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
                           ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
			END, [datSalesOrder].[OrderDate])
		) AS 'ContractPaidAmount'
,       [dbo].[CanadianConversion](
			cfgCenterClient.[CenterID]
		,	[datClientMembership].[MonthlyFee]
		,	DATEADD(Hour, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
                           WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
                                OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
                           ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
			END, [datSalesOrder].[OrderDate])
		) AS 'MonthlyFee'
,       [lkpClientMembershipStatus].[ClientMembershipStatusID]
,       [lkpClientMembershipStatus].[ClientMembershipStatusDescription]
,       [cfgMembership].[MembershipID]
,       [cfgMembership].[MembershipDescription]
,       [cfgMembership].[MembershipDescriptionShort]
,		[datEmployee0].[EmployeeInitials] AS 'CashierInitials'
,		[datEmployee0].[EmployeeFullNameCalc] AS 'Cashier'
,       [datSalesOrder].[SalesOrderGUID]
,       [datSalesOrder].[InvoiceNumber]
,       [datSalesOrder].[TicketNumber_Temp]
,       [datSalesOrder].[FulfillmentNumber]
,       [datSalesOrder].[IsVoidedFlag]
,       [datSalesOrder].[IsClosedFlag]
,       [datSalesOrder].[RegisterCloseGUID]
,       [datSalesOrder].[IsWrittenOffFlag]
,		[datSalesOrderTender].[SalesOrderTenderGUID]
,		[datSalesOrderTender].[TenderTypeID]
,		[lkpTenderType].[TenderTypeDescription]
,       [dbo].[CanadianConversion](
			cfgCenterClient.[CenterID]
		,	[datSalesOrderTender].[Amount]
		,	DATEADD(Hour, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
                           WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
                                OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
                           ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
			END, [datSalesOrder].[OrderDate])
		) AS 'Amount'
,		[datSalesOrderTender].[Amount] As 'CanadianAmount'
,		[datSalesOrderTender].[CheckNumber]
,		[datSalesOrderTender].[CreditCardLast4Digits]
,		[datSalesOrderTender].[ApprovalCode]
,		[datSalesOrderTender].[CreditCardTypeID]
,		[lkpCreditCardType].[CreditCardTypeDescription]
,		[datSalesOrderTender].[FinanceCompanyID]
,		[lkpFinanceCompany].[FinanceCompanyDescription]
,		[datSalesOrderTender].[InterCompanyReasonID]
,		[lkpInterCompanyReason].[InterCompanyReasonDescription]
FROM    [datSalesOrder]
        INNER JOIN [cfgCenter]
          ON [datSalesOrder].[CenterID] = [cfgCenter].[CenterID]
		LEFT OUTER JOIN [cfgCenter] cfgCenterClient
		  ON [datSalesOrder].[ClientHomeCenterID] = cfgCenterClient.[CenterID]
        INNER JOIN [lkpTimeZone]
          ON cfgCenterClient.[TimeZoneID] = [lkpTimeZone].[TimeZoneID]
        INNER JOIN [lkpRegion]
          ON cfgCenterClient.[RegionID] = [lkpRegion].[RegionID]
        LEFT OUTER JOIN [lkpDoctorRegion]
          ON cfgCenterClient.[DoctorRegionID] = [lkpDoctorRegion].[DoctorRegionID]
        INNER JOIN [datClient]
          ON [datSalesOrder].[ClientGUID] = [datClient].[ClientGUID]
        INNER JOIN [datClientMembership]
          ON [datSalesOrder].[ClientMembershipGUID] = [datClientMembership].[ClientMembershipGUID]
        INNER JOIN [lkpClientMembershipStatus]
          ON [datClientMembership].[ClientMembershipStatusID] = [lkpClientMembershipStatus].[ClientMembershipStatusID]
        INNER JOIN [cfgMembership]
          ON [datClientMembership].[MembershipID] = [cfgMembership].[MembershipID]
        LEFT OUTER JOIN [datEmployee] datEmployee0
          ON [datSalesOrder].[EmployeeGUID] = datEmployee0.[EmployeeGUID]
        LEFT OUTER JOIN [datSalesOrderTender]
          ON [datSalesOrder].[SalesOrderGUID] = [datSalesOrderTender].[SalesOrderGUID]
		INNER JOIN [lkpTenderType]
		  ON [datSalesOrderTender].[TenderTypeID] = [lkpTenderType].[TenderTypeID]
		LEFT OUTER JOIN [lkpCreditCardType]
		  ON [datSalesOrderTender].[CreditCardTypeID] = [lkpCreditCardType].[CreditCardTypeID]
		LEFT OUTER JOIN [lkpFinanceCompany]
		  ON [datSalesOrderTender].[FinanceCompanyID] = [lkpFinanceCompany].[FinanceCompanyID]
		LEFT OUTER JOIN [lkpInterCompanyReason]
		  ON [datSalesOrderTender].[InterCompanyReasonID] = [lkpInterCompanyReason].[InterCompanyReasonID]
        INNER JOIN [lkpCenterType]
		  ON cfgCenterClient.CenterTypeID = lkpCenterType.CenterTypeID
        INNER JOIN [lkpCenterType] lkpCenterTypeTRX
		  ON [cfgCenter].CenterTypeID = lkpCenterTypeTRX.CenterTypeID
WHERE [datSalesOrder].[IsClosedFlag]=1
GO
