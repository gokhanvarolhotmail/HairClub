/* CreateDate: 03/28/2011 11:18:47.933 , ModifyDate: 02/18/2013 19:04:02.753 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

View:					vwAppointments

DESTINATION SERVER:		HCSQL2

DESTINATION DATABASE: 	Helios10

RELATED APPLICATION:

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Marlon Burrell

DATE CREATED:

DATE IMPLEMENTED:

LAST REVISION DATE: 	 09/28/2009

==============================================================================
DESCRIPTION:	A View of All Surgery Data
==============================================================================
NOTES:	09/28/2009 - JH - Excluded from view when IsDeletedFlag is true per Kevin request.
==============================================================================
SAMPLE EXECUTION: SELECT TOP 100 * FROM vwAppointments
==============================================================================
*/
CREATE VIEW [dbo].[vwAppointments]
AS
SELECT  [datAppointment].[AppointmentGUID]
,       [datAppointment].[AppointmentDate]
,       [datAppointment].[StartTime]
,       [datAppointment].[EndTime]
,       [cfgCenter].[CenterID]
,       [cfgCenter].[CenterDescriptionFullCalc]
,       [cfgCenter].[CenterDescription]
,       [cfgCenterClient].[CenterID] AS 'ClientHomeCenterID'
,       [cfgCenterClient].[CenterDescriptionFullCalc] AS 'ClientHomeCenterDescriptionFullCalc'
,       [cfgCenterClient].[CenterDescription] AS 'ClientHomeCenterDescription'
,       [lkpRegion].[RegionID]
,       [lkpRegion].[RegionDescription]
,       [lkpRegion].[RegionSortOrder]
,       [lkpDoctorRegion].[DoctorRegionID]
,       [lkpDoctorRegion].[DoctorRegionDescription]
,       [datClient].[ClientGUID]
,       [datClient].[FirstName]
,       [datClient].[LastName]
,       [datClient].[ClientFullNameAltCalc]
,       '(' + LEFT([datClient].[Phone1], 3) + ') ' + SUBSTRING([datClient].[Phone1], 1, 3) + '-' + RIGHT([datClient].[Phone1], 4) AS 'Phone'
,       [cfgMembership].[MembershipID]
,       [cfgMembership].[MembershipDescription]
,       [datClientMembership].[EndDate] AS 'MembershipExpirationDate'
,		[datClientMembership].[ContractPaidAmount]
,       CONVERT(NUMERIC(15, 2), ISNULL([datClientMembership].[ContractPrice] - [datClientMembership].[ContractPaidAmount], 0)) AS 'Balance'
,       [datAppointmentDetail].[AppointmentDetailGUID]
,       [cfgSalesCode].[SalesCodeID]
,		[cfgSalesCode].[SalesCodeDescriptionShort]
,       [cfgSalesCode].[SalesCodeDescription]
,		DATEDIFF(MINUTE, CONVERT(VARCHAR, [datAppointment].[StartTime], 108), CONVERT(VARCHAR, [datAppointment].[EndTime], 108)) AS 'Duration'
,       [datAppointment].[CheckInTime]
,       [datAppointment].[CheckOutTime]
,		[datAppointment].[AppointmentDurationCalc]
,       [datAppointment].[CreateDate]
,       [datAppointment].[CreateUser]
,       MAX(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 27 )
                      AND [datClientMembershipAccum].[TotalAccumQuantity] > 0 THEN '*'
                 ELSE ''
            END) AS 'OptionToMaximize'
,       SUM(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 12 ) THEN [datClientMembershipAccum].[TotalAccumQuantity]
                 ELSE 0
            END) AS 'Grafts'
FROM    [datAppointment]
        LEFT OUTER JOIN [datAppointmentDetail]
          ON [datAppointment].[AppointmentGUID] = [datAppointmentDetail].[AppointmentGUID]
        LEFT OUTER JOIN [datClient]
          ON [datAppointment].[ClientGUID] = [datClient].[ClientGUID]
        LEFT OUTER JOIN [datClientMembership]
          ON [datAppointment].[ClientMembershipGUID] = [datClientMembership].[ClientMembershipGUID]
        LEFT OUTER JOIN [datClientMembershipAccum]
          ON [datClientMembership].[ClientMembershipGUID] = [datClientMembershipAccum].[ClientMembershipGUID]
             AND [datClientMembershipAccum].[AccumulatorID] IN ( 12, 27 )
        LEFT OUTER JOIN [cfgMembership]
          ON [datClientMembership].[MembershipID] = [cfgMembership].[MembershipID]
        INNER JOIN [cfgCenter]
          ON [datAppointment].[CenterID] = [cfgCenter].[CenterID]
        INNER JOIN [lkpRegion]
          ON [cfgCenter].[RegionID] = [lkpRegion].[RegionID]
        LEFT OUTER JOIN [lkpDoctorRegion]
          ON [cfgCenter].[DoctorRegionID] = [lkpDoctorRegion].[DoctorRegionID]
        INNER JOIN [cfgSalesCode]
          ON [datAppointmentDetail].[SalesCodeID] = [cfgSalesCode].[SalesCodeID]
        LEFT OUTER JOIN [cfgCenter] cfgCenterClient
          ON [datClient].[CenterID] = [cfgCenterClient].[CenterID]
WHERE ISNULL([datAppointment].[IsDeletedFlag],0) = 0
GROUP BY [datAppointment].[AppointmentGUID]
,       [datAppointment].[AppointmentDate]
,       [datAppointment].[StartTime]
,       [datAppointment].[EndTime]
,       [cfgCenter].[CenterID]
,       [cfgCenter].[CenterDescriptionFullCalc]
,       [cfgCenter].[CenterDescription]
,       [cfgCenterClient].[CenterID]
,       [cfgCenterClient].[CenterDescriptionFullCalc]
,       [cfgCenterClient].[CenterDescription]
,       [lkpRegion].[RegionID]
,       [lkpRegion].[RegionDescription]
,       [lkpRegion].[RegionSortOrder]
,       [lkpDoctorRegion].[DoctorRegionID]
,       [lkpDoctorRegion].[DoctorRegionDescription]
,       [datClient].[ClientGUID]
,       [datClient].[FirstName]
,       [datClient].[LastName]
,       [datClient].[ClientFullNameAltCalc]
,		[datClient].[Phone1]
,       [cfgMembership].[MembershipID]
,       [cfgMembership].[MembershipDescription]
,       [datClientMembership].[EndDate]
,       [datClientMembership].[ContractPrice]
,       [datClientMembership].[ContractPaidAmount]
,       [datAppointmentDetail].[AppointmentDetailGUID]
,       [cfgSalesCode].[SalesCodeID]
,		[cfgSalesCode].[SalesCodeDescriptionShort]
,       [cfgSalesCode].[SalesCodeDescription]
,       [datAppointment].[CheckInTime]
,       [datAppointment].[CheckOutTime]
,		[datAppointment].[AppointmentDurationCalc]
,       [datAppointment].[CreateDate]
,       [datAppointment].[CreateUser]
GO
