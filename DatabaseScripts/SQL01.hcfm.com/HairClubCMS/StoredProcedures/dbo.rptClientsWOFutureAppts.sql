/* CreateDate: 02/09/2022 15:59:58.460 , ModifyDate: 02/09/2022 16:10:52.890 */
GO
CREATE procedure [dbo].[rptClientsWOFutureAppts] (
@StartDate datetime = null
,@EndDate datetime = null
)
as
BEGIN
Select a.RegionDescription,
b.CenterDescription,
c.ClientIdentifier,
c.ClientFullNameCalc,
e.MembershipDescription,
d.BeginDate,
d.EndDate,
max(f.[AppointmentDate]) as LastServiceDate,
count(i.[AppointmentDate]) as NumberOfFutureAppts,
min(i.[AppointmentDate]) as NextAppt,
max(i.[AppointmentDate]) as MostFutureAppt
from dbo.lkpRegion a WITH (NOLOCK)
JOIN dbo.cfgCenter b  WITH (NOLOCK) on b.RegionID = a.RegionID
JOIN dbo.datClient c  WITH (NOLOCK) on c.CenterID = b.CenterID
JOIN dbo.datClientMembership d  WITH (NOLOCK) on d.ClientGUID = c.ClientGUID
JOIN dbo.cfgMembership e  WITH (NOLOCK) on e.MembershipID = d.MembershipID
JOIN dbo.datAppointment f  WITH (NOLOCK) on f.[ClientGUID] = c.[ClientGUID] and d.[ClientMembershipGUID] = f.ClientMembershipGUID
JOIN dbo.datAppointment i  WITH (NOLOCK) on i.[ClientGUID] = c.[ClientGUID] and i.[ClientMembershipGUID] = d.ClientMembershipGUID
Where a.IsActiveFlag = 1
and b.IsActiveFlag = 1
and d.IsActiveFlag = 1
and e.IsActiveFlag = 1
and f.AppointmentDate < getdate()
and i.AppointmentDate NOT BETWEEN @StartDate and @EndDate
group by a.RegionDescription,b.CenterDescription,c.ClientIdentifier,c.ClientFullNameCalc,
e.MembershipDescription,d.BeginDate,d.EndDate
END
GO
