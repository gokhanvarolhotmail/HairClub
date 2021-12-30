/* CreateDate: 01/31/2017 09:54:59.923 , ModifyDate: 03/15/2017 10:52:15.733 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SilverpopClientLeadSMSConsentExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APPLICATION:	Silverpop Export
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/16/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_SilverpopClientLeadSMSConsentExport 580
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SilverpopClientLeadSMSConsentExport]
(
	@ExportHeaderID INT
)
AS
BEGIN

;
WITH    c_OI
          AS ( SELECT   CLM.ClientLeadMergeID AS 'RecordID'
               ,        CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', '')) = 10
                             THEN '1' + REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', '')
                             ELSE REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', '')
                        END AS 'SMS_PHONE'
               ,        CASE WHEN ( CLM.DoNotContact = 1 OR CLM.DoNotText = 1 ) THEN 'OPTED-OUT'
                             ELSE 'OPTED-IN'
                        END AS 'CONSENT_STATUS_CODE'
               ,        CASE WHEN CLM.RecordStatus = 'LEAD' THEN CLM.LeadCreateDate
                             ELSE CLM.ClientCreateDate
                        END AS 'CONSENT_DATE'
               FROM     datClientLeadMerge CLM
               WHERE    REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', '') <> ''
						AND CLM.ExportHeaderID = @ExportHeaderID
             )
     SELECT OI.RecordID
     ,      OI.SMS_PHONE AS 'SMS PHONE'
     ,      CASE WHEN LEN(OI.SMS_PHONE) = 11 THEN OI.CONSENT_STATUS_CODE ELSE 'OPTED-OUT' END AS 'CONSENT STATUS CODE'
     ,      CASE WHEN LEN(OI.SMS_PHONE) = 11 THEN CONVERT(VARCHAR(11), OI.CONSENT_DATE, 101) ELSE '' END AS 'CONSENT DATE'
     FROM   c_OI OI

END
GO
