/* CreateDate: 11/14/2006 10:39:22.663 , ModifyDate: 01/25/2010 08:11:31.760 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:	sprpt_DNCVerificationReport	VERSION  1.0

DESTINATION SERVER:	   HCSQL3

DESTINATION DATABASE: BOS

RELATED APPLICATION:  DNC Verification Report

AUTHOR: Howard Abelow

IMPLEMENTOR: Howard Abelow

DATE IMPLEMENTED: 11/14/2006

LAST REVISION DATE: 11/15/2006

--------------------------------------------------------------------------------------------------------
NOTES: This procedure is used to get the data for the DNC Verification report. Its an SSRS Report
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
exec sprpt_DNCVerificationReport  '11/15/2006', '11/15/2006'

***********************************************************************/


CREATE PROCEDURE [dbo].[sprpt_DNCVerificationReport]
	@begDate  dateTime,
	@endDate  dateTime

AS

Select  SendDate
,	TotalSent
,	TrueDNC
,	NoDNC
,	NonExistentNumbers
,	WirelessDNC
,	DNCPercent
from dbo.DNCVerificationReport
where SendDate Between @begDate and @endDate + '23:59:59'
Order By SendDate
GO
