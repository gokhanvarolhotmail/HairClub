/* CreateDate: 03/16/2022 17:50:47.560 , ModifyDate: 03/16/2022 17:50:47.560 */
GO
/***********************************************************************

PROCEDURE: 	[vw_datSalesOrderDetail]

DESTINATION SERVER:	   HCSQL2\SQL2005

DESTINATION DATABASE: Helios10

RELATED APPLICATION:  Surgery

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 07/01/2009

LAST REVISION DATE: 12/16/2009

-------------------------------------------------------------------------------------------------------------
NOTES: 12/16/2009 -- JH -- Added Canadian Dollars to selection for fields (Price, Tax1, Tax2 and Total_Price)
							As Per Ticket Request 49040.
		03/16/2011 -- MB -- Added IsSurgeryReversalFlag=0 to applicable queries
-------------------------------------------------------------------------------------------------------------
SAMPLE EXEC:  SELECT TOP 100 * FROM [vw_datSalesOrderDetail]
-------------------------------------------------------------------------------------------------------------
***********************************************************************/
CREATE VIEW [dbo].[vw_datSalesOrderDetail_V2]
AS
SELECT ( SELECT [OutVal] FROM [dbo].[GetLocalFromUTCInline]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag]) ) AS [Date]

     --DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
     --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
     --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
     --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
     --                    END, [datSalesOrder].[OrderDate]) AS 'Date'
     , [cfgCenter].[CenterID]
     , [cfgCenter].[CenterDescription]
     , [cfgCenter].[CenterDescriptionFullCalc]
     , [cfgCenterClient].[CenterID] AS [ClientHomeCenterID]
     , [cfgCenterClient].[CenterDescriptionFullCalc] AS [ClientHomeCenterDescriptionFullCalc]
     , [cfgCenterClient].[CenterDescription] AS [ClientHomeCenterDescription]
     , [lkpRegion].[RegionID]
     , [lkpRegion].[RegionDescription]
     , [lkpRegion].[RegionSortOrder]
     , [lkpDoctorRegion].[DoctorRegionID]
     , [lkpDoctorRegion].[DoctorRegionDescription]
     , [lkpDoctorRegion].[DoctorRegionDescriptionShort]
     , [lkpCenterType].[CenterTypeID]
     , [lkpCenterType].[CenterTypeDescription]
     , [lkpCenterType].[CenterTypeDescriptionShort]
     , [lkpCenterTypeTRX].[CenterTypeID] AS [CenterTypeIDTRX]
     , [lkpCenterTypeTRX].[CenterTypeDescription] AS [CenterTypeDescriptionTRX]
     , [lkpCenterTypeTRX].[CenterTypeDescriptionShort] AS [CenterTypeDescriptionShortTRX]
     , [datClient].[ClientGUID]
     , [datClient].[ClientIdentifier]
     , [datClient].[ClientNumber_Temp]
     , [datClient].[FirstName] AS [ClientFirstName]
     , [datClient].[LastName] AS [ClientLastName]
     , [datClient].[ClientFullNameAltCalc]
     , [datClientMembership].[ClientMembershipGUID]
     , [datClientMembership].[BeginDate]
     , [datClientMembership].[EndDate]
     , [datClientMembership].[CancelDate]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datClientMembership].[ContractPrice], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [ContractPrice]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datClientMembership].[ContractPaidAmount], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [ContractPaidAmount]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datClientMembership].[MonthlyFee], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [MonthlyFee]
     , [lkpClientMembershipStatus].[ClientMembershipStatusID]
     , [lkpClientMembershipStatus].[ClientMembershipStatusDescription]
     , [cfgMembership].[MembershipID]
     , [cfgMembership].[MembershipDescription]
     , [cfgMembership].[MembershipDescriptionShort]
     , [cfgSalesCode].[SalesCodeID]
     , [cfgSalesCode].[SalesCodeDescription]
     , [cfgSalesCode].[SalesCodeDescriptionShort]
     , [lkpSalesCodeType].[SalesCodeTypeID]
     , [lkpSalesCodeType].[SalesCodeTypeDescription]
     , [lkpSalesCodeDepartment].[SalesCodeDepartmentID]
     , [lkpSalesCodeDepartment].[SalesCodeDepartmentDescription]
     , [lkpSalesCodeDepartment].[SalesCodeDepartmentDescriptionShort]
     , [lkpSalesCodeDivision].[SalesCodeDivisionID]
     , [lkpSalesCodeDivision].[SalesCodeDivisionDescription]
     , [lkpSalesCodeDivision].[SalesCodeDivisionDescriptionShort]
     , [datEmployee0].[EmployeeFullNameCalc] AS [Cashier]
     , [datEmployee1].[EmployeeFullNameCalc] AS [Consultant]
     , [datEmployee2].[EmployeeFullNameCalc] AS [Technician]
     , [datEmployee3].[EmployeeFullNameCalc] AS [Doctor]
     , [datEmployee4].[EmployeeFullNameCalc] AS [Employee4]
     , [datEmployee0].[EmployeeInitials] AS [CashierInitials]
     , [datEmployee1].[EmployeeInitials] AS [ConsultantInitials]
     , [datEmployee2].[EmployeeInitials] AS [TechnicianInitials]
     , [datEmployee3].[EmployeeInitials] AS [DoctorInitials]
     , [datEmployee4].[EmployeeInitials] AS [Employee4Initials]
     , [datEmployee2].[EmployeeInitials] AS [Performer1]
     , [datSalesOrder].[InvoiceNumber] AS [Transact_No]
     , [datSalesOrder].[InvoiceNumber]
     , [datSalesOrder].[TicketNumber_Temp]
     , [lkpSalesOrderType].[SalesOrderTypeID]
     , [lkpSalesOrderType].[SalesOrderTypeDescription]
     , [lkpSalesOrderType].[SalesOrderTypeDescriptionShort]
     , [datSalesOrderDetail].[TransactionNumber_Temp]
     , [datSalesOrderDetail].[Quantity]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datSalesOrderDetail].[Price], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [Price]
     , [datSalesOrderDetail].[Price] AS [CanadianPrice]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datSalesOrderDetail].[Discount], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [Discount]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datSalesOrderDetail].[PriceTaxCalc], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [PriceTaxCalc]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datSalesOrderDetail].[ExtendedPriceCalc], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [ExtendedPriceCalc]
     , [datSalesOrderDetail].[ExtendedPriceCalc] AS [CanadianExtendedPriceCalc]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datSalesOrderDetail].[Tax1], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [Tax1]
     , [datSalesOrderDetail].[Tax1] AS [CanadianTax1]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datSalesOrderDetail].[Tax2], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [Tax2]
     , [datSalesOrderDetail].[Tax2] AS [CanadianTax2]
     , [datSalesOrderDetail].[TaxRate1]
     , [datSalesOrderDetail].[TaxRate2]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datSalesOrderDetail].[TotalTaxCalc], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [TotalTaxCalc]
     , [dbo].[CanadianConversion]([cfgCenterClient].[CenterID], [datSalesOrderDetail].[RefundedTotalPrice], [dbo].[GetLocalFromUTC]([datSalesOrder].[OrderDate], [lkpTimeZone].[UTCOffset], [lkpTimeZone].[UsesDayLightSavingsFlag])
       --,	DATEADD(HOUR, CASE WHEN [lkpTimeZone].[UsesDayLightSavingsFlag] = 0 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         WHEN DATEPART(WK, [datSalesOrder].[OrderDate]) <= 10
       --                              OR DATEPART(WK, [datSalesOrder].[OrderDate]) >= 45 THEN ( [lkpTimeZone].[UTCOffset] )
       --                         ELSE ( ( [lkpTimeZone].[UTCOffset] ) + 1 )
       --	END, [datSalesOrder].[OrderDate])
       ) AS [RefundedTotalPrice]
     , [datSalesOrderDetail].[RefundedTotalQuantity]
     , [datSalesOrder].[FulfillmentNumber]
     , [datSalesOrderDetail].[IsRefundedFlag]
     , [datSalesOrderDetail].[RefundedSalesOrderDetailGUID]
     , [datSalesOrderDetail].[PreviousClientMembershipGUID]
     , [datSalesOrderDetail].[NewCenterID]
     , [datSalesOrder].[IsVoidedFlag]
     , [datSalesOrder].[IsClosedFlag]
     , [datSalesOrder].[RegisterCloseGUID]
     , [datSalesOrder].[IsWrittenOffFlag]
     , [datSalesOrder].[CreateUser]
     , [datSalesOrder].[SalesOrderGUID]
     , [datSalesOrderDetail].[SalesOrderDetailGUID]
     , [datEmployee0].[EmployeePayrollID]
     , [datEmployee1].[EmployeePayrollID] AS [Consultant EmployeePayrollID]
     , [datEmployee2].[EmployeePayrollID] AS [Technician EmployeePayrollID]
