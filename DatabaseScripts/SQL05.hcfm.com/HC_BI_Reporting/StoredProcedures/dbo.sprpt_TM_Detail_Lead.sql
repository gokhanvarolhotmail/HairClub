/* CreateDate: 08/19/2011 13:41:40.620 , ModifyDate: 10/01/2019 14:41:40.657 */
GO
/*==============================================================================

PROCEDURE:				sprpt_TM_Detail_Lead

VERSION:				v1.0

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_Reporting

RELATED APPLICATION:  	TM Detail Sales Report

AUTHOR: 				Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		 10/26/2007

LAST REVISION DATE: 	 8/19/2011

==============================================================================
DESCRIPTION: Returns name, address, action and result_codes for specified lead based on create date
==============================================================================

==============================================================================
NOTES:	@begdt  - Begin date of range formated in 'm/d/yy'
			@enddt - End date of range formated in 'm/d/yy'
			@terr  - accepts a valid center number

MODIFIED FROM ORIGINAL IN HCM:
--created by: Ben Singley
--date:10/25/01

10/29/2007: Habelow - added action_code concatenated to result_code to display type of show witH ONCV
08/19/2011: KMurdoch - Migrated to new BI Environment
08/29/2011: HDu - Corrections to Phone concat and create_date, create_time output alias
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC sprpt_TM_Detail_Lead '8/1/16', '8/15/16', 201
==============================================================================*/

CREATE  PROCEDURE [dbo].[sprpt_TM_Detail_Lead]
( @BegDt datetime, @EndDt datetime, @Terr varchar(4)) AS

SET @EndDt = @EndDt + ' 23:59:00'

SET NOCOUNT ON


SELECT
		ctr.CenterDescriptionNumber as 'Center'
	,	dbo.ENTRYPOINT(emp.EmployeeSSID) as 'Type'
	,	dc.sfdc_leadid as 'Recordid'
	,	dc.ContactLastName as 'LastName'
	,	dc.ContactFirstName as 'FirstName'
	,	dca.AddressLine1 as 'Address1'
	,	dca.AddressLine2 as 'Address2'
	,	dca.City as 'City'
	,	dca.StateCode as 'State'
	,	dca.ZipCode as 'Zip'
	,	'(' + dcp.AreaCode + ')' + ' ' + SUBSTRING(dcp.phonenumber,1,3) + '-' + SUBSTRING(dcp.phonenumber,4,4) as phone
	,	emp.EmployeeSSID as 'create_by'
	,	dd.fulldate as 'create_date'
	,	CAST(dt.MinuteName AS TIME) as 'create_time'

FROM  dbo.synHC_MKTG_DDS_vwFactLead fl
	LEFT outer join dbo.synHC_MKTG_DDS_vwDimContact dc
		ON fl.ContactKey = dc.ContactKey
	left outer join dbo.synHC_MKTG_DDS_vwDimContactAddress dca
		ON dc.sfdc_leadid = dca.sfdc_leadid
			and dca.PrimaryFlag = 'Y'
	inner join dbo.synHC_ENT_DDS_vwDimCenter ctr
		ON fl.CenterKey = ctr.CenterKey
	left outer join dbo.synHC_MKTG_DDS_vwDimEmployee emp
		ON fl.EmployeeKey = emp.EmployeeKey
	left outer join dbo.synHC_MKTG_DDS_vwDimContactPhone dcp
		ON dc.sfdc_leadid = dcp.sfdc_leadid
			and dcp.PrimaryFlag = 'Y'
	left outer join dbo.synHC_ENT_DDS_vwDimDate dd
		ON fl.LeadCreationDateKey = dd.datekey
	left outer join dbo.synHC_ENT_DDS_vwDimTimeOfDay dt
		ON fl.LeadCreationTimeKey = dt.TimeOfDayKey
WHERE
	ctr.CenterSSID = @Terr
	and dd.fulldate between @BegDt and @EndDt

ORDER BY
	dc.ContactLastName, dc.ContactFirstName
GO
