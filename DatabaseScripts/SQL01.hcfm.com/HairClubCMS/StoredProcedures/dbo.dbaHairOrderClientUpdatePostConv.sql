-- EXEC dbaHairOrderPurchaseOrderImport

CREATE PROCEDURE [dbo].[dbaHairOrderClientUpdatePostConv]

AS

BEGIN

update datClient
set CurrentBioMatrixClientMembershipGUID = v.ClientmembershipGUID
--select CurrentBioMatrixClientMembershipGUID, c.ClientGUID
from datClient c
inner join vwClientMembershipLatest v on c.ClientGUID = v.ClientGUID
where c.CurrentBioMatrixClientMembershipGUID is null and
c.CurrentExtremeTherapyClientMembershipGUID is null and
c.CurrentSurgeryClientMembershipGUID is null and v.BusinessSegmentID = 1
--
-- Update FL clients for BOSProduction clients
--
update datClient
set CountryID = 1
where StateID = 9
and CountryID is null
--
-- Fix Names for Center 100 clients.
--
update datClient
set LastName = RTRIM(lastname),
firstname = rtrim(firstname),
Address1 = RTRIM(Address1),
City = RTRIM(city)
where CenterID = 100
--
-- Fix memberships on Models
update datClient
set IsHairSystemClientFlag = 1
from datclient c
inner join datClientMembership cm on
	cm.ClientMembershipGUID = c.CurrentBioMatrixClientMembershipGUID
where cm.MembershipID in (14,15) AND CM.CenterID = 100
---
--- Update clientmembership on dathairsystem orders based on current
---
update datHairSystemOrder
set ClientMembershipGUID = c.CurrentBioMatrixClientMembershipGUID
--select *
from datHairSystemOrder ho
inner join datClient c on c.ClientGUID = ho.ClientGUID
where ho.ClientMembershipGUID is null and c.CurrentBioMatrixClientMembershipGUID is not null
END