FROM [dbo].[datSalesOrder] AS [datSalesOrder]
INNER JOIN [dbo].[cfgCenter] AS [cfgCenter] ON [datSalesOrder].[CenterID] = [cfgCenter].[CenterID]
LEFT OUTER JOIN [dbo].[cfgCenter] AS [cfgCenterClient] ON [datSalesOrder].[ClientHomeCenterID] = [cfgCenterClient].[CenterID]
INNER JOIN [dbo].[lkpTimeZone] AS [lkpTimeZone] ON [cfgCenterClient].[TimeZoneID] = [lkpTimeZone].[TimeZoneID]
INNER JOIN [dbo].[lkpRegion] AS [lkpRegion] ON [cfgCenterClient].[RegionID] = [lkpRegion].[RegionID]
INNER JOIN [dbo].[lkpCenterType] AS [lkpCenterType] ON [cfgCenterClient].[CenterTypeID] = [lkpCenterType].[CenterTypeID]
INNER JOIN [dbo].[lkpCenterType] AS [lkpCenterTypeTRX] ON [cfgCenter].[CenterTypeID] = [lkpCenterTypeTRX].[CenterTypeID]
LEFT OUTER JOIN [dbo].[lkpDoctorRegion] AS [lkpDoctorRegion] ON [cfgCenterClient].[DoctorRegionID] = [lkpDoctorRegion].[DoctorRegionID]
INNER JOIN [dbo].[datClient] AS [datClient] ON [datSalesOrder].[ClientGUID] = [datClient].[ClientGUID]
INNER JOIN [dbo].[datClientMembership] AS [datClientMembership] ON [datSalesOrder].[ClientMembershipGUID] = [datClientMembership].[ClientMembershipGUID]
INNER JOIN [dbo].[lkpClientMembershipStatus] AS [lkpClientMembershipStatus] ON [datClientMembership].[ClientMembershipStatusID] = [lkpClientMembershipStatus].[ClientMembershipStatusID]
INNER JOIN [dbo].[cfgMembership] AS [cfgMembership] ON [datClientMembership].[MembershipID] = [cfgMembership].[MembershipID]
INNER JOIN [dbo].[datSalesOrderDetail] AS [datSalesOrderDetail] ON [datSalesOrder].[SalesOrderGUID] = [datSalesOrderDetail].[SalesOrderGUID]
INNER JOIN [dbo].[lkpSalesOrderType] AS [lkpSalesOrderType] ON [datSalesOrder].[SalesOrderTypeID] = [lkpSalesOrderType].[SalesOrderTypeID]
INNER JOIN [dbo].[cfgSalesCode] AS [cfgSalesCode] ON [datSalesOrderDetail].[SalesCodeID] = [cfgSalesCode].[SalesCodeID]
INNER JOIN [dbo].[lkpSalesCodeType] AS [lkpSalesCodeType] ON [cfgSalesCode].[SalesCodeTypeID] = [lkpSalesCodeType].[SalesCodeTypeID]
INNER JOIN [dbo].[lkpSalesCodeDepartment] AS [lkpSalesCodeDepartment] ON [cfgSalesCode].[SalesCodeDepartmentID] = [lkpSalesCodeDepartment].[SalesCodeDepartmentID]
INNER JOIN [dbo].[lkpSalesCodeDivision] AS [lkpSalesCodeDivision] ON [lkpSalesCodeDepartment].[SalesCodeDivisionID] = [lkpSalesCodeDivision].[SalesCodeDivisionID]
LEFT OUTER JOIN [dbo].[datEmployee] AS [datEmployee0] ON [datSalesOrder].[EmployeeGUID] = [datEmployee0].[EmployeeGUID]
LEFT OUTER JOIN [dbo].[datEmployee] AS [datEmployee1] ON [datSalesOrderDetail].[Employee1GUID] = [datEmployee1].[EmployeeGUID]
LEFT OUTER JOIN [dbo].[datEmployee] AS [datEmployee2] ON [datSalesOrderDetail].[Employee2GUID] = [datEmployee2].[EmployeeGUID]
LEFT OUTER JOIN [dbo].[datEmployee] AS [datEmployee3] ON [datSalesOrderDetail].[Employee3GUID] = [datEmployee3].[EmployeeGUID]
LEFT OUTER JOIN [dbo].[datEmployee] AS [datEmployee4] ON [datSalesOrderDetail].[Employee4GUID] = [datEmployee4].[EmployeeGUID]
WHERE(( [lkpSalesOrderType].[SalesOrderTypeDescriptionShort] = 'SO' AND [datSalesOrder].[IsClosedFlag] = 1 ) OR [lkpSalesOrderType].[SalesOrderTypeDescriptionShort] = 'MO' ) AND [datSalesOrder].[IsSurgeryReversalFlag] = 0 ;
GO
