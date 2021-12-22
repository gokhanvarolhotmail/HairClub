-- EXEC dbaHairOrderPurchaseOrderImport

CREATE PROCEDURE [dbo].[dbaCMS42UpdateSetup]

AS

BEGIN

------select
------cc.centerid,
------tc.inactive,
------cc.isactiveflag as CMSActiveFlag,
------tc.center,
------cc.centerdescription as CMSCenter,
------tc.address1,
------cc.address1 as CMSAddress1,
------tc.address2,
------cc.address2 as CMSAddress2,
------tc.city,
------cc.city as CMSCity,
------tc.[state],
------lkpstate.statedescriptionshort as CMSState,
------tc.zip,
------cc.postalcode as CMSZip,
------tc.phone,
------cc.phone1 as CMSPhone,
------tblregion.region,
------lkpregion.regiondescription as CMSRegion,
------tc.country,
------lkpcountry.countrydescriptionshort as CMSDescription
------from [hcsql2\sql2005].hcfmdirectory.dbo.tblcenter tc
------left outer join cfgcenter cc on tc.center_num = cc.centerid
------left join lkpstate on cc.stateid = lkpstate.stateid
------left join lkpregion on cc.regionid = lkpregion.regionid
------left join lkpcountry on cc.countryid = lkpcountry.countryid
------left join [hcsql2\sql2005].hcfmdirectory.dbo.tblregion on tblregion.regionid = tc.regionid
------where tc.inactive = 0 and cc.isactiveflag = 1

update cc
set cc.isactiveflag = 1
--select *
from cfgCenter cc
left outer join [hcsql2\sql2005].hcfmdirectory.dbo.tblcenter tc
	on tc.center_num = cc.centerid
where tc.inactive = 0 or CenterID = 100

update cc
set cc.isactiveflag = 0
--select *
from cfgCenter cc
left outer join [hcsql2\sql2005].hcfmdirectory.dbo.tblcenter tc
	on tc.center_num = cc.centerid
where tc.inactive = 1 and CenterID <> 100

update cc
set cc.centerdescription = tc.center
--select *
from cfgcenter cc
left outer join [hcsql2\sql2005].hcfmdirectory.dbo.tblcenter tc
	on tc.center_num = cc.centerid
where tc.inactive = 0 and cc.isactiveflag = 1 and
	cc.centerdescription <> tc.center


update cc
set cc.address1 = tc.address1
--select cc.address1 as 'CMSaddress1', tc.address1,*
from cfgcenter cc
left outer join [hcsql2\sql2005].hcfmdirectory.dbo.tblcenter tc
	on tc.center_num = cc.centerid
where tc.inactive = 0 and cc.isactiveflag = 1 and
	cc.address1 <> tc.address1

update cc
set cc.address2 = tc.address2
--select cc.address2 as 'CMSaddress2', tc.address2,*
from cfgcenter cc
left outer join [hcsql2\sql2005].hcfmdirectory.dbo.tblcenter tc
	on tc.center_num = cc.centerid
where tc.inactive = 0 and cc.isactiveflag = 1 and
	cc.address2 <> tc.address2

update cc
set cc.city = tc.city
--select cc.city as 'CMSCity', tc.city,*
from cfgcenter cc
left outer join [hcsql2\sql2005].hcfmdirectory.dbo.tblcenter tc
	on tc.center_num = cc.centerid
where tc.inactive = 0 and cc.isactiveflag = 1 and
	cc.city <> tc.city

update cc
set cc.postalcode = tc.zip
--select cc.postalcode as 'CMSzip', tc.zip,*
from cfgcenter cc
left outer join [hcsql2\sql2005].hcfmdirectory.dbo.tblcenter tc
	on tc.center_num = cc.centerid
where tc.inactive = 0 and cc.isactiveflag = 1 and
	cc.postalcode <> tc.zip

update cc
set cc.phone1 = tc.phone
--select cc.phone1 as 'CMSphone', tc.phone,*
from cfgcenter cc
left outer join [hcsql2\sql2005].hcfmdirectory.dbo.tblcenter tc
	on tc.center_num = cc.centerid
where tc.inactive = 0 and cc.isactiveflag = 1 and
	cc.phone1 <> tc.phone

update cfgcenter
set stateid = 52
where centerid in (691,891)

update cfgcenter
set stateid = 59, CountryID = 2
where centerid in (228,328)


update cfgcenter
set countryid = 1
where centerid in (219,319)

update cfgcenter
set countryid = 2
where centerid in (229,329)

END
