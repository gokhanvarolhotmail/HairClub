/* CreateDate: 02/16/2022 08:32:59.720 , ModifyDate: 02/16/2022 08:32:59.720 */
GO
create view vw_ClientDocumentStatus as
select top 100 percent
a.RegionDescription,
b.CenterNumber,
b.CenterDescription,
c.FirstName,
c.LastName,
d.MembershipID,
e.MembershipDescription,
d.BeginDate,
d.EndDate,
d.ContractPrice,
d.ContractPaidAmount,
f.DocumentName,
g.DocumentStatusDescription,
max(h.AppointmentDate) as LastAppointment
from lkpRegion a
join cfgCenter b on b.RegionID = a.RegionID
join datClient c on c.CenterID = b.CenterID
join datClientMembership d on c.ClientGUID = d.ClientGUID
join cfgMembership e on e.MembershipID = d.MembershipID
join datClientMembershipDocument f on f.ClientGUID = c.ClientGUID
join lkpDocumentStatus g on g.DocumentStatusID = f.DocumentStatusID
join datAppointment h on h.ClientGUID = c.ClientGUID
join lkpAppointmentType i on i.AppointmentTypeID = h.AppointmentTypeID
where d.ClientMembershipStatusID = 1
and (f.DocumentTypeID = 1 or f.DocumentStatusID = 1)
and h.IsNonAppointmentFlag = 0
group by
a.RegionDescription,
b.CenterNumber,
b.CenterDescription,
c.FirstName,
c.LastName,
d.MembershipID,
e.MembershipDescription,
d.BeginDate,
d.EndDate,
d.ContractPrice,
d.ContractPaidAmount,
f.DocumentName,
g.DocumentStatusDescription
order by
a.RegionDescription,
b.CenterNumber,
c.LastName,
e.MembershipDescription,
d.BeginDate
GO
