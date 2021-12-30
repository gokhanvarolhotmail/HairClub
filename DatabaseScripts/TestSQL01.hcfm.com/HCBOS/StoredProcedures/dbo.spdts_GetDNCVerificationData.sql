/* CreateDate: 11/15/2006 11:19:30.850 , ModifyDate: 01/25/2010 08:11:31.760 */
GO
/***********************************************************************

PROCEDURE:	spdts_GetDNCVerificationData	VERSION  1.0

DESTINATION SERVER:	   HCSQL3

DESTINATION DATABASE: BOS

RELATED APPLICATION:  DNC Verification Report

AUTHOR: Howard Abelow

IMPLEMENTOR: Howard Abelow

DATE IMPLEMENTED: 11/15/2006

LAST REVISION DATE: 11/15/2006

--------------------------------------------------------------------------------------------------------
NOTES: This procedure is used to build the DNC Verification report by transferring the daily data into a reporting table
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
exec spdts_GetDNCVerificationData '10/10/2007'

***********************************************************************/


CREATE PROCEDURE [dbo].[spdts_GetDNCVerificationData]


AS

INSERT INTO dbo.DNCVerificationReport
Select Distinct CAST(CONVERT(VarChar(12),  GETDATE(), 101) as Datetime) as SendDate
,	SUM(Case When phone IS NOT NULL Then 1 ELSE 0 END) as TotalSent
,	CAST(SUM(Case When LEN(RTRIM(LTRIM(ListFlag))) > 0 AND ListFlag NOT IN ('WIR', 'NXX') Then 1 Else 0 End) as Float) as TrueDNC
,	CAST(SUM(Case When LEN(RTRIM(LTRIM(ListFlag))) = 0 Then 1 ELSE 0 END) as Float) as NoDNC
,	SUM(Case When ListFlag = 'NXX' Then 1 Else 0 End) as NonExistentNumbers
,	SUM(Case When ListFlag = 'WIR' Then 1 Else 0 End) as WirelessDNC
,	CAST(HCM.dbo.Divide(CAST(SUM(Case When LEN(RTRIM(LTRIM(ListFlag))) > 0 AND ListFlag NOT IN ('WIR', 'NXX') Then 1 Else 0 End) as Float)
		,CAST(SUM(Case When phone IS NOT NULL Then 1 ELSE 0 END) as Float) )as smallmoney) as DNCPercent
from dbo.InquiryScrubbed
where phone <> '9999999999'
GO
