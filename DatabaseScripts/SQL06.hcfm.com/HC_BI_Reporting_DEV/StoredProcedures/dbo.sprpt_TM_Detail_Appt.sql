/* CreateDate: 08/19/2011 13:26:11.910 , ModifyDate: 10/01/2019 14:32:21.470 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================

PROCEDURE:				sprpt_TM_Detail_Appt

VERSION:				v1.0

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_Reporting

RELATED APPLICATION:  	TM Detail Sales Report

AUTHOR: 				Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		 10/26/2007

LAST REVISION DATE: 	 8/29/2011

==============================================================================
DESCRIPTION: Returns name, address, action and result_codes for specified lead that had valid Appts.
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
08/29/2011: HDu - Corrections to Phone concat and casting time and act_code, create_date, create_time output aliases
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC sprpt_TM_Detail_Appt '8/1/11', '8/15/11', 201
==============================================================================*/

CREATE  PROCEDURE [dbo].[sprpt_TM_Detail_Appt]
( @BegDt datetime, @EndDt datetime, @Terr varchar(4)) AS

SET @EndDt = @EndDt + ' 23:59:00'

SET NOCOUNT ON


select top 1000
		ctr.CenterDescriptionNumber as 'Center'
	,	dbo.ENTRYPOINT(emp.EmployeeSSID) as 'Type'
	,	emp.EmployeeSSID
--	,	dc.ContactSSID as 'Recordid'
    ,   dc.SFDC_LeadID as 'Recordid'
	,	dc.ContactLastName as 'LastName'
	,	dc.ContactFirstName as 'FirstName'
	,	dca.AddressLine1 as 'Address1'
	,	dca.AddressLine2 as 'Address2'
	,	dca.City as 'City'
	,	dca.StateCode as 'State'
	,	dca.ZipCode as 'Zip'
	,	'(' + dcp.AreaCode + ')' + ' ' + SUBSTRING(dcp.phonenumber,1,3) + '-' + SUBSTRING(dcp.phonenumber,4,4) as phone
	,	RTRIM(da.[ActionCodeSSID]) + ' - ' + da.[ResultCodeSSID]  AS act_code
	,	da.ActivityDueDate as 'date_'
	,	CAST(right(convert(varchar(20),da.ActivityStartTime,100),7) AS TIME) as 'time_'
	--,*


from dbo.synHC_MKTG_DDS_vwDimActivity da
	LEFT OUTER join dbo.synHC_MKTG_DDS_vwFactActivity fa
		on da.activitykey = fa.ActivityKey
	LEFT OUTER join dbo.synHC_MKTG_DDS_vwFactLead fl
		on fa.ContactKey = fl.ContactKey
	LEFT outer join dbo.synHC_MKTG_DDS_vwDimContact dc
		on fl.ContactKey = dc.ContactKey
	left outer join dbo.synHC_MKTG_DDS_vwDimContactAddress dca
		--on da.contactssid = dca.contactssid
		  on da.sfdc_leadid = dca.sfdc_leadid
			and dca.PrimaryFlag = 'Y'
	inner join dbo.synHC_ENT_DDS_vwDimCenter ctr
		on da.CenterSSID = ctr.CenterSSID
	left outer join dbo.synHC_MKTG_DDS_vwDimEmployee emp
		on fl.EmployeeKey = emp.EmployeeKey
	left outer join dbo.synHC_MKTG_DDS_vwDimContactPhone dcp
		on da.sfdc_leadid = dcp.sfdc_leadid
			and dcp.PrimaryFlag = 'Y'
where
	ctr.CenterSSID = @Terr
	and da.isappointment = 1
	and da.ResultCodeSSID NOT IN ( 'CANCEL', 'RESCHEDULE', 'CTREXCPTN')
	and ActivityDueDate between @BegDt and @EndDt
order by dc.ContactLastName, dc.ContactFirstName
GO
