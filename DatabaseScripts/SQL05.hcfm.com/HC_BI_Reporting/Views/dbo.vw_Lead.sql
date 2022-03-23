/* CreateDate: 09/01/2011 15:19:21.537 , ModifyDate: 08/23/2017 16:42:50.207 */
GO
/***********************************************************************
VIEW:					vw_Lead
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR:			HDu
------------------------------------------------------------------------
NOTES:

09/01/2011 - HD - Initial Rewrite to SQL06, a number of columns have no translation from the Warehouse version.
03/28/2013 - KM - Added in restrictions to primary flag for email, address, phone.
12/02/2013 - DL - Changed the Time column from Hour24 (int) to Time24 (varchar) based on a request from Rev.
12/03/2013 - DL - Added the AreaCode to the Phone column as per a request from Rev.
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM dbo.vw_Lead WHERE RecordID = 'APX1510760'
***********************************************************************/
CREATE VIEW [dbo].[vw_Lead]
AS
--SELECT  Center.CenterSSID 'Center'
--,		Contact.ContactSSID 'RecordID' -- Would be better to use Contact.CenterSSID or Contact.ContactCenterSSID but it is not populated
--,       Contact.ContactFirstName 'FirstName'
--,       Contact.ContactLastName 'LastName'
--,       DCP.AreaCode + DCP.PhoneNumber 'Phone'
--,       DCA.AddressLine1 'Address1'
--,       DCA.AddressLine2 'Address2'
--,       DCA.City 'City'
--,       DCA.StateCode 'State'
--,       DCA.ZipCode 'Zip'
--,       Contact.ContactCenterSSID 'Territory_Original'
--,       Contact.ContactAlternateCenter 'Territory_Alternate' -- Contact.CenterSSID or Contact.ContactCenterSSID or Contact.ContactAlternateCenter
--,		Employee.EmployeeSSID 'SalesPerson'
--,       NULL 'SalesPersonID'
--,       Gender.GenderDescription 'Gender'
--,       NULL 'GenderID' --Key?
--,       Ethnicity.EthnicityDescription 'Ethnicity'
--,       NULL 'EthnicityID' --Key?
--,       Occupation.OccupationDescription 'Occupation'
--,       NULL 'OccupationID' --Key?
--,       MaritalStatus.MaritalStatusDescription 'MaritalStatus'
--,       NULL 'MaritalStatusID' --Key?
--,       HairLossType.HairLossTypeDescription 'Norwood'
--,       NULL 'NorwoodID' -- Female hairlosstype combined into a single dimension
--,       HairLossType.HairLossTypeDescription 'Ludwig'
--,       NULL 'LudwigID' -- Male hairlosstype combined into a single dimension
--,       Source.SourceSSID 'Source'
--,       NULL 'SourceID' --Key?
--,       AgeRange.AgeRangeDescription 'Age'
--,       NULL 'AgeID' --Key?
--,       CreateDate.FullDate 'Date'
--,       NULL 'DateID' --Key?
--,       CreateTime.Time24 'Time'
--,       NULL 'TimeID' --Key?
--,       Lead.Appointments 'Appointment'
--,       AppointmentDate.ActivityDueDate 'Appointment_Date'
--,       Lead.Shows 'Show'
--,       ShowDate.ActivityDueDate 'Show_Date'
--,       Lead.Sales 'Sale'
--,       SaleDate.ActivityDueDate 'Sale_Date'
--,       NULL 'Timestamp'
--,       ContactEmail.Email 'Email'
--,       NULL 'cst_sessionid'
--,       Contact.ContactAffiliateID 'cst_affiliateid'
--,       NULL 'adi_flag'
--,       Contact.ContactStatusSSID 'contact_status_code'
--,       NULL 'updated_date'
--,       NULL 'updated_by_user_code'
--,       Contact.ContactLanguageSSID 'cst_language_code'
--,       Contact.DoNotMailFlag 'cst_do_not_mail'
--,       Contact.DoNotEmailFlag 'cst_do_not_email'
--,       Contact.DoNotCallFlag 'cst_do_not_call'
--,       Contact.DoNotSolicitFlag 'do_not_solicit'
--,       Contact.ContactPromotonSSID 'cst_promotion_code'
--FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactLead Lead
--        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContact Contact
--            ON Lead.ContactKey = Contact.ContactKey
--		--May have multiple rows check later, maybe use PrimaryFlag to filter
--        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactPhone DCP
--            ON Contact.ContactSSID = DCP.ContactSSID
--               AND DCP.PrimaryFlag = 'Y'
--		--May have multiple rows check later, maybe use PrimaryFlag to filter
--        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactAddress DCA
--            ON Contact.ContactSSID = DCA.ContactSSID
--               AND DCA.PrimaryFlag = 'Y'
--		--May have multiple rows check later, maybe use PrimaryFlag to filter
--        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactEmail ContactEmail
--            ON Contact.ContactSSID = ContactEmail.ContactSSID
--               AND ContactEmail.PrimaryFlag = 'Y'
--        LEFT OUTER JOIN ( SELECT    ROW_NUMBER() OVER ( PARTITION BY ContactSSID ORDER BY ActivityDueDate DESC ) RANKING
--                          ,         ContactSSID
--                          ,         ActivityDueDate
--                          ,         ActionCodeSSID
--                          FROM      [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivity]
--                          WHERE     IsSale = 1
--                        ) SaleDate
--            ON Contact.ContactSSID = SaleDate.ContactSSID
--               AND SaleDate.RANKING = 1
--		-- Show Date
--        LEFT OUTER JOIN ( SELECT    ROW_NUMBER() OVER ( PARTITION BY ContactSSID ORDER BY ActivityDueDate DESC ) RANKING
--                          ,         ContactSSID
--                          ,         ActivityDueDate
--                          ,         ActionCodeSSID
--                          FROM      [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivity]
--                          WHERE     IsShow = 1
--                        ) ShowDate
--            ON Contact.ContactSSID = ShowDate.ContactSSID
--               AND ShowDate.RANKING = 1
--		-- Appointment Date
--        LEFT OUTER JOIN ( SELECT    ROW_NUMBER() OVER ( PARTITION BY ContactSSID ORDER BY ActivityDueDate DESC ) RANKING
--                          ,         ContactSSID
--                          ,         ActivityDueDate
--                          ,         ActionCodeSSID
--                          FROM      [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivity]
--                          WHERE     IsAppointment = 1
--                        ) AppointmentDate
--            ON Contact.ContactSSID = AppointmentDate.ContactSSID
--               AND AppointmentDate.RANKING = 1
--        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter Center
--            ON lead.CenterKey = Center.CenterKey
--        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimEmployee Employee
--            ON Lead.EmployeeKey = Employee.EmployeeKey
--        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimGender Gender
--            ON Lead.GenderKey = Gender.GenderKey
--        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimEthnicity Ethnicity
--            ON Lead.EthnicityKey = Ethnicity.EthnicityKey
--        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimOccupation Occupation
--            ON Lead.OccupationKey = Occupation.OccupationKey
--        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimMaritalStatus MaritalStatus
--            ON Lead.MaritalStatusKey = MaritalStatus.MaritalStatusKey
--        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimHairLossType HairLossType
--            ON Lead.HairLossTypeKey = HairLossType.HairLossTypeKey
--        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimSource Source
--            ON Lead.SourceKey = Source.SourceKey
--        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimAgeRange AgeRange
--            ON Lead.AgeRangeKey = AgeRange.AgeRangeKey
--        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimDate CreateDate
--            ON Lead.LeadCreationDateKey = CreateDate.DateKey
--        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimTimeOfDay CreateTime
--            ON Lead.LeadCreationTimeKey = CreateTime.TimeOfDayKey


