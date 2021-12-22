/* CreateDate: 08/14/2012 15:53:08.953 , ModifyDate: 08/14/2012 15:53:08.953 */
GO
CREATE PROCEDURE [bi_mktg_dds].[DBMaintFactActivity]

AS




UPDATE FA
	set FA.ActivityEmployeeKey = ISNULL(DE.employeekey,-1)
--select au.user_code,de.EmployeeKey,*
from bi_mktg_dds.FactActivity FA
inner join bi_mktg_dds.DimActivity DA
	on fa.ActivityKey = DA.ActivityKey
LEFT OUTER join hcm.dbo.oncd_activity_user AU
	on da.ActivitySSID = au.activity_id
		and au.primary_flag = 'Y'
LEFT OUTER join bi_mktg_dds.DimEmployee DE
	on au.user_code = de.EmployeeSSID
WHERE ActivityEmployeeKey IS NULL

UPDATE FL
	set FL.AssignedEmployeeKey = ISNULL(DE.employeekey,-1)
--select cu.user_code,de.EmployeeKey,*
from bi_mktg_dds.FactLead FL
inner join bi_mktg_dds.DimContact DC
	on fl.ContactKey = DC.ContactKey
LEFT OUTER join hcm.dbo.oncd_contact_user CU
	on DC.contactSSID = cu.Contact_id
		and cu.primary_flag = 'Y'
LEFT OUTER join bi_mktg_dds.DimEmployee DE
	on cu.user_code = de.EmployeeSSID
WHERE AssignedEmployeeKey IS NULL


UPDATE FA
	set FA.ActivityEmployeeKey = ISNULL(DE.employeekey,-1)
--select au.user_code,de.EmployeeKey,*
from bi_mktg_dds.FactActivityResults FA
inner join bi_mktg_dds.DimActivity DA
	on fa.ActivityKey = DA.ActivityKey
LEFT OUTER join hcm.dbo.oncd_activity_user AU
	on da.ActivitySSID = au.activity_id
		and au.primary_flag = 'Y'
LEFT OUTER join bi_mktg_dds.DimEmployee DE
	on au.user_code = de.EmployeeSSID
WHERE ActivityEmployeeKey IS NULL
GO
