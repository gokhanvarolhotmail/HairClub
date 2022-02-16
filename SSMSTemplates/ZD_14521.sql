IF OBJECT_ID('[tempdb]..[#ScheduledNextAppDate]') IS NOT NULL
    DROP TABLE [#ScheduledNextAppDate] ;

DECLARE @Getdate DATE = GETDATE() ;

-- Scheduled Next App Date
SELECT
    [k].[ClientGUID]
  , [k].[AppointmentDate] AS [NextAppointmentDate]
  , [k].[SalesCodeDescription] AS [NextAppointmentSalesCodeDescription]
  , [k].[SalesCodeDescriptionShort] AS [NextAppointmentSalesCodeDescriptionShort]
INTO [#ScheduledNextAppDate]
FROM( SELECT
          [c].[ClientGUID]
        , [a].[AppointmentDate]
        , [sc].[SalesCodeDescription]
        , [sc].[SalesCodeDescriptionShort]
        , ROW_NUMBER() OVER ( PARTITION BY [c].[ClientGUID] ORDER BY [a].[AppointmentDate] ASC ) AS [rw]
      FROM [dbo].[datClient] AS [c]
      INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientGUID] = [c].[ClientGUID]
      INNER JOIN [dbo].[cfgMembership] AS [m] ON [cm].[MembershipID] = [m].[MembershipID]
      INNER JOIN [dbo].[datAppointment] AS [a] ON [cm].[ClientMembershipGUID] = [a].[ClientMembershipGUID]
      INNER JOIN [dbo].[datAppointmentDetail] AS [ad] ON [ad].[AppointmentGUID] = [a].[AppointmentGUID]
      INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sc].[SalesCodeID] = [ad].[SalesCodeID]
      INNER JOIN [dbo].[cfgCenter] AS [apptctr] ON [a].[CenterID] = [apptctr].[CenterID]
      WHERE( [a].[IsDeletedFlag] IS NULL OR [a].[IsDeletedFlag] = 0 ) AND [a].[AppointmentDate] >= @Getdate AND [sc].[SalesCodeDepartmentID] IN (5010, 5020)) AS [k]
WHERE [k].[rw] = 1
OPTION( RECOMPILE ) ;

SELECT
    [c].[ClientGUID]
  , [c].[ClientIdentifier]
  , [m].[MembershipID]
  , [c].[ClientFullNameAltCalc]
  , [c].[ClientFullNameCalc]
  , [c].[ClientFullNameAlt2Calc]
  , [c].[ClientFullNameAlt3Calc]
  , [c1].[CenterID]
  , [c1].[CenterDescription]
  , [c1].[CenterDescriptionFullAlt1Calc]
  , [c1].[CenterDescriptionFullCalc]
  , [sa].[NextAppointmentDate]
  , [sa].[NextAppointmentSalesCodeDescription]
  , [sa].[NextAppointmentSalesCodeDescriptionShort]
  , [c].[ClientOriginalCenterID]
  , [c2].[CenterDescription] AS [OriginalCenterDescription]
  , [c2].[CenterDescriptionFullAlt1Calc] AS [OriginalCenterDescriptionFullAlt1Calc]
  , [c2].[CenterDescriptionFullCalc] AS [OriginalCenterDescriptionFullCalc]
FROM [dbo].[datClient] AS [c]
INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientGUID] = [c].[ClientGUID] AND [cm].[IsActiveFlag] = 1
INNER JOIN [dbo].[cfgMembership] AS [m] ON [cm].[MembershipID] = [m].[MembershipID] AND [m].[IsActiveFlag] = 1
LEFT JOIN [dbo].[cfgCenter] AS [c1] ON [c1].[CenterID] = [c].[CenterID]
LEFT JOIN [dbo].[cfgCenter] AS [c2] ON [c2].[CenterID] = [c].[ClientOriginalCenterID]
LEFT JOIN [#ScheduledNextAppDate] AS [sa] ON [sa].[ClientGUID] = [c].[ClientGUID]
ORDER BY [c].[ClientIdentifier] ;