SELECT  ctr.CenterSSID 'Center'
,		dc.ContactSSID 'RecordID'
,       dc.ContactFirstName 'FirstName'
,       dc.ContactLastName 'LastName'
,       DCP.AreaCode + DCP.PhoneNumber 'Phone'
,       DCA.AddressLine1 'Address1'
,       DCA.AddressLine2 'Address2'
,       DCA.City 'City'
,       DCA.StateCode 'State'
,       DCA.ZipCode 'Zip'
,       dc.ContactCenterSSID 'Territory_Original'
,       dc.ContactAlternateCenter 'Territory_Alternate' -- Contact.CenterSSID or Contact.ContactCenterSSID or Contact.ContactAlternateCenter
,		de.EmployeeSSID 'SalesPerson'
,       NULL 'SalesPersonID'
,       dg.GenderDescription 'Gender'
,       NULL 'GenderID' --Key?
,       eth.EthnicityDescription 'Ethnicity'
,       NULL 'EthnicityID' --Key?
,       do.OccupationDescription 'Occupation'
,       NULL 'OccupationID' --Key?
,       dms.MaritalStatusDescription 'MaritalStatus'
,       NULL 'MaritalStatusID' --Key?
,       hlt.HairLossTypeDescription 'Norwood'
,       NULL 'NorwoodID' -- Female hairlosstype combined into a single dimension
,       hlt.HairLossTypeDescription 'Ludwig'
,       NULL 'LudwigID' -- Male hairlosstype combined into a single dimension
,       ds.SourceSSID 'Source'
,       NULL 'SourceID' --Key?
,       ar.AgeRangeDescription 'Age'
,       NULL 'AgeID' --Key?
,       dd.FullDate 'Date'
,       NULL 'DateID' --Key?
,       tod.Time24 'Time'
,       NULL 'TimeID' --Key?
,       fl.Appointments 'Appointment'
,       o_Appointment.AppointmentDate 'Appointment_Date'
,       fl.Shows 'Show'
,       o_Show.ShowDate 'Show_Date'
,       fl.Sales 'Sale'
,       o_Sale.SaleDate 'Sale_Date'
,       NULL 'Timestamp'
,       dce.Email 'Email'
,       NULL 'cst_sessionid'
,       dc.ContactAffiliateID 'cst_affiliateid'
,       NULL 'adi_flag'
,       dc.ContactStatusSSID 'contact_status_code'
,       NULL 'updated_date'
,       NULL 'updated_by_user_code'
,       dc.ContactLanguageSSID 'cst_language_code'
,       dc.DoNotMailFlag 'cst_do_not_mail'
,       dc.DoNotEmailFlag 'cst_do_not_email'
,       dc.DoNotCallFlag 'cst_do_not_call'
,       dc.DoNotSolicitFlag 'do_not_solicit'
,       dc.ContactPromotonSSID 'cst_promotion_code'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
            ON dc.ContactKey = fl.ContactKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone dcp
            ON dcp.ContactSSID = dc.ContactSSID
               AND dcp.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactAddress dca
            ON dca.ContactSSID = dc.ContactSSID
               AND dca.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactEmail dce
            ON dce.ContactSSID = dc.ContactSSID
               AND dce.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
            ON ctr.CenterKey = fl.CenterKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee de
            ON de.EmployeeKey = fl.EmployeeKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender dg
            ON dg.GenderKey = fl.GenderKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity eth
            ON eth.EthnicityKey = fl.EthnicityKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimOccupation do
            ON do.OccupationKey = fl.OccupationKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimMaritalStatus dms
            ON dms.MaritalStatusKey = fl.MaritalStatusKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimHairLossType hlt
            ON hlt.HairLossTypeKey = fl.HairLossTypeKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ds
            ON ds.SourceKey = fl.SourceKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange ar
            ON ar.AgeRangeKey = fl.AgeRangeKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
            ON dd.DateKey = fl.LeadCreationDateKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimTimeOfDay tod
            ON tod.TimeOfDayKey = fl.LeadCreationTimeKey
        OUTER APPLY ( SELECT TOP 1
                                da.ActivityDueDate AS 'SaleDate'
                      FROM      HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity da
                      WHERE     da.IsSale = 1
                                AND da.ContactSSID = dc.ContactSSID
                      ORDER BY  da.ActivityDueDate DESC
                    ) o_Sale
        OUTER APPLY ( SELECT TOP 1
                                da.ActivityDueDate AS 'ShowDate'
                      FROM      HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity da
                      WHERE     da.IsShow = 1
                                AND da.ContactSSID = dc.ContactSSID
                      ORDER BY  da.ActivityDueDate DESC
                    ) o_Show
        OUTER APPLY ( SELECT TOP 1
                                da.ActivityDueDate AS 'AppointmentDate'
                      FROM      HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity da
                      WHERE     da.IsAppointment = 1
                                AND da.ContactSSID = dc.ContactSSID
                      ORDER BY  da.ActivityDueDate DESC
                    ) o_Appointment
GO
