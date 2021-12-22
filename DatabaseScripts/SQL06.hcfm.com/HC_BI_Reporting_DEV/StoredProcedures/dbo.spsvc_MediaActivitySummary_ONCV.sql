/* CreateDate: 09/26/2012 09:26:02.803 , ModifyDate: 04/30/2015 09:21:39.273 */
GO
/***********************************************************************

PROCEDURE:				spsvc_IMSActivitySummary_ONCV

VERSION:				v2.0

DESTINATION SERVER:		SQL05

DESTINATION DATABASE: 	HC_BI_MKTG_DDS

RELATED APPLICATION:  	SSIS WHSEXPIMSActivityExport

ORIGINAL AUTHOR: 		Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		10/04/2007

LAST REVISION DATE: 	08/03/12

------------------------------------------------------------------------
NOTES: 		Gets the Activity Records for IMS Export
REVISIONS:	WJB 03/11/08 Added Sale Type to export
			KRM 11/02/09 Added to select statement - include specific
					result codes.
			KRM	4/28/11 Removed join to Xref file from previous version of Oncontact
			KRM 08/03/12 Moved over to SQL05
------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC spsvc_MediaActivitySummary_ONCV
EXEC spsvc_MediaActivitySummary_ONCV  '4/26/2015'
***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_MediaActivitySummary_ONCV]
    (
		 @EndDt DATETIME = NULL

    )
AS
    BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
        SET NOCOUNT ON ;
--SET @enddt = null
        IF (  @EndDt IS NULL
           )
            BEGIN
                SET @EndDt = DATEADD(dd, -3,
                                     CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
            END

			SELECT
				SUM(case when far.Appointments = 1 then 1 else 0 end )  AS 'Appointments',
				SUM(far.Show) as 'Shows',
				SUM(far.Sale) as 'Sales'
			FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults far
				--inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult dar
				--	on far.ActivityResultKey = dar.ActivityResultKey  --Data is a day behind
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
					on far.ContactKey = dc.ContactKey
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
					on far.ContactKey = fl.ContactKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					on far.CenterKey = ctr.CenterKey
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource src
					on far.SourceKey = src.SourceKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					on far.activityduedatekey = dd.datekey
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimResultCode res
					on far.ResultCodeKey = res.ResultCodeKey
				LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSalesType st
					on far.SalesTypeKey = st.SalesTypeKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender gen
					on far.GenderKey = gen.GenderKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimMaritalStatus ms
					on far.MaritalStatusKey = ms.MaritalStatusKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity et
					on far.EthnicityKey = et.EthnicityKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimOccupation oc
					on far.OccupationKey = oc.OccupationKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange age
					on far.AgeRangeKey = age.AgeRangeKey
				LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource SrcTbl
					on UPPER(LTRIM(RTRIM(src.SourceSSID))) = UPPER(LTRIM(RTRIM(SrcTbl.[SourceSSID])))
			WHERE dd.FullDate = @EndDt
					and (far.Show = 1 or far.Sale = 1 or far.Appointments = 1)
					and res.ResultCodeSSID in ('-2','NOSHOW','SHOWNOSALE','SHOWSALE','PRANK')
					and fl.LeadCreationDateKey > 20050401

		END
GO
