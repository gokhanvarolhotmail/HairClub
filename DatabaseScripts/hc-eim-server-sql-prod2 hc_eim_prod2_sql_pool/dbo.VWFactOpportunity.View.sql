/****** Object:  View [dbo].[VWFactOpportunity]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactOpportunity]
AS with factoppcte as
(
       select a.FactDate            AS                  FactDateUTC,
       a.FactDatekey         AS                  FactDatekeyUTC,
       a.LeadKey,
       a.LeadId,
       a.AccountKey,
       a.OpportunityStatus,
       a.AccountId,
       a.Centerkey,
       bebackflag,
       OpportunityId,
       a.isdeleted,
	   a.isold,
       case
           when a.IsOld = 0 then dateadd(mi, datepart(tz,
                                                    CONVERT(datetime, a.FactDate) AT TIME ZONE
                                                    'Eastern Standard Time'), a.FactDate)
           else a.FactDate end AS                  FactDate
  from FactOpportunity a
       where   case
           when IsOld = 0 then dateadd(mi, datepart(tz,
                                                    CONVERT(datetime, a.FactDate) AT TIME ZONE
                                                    'Eastern Standard Time'), a.FactDate)
           else FactDate end >=CONVERT(date,dateadd(d,-(day(getdate()-1)),getdate()),106)

  union all
     select a.FactDate            AS                  FactDateUTC,
       a.FactDatekey         AS                  FactDatekeyUTC,
       a.LeadKey,
       a.LeadId,
       a.AccountKey,
       a.OpportunityStatus,
       a.AccountId,
       a.Centerkey,
       bebackflag,
       OpportunityId,
       a.isdeleted,
	   a.isold,
       case
           when a.IsOld = 0 then dateadd(mi, datepart(tz,
                                                    CONVERT(datetime, a.FactDate) AT TIME ZONE
                                                    'Eastern Standard Time'), a.FactDate)
           else FactDate end AS                  FactDate
  from FactOpportunityTracking a
)
select                  FactDateUTC,
                         FactDatekeyUTC,
       a.LeadKey,
       a.LeadId,
       a.AccountKey,
       a.OpportunityStatus,
       a.AccountId,
       a.Centerkey,
       b.CenterDescription,
       CentertypeDescription,
       isnull(c.leadFullName, d.AccountFullName) Name,
       bebackflag,
       OpportunityId,
       a.isdeleted,
       FactDate,
       dd.DateKey            AS                  FactDateKey,
	   dt.TimeOfDayKey		as					FactTimeKey,
	   isnull(a.LeadId,d.AccountExternalId) as LeadIdExternal
from factoppcte a
         left join dimcenter b on a.CenterKey = b.CenterKey
         left join dimlead c on a.leadkey = c.leadkey
         left join dimaccount d on a.accountkey = d.accountkey
		 left join [dbo].[DimTimeOfDay] dt on dt.[Time24] = convert(time,a.FactDate)
         left join dimdate dd on convert(date, dd.FullDate) = convert(date,factdate);
GO
