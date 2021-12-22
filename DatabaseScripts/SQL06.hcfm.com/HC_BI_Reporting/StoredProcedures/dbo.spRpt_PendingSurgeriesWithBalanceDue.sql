/* CreateDate: 06/29/2011 12:12:16.030 , ModifyDate: 06/19/2019 16:38:28.457 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
Procedure Name:			spRpt_PendingSurgeriesWithBalanceDue
Procedure Description:

Created By:				Dominic Leiba
Implemented By:			Marlon Burrell
Last Modified By:		Kevin Murdoch

Date Created:			4/24/2009
Date Implemented:		4/24/2009
Date Last Modified:		6/29/2011

Destination Server:		SQL06
Destination Database:	HC_BI_Reporting
Related Application:		Surgery Schedule Report

===============================================================================================
CHANGE HISTORY:
05/05/2009 - DL - Changed [AppointmentDate] column format to MM/DD/YYY; Added the [StartTime] column
06/25/2009 - DL - The center being displayed was the Performing Center and not the Client Home Center;
					Changed the stored procedure to display the Client Home Center.
01/13/2016 - RH - Changed the stored procedure to pull from tables on SQL06.HC_BI_Reporting
02/01/2016 - RH - We no longer keep appointments for surgeries; rewrote query; added AND CM.ClientMembershipStatusDescription NOT IN('Cancel','Expire','Inactive','Surgery Performed')
06/19/2019 - RH - Changed to ISNULL(CMA.CenterManagementAreaDescription,R.RegionDescription) from R.RegionDescription
===============================================================================================
SAMPLE EXECUTION:

EXEC spRpt_PendingSurgeriesWithBalanceDue
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_PendingSurgeriesWithBalanceDue]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT R.RegionSortOrder
,	DDR.DoctorRegionSSID
,	CASE WHEN DDR.DoctorRegionDescription NOT LIKE 'Dr.%' THEN ISNULL(CMA.CenterManagementAreaDescription,R.RegionDescription) ELSE DDR.DoctorRegionDescription  END AS 'DoctorRegionDescription'
,	CLT.CenterSSID
,	CTR.CenterDescriptionNumber
,	CLT.ClientFullName
,	'(' + LEFT(CLT.ClientPhone1, 3) + ') ' + SUBSTRING(CLT.ClientPhone1, 1, 3) + '-' + RIGHT(CLT.ClientPhone1, 4) AS 'Phone'
,	CM.ClientMembershipContractPaidAmount
,	CLT.ClientARBalance
,	CM.ClientMembershipStatusDescription
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CLT.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
	ON CTR.RegionKey = R.RegionKey
LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimDoctorRegion DDR
	ON CTR.DoctorRegionKey = DDR.DoctorRegionKey
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
	ON CLT.CurrentSurgeryClientMembershipSSID = CM.ClientMembershipSSID
LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment AP
	ON CLT.CurrentSurgeryClientMembershipSSID = AP.ClientMembershipSSID
WHERE CLT.ClientARBalance > 0
AND CM.ClientMembershipStatusDescription NOT IN('Cancel','Expire','Inactive','Surgery Performed')
GROUP BY CASE WHEN DDR.DoctorRegionDescription NOT LIKE 'Dr.%' THEN ISNULL(CMA.CenterManagementAreaDescription,R.RegionDescription) ELSE DDR.DoctorRegionDescription END
       , CLT.ClientPhone1
       , R.RegionSortOrder
       , DDR.DoctorRegionSSID
       , CLT.CenterSSID
       , CTR.CenterDescriptionNumber
       , CLT.ClientFullName
       , CM.ClientMembershipContractPaidAmount
       , CLT.ClientARBalance
	   ,	CM.ClientMembershipStatusDescription


END
GO
