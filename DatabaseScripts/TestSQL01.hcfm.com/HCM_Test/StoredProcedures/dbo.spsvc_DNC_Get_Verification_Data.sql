/* CreateDate: 03/20/2009 14:12:09.517 , ModifyDate: 06/22/2015 11:03:22.640 */
GO
/***********************************************************************

PROCEDURE:	spsvc_DNC_Get_Verification_Data

DESTINATION SERVER:	hcsql3\sql2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		OnContact PSO Fred Remers

IMPLEMENTOR: 		Fred Remers

DATE IMPLEMENTED:

LAST REVISION DATE: 2015-06-11	Workwise, LLC MJW
						Include check to psoIsValidPhone UDF in SELECT

--------------------------------------------------------------------------------------------------------
NOTES: This procedure is used to build the DNC Verification report by transferring the daily data into a reporting table
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
exec spsvc_DNC_Get_Verification_Data '10/10/2007'

***********************************************************************/


CREATE PROCEDURE [dbo].[spsvc_DNC_Get_Verification_Data]


AS

INSERT INTO cstd_dnc_verification_report
Select Distinct CAST(CONVERT(VarChar(12),  GETDATE(), 101) as Datetime) as SendDate
,	SUM(Case When phone IS NOT NULL Then 1 ELSE 0 END) as TotalSent
,	CAST(SUM(Case When LEN(RTRIM(LTRIM(ListFlag))) > 0 AND ListFlag NOT IN ('WIR', 'NXX') Then 1 Else 0 End) as Float) as TrueDNC
,	CAST(SUM(Case When LEN(RTRIM(LTRIM(ListFlag))) = 0 Then 1 ELSE 0 END) as Float) as NoDNC
,	SUM(Case When ListFlag = 'NXX' Then 1 Else 0 End) as NonExistentNumbers
,	SUM(Case When ListFlag = 'WIR' Then 1 Else 0 End) as WirelessDNC
,	CAST(dbo.Divide(CAST(SUM(Case When LEN(RTRIM(LTRIM(ListFlag))) > 0 AND ListFlag NOT IN ('WIR', 'NXX') Then 1 Else 0 End) as Float)
		,CAST(SUM(Case When phone IS NOT NULL Then 1 ELSE 0 END) as Float) )as smallmoney) as DNCPercent
from cstd_dnc_inquiry_scrubbed
where phone <> '9999999999'
	AND dbo.psoIsValidPhone(LEFT(phone,3),SUBSTRING(phone,4,7)) = 'Y'
GO
