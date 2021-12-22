/* CreateDate: 03/25/2019 10:25:11.613 , ModifyDate: 04/18/2019 11:42:35.850 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spDB_PopulateCenter
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/22/2019
DESCRIPTION:			Used to populate the Center locations (by area) used in Dashboards
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spDB_PopulateCenter
***********************************************************************/
CREATE PROCEDURE [dbo].[spDB_PopulateCenter]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	AreaID INT
,	Area NVARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	Address1 NVARCHAR(50)
,	Address2 NVARCHAR(50)
,	Address3 NVARCHAR(50)
,	City NVARCHAR(50)
,	StateCode NVARCHAR(10)
,	ZipCode NVARCHAR(15)
,	Phone1 NVARCHAR(15)
,	Phone1Type NVARCHAR(50)
,	Phone2 NVARCHAR(15)
,	Phone2Type NVARCHAR(50)
,	Phone3 NVARCHAR(15)
,	Phone3Type NVARCHAR(50)
,	SortOrder INT
)


/********************************** Get Center data *************************************/
INSERT	INTO #Center
		SELECT	ISNULL(cma.CenterManagementAreaSSID, 1) AS 'AreaID'
		,		ISNULL(cma.CenterManagementAreaDescription, 'Corporate') AS 'Area'
		,		ctr.CenterKey
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		ctr.CenterAddress1 AS 'Address1'
		,		ctr.CenterAddress2 AS 'Address2'
		,		ctr.CenterAddress3 AS 'Address3'
		,		ctr.City
		,		ctr.StateProvinceDescriptionShort AS 'StateCode'
		,		ctr.PostalCode AS 'ZipCode'
		,		ctr.CenterPhone1 AS 'Phone1'
		,		ctr.CenterPhone1TypeDescription AS 'Phone1Type'
		,		ctr.CenterPhone2 AS 'Phone2'
		,		ctr.CenterPhone2TypeDescription AS 'Phone2Type'
		,		ctr.CenterPhone3 AS 'Phone3'
		,		ctr.CenterPhone3TypeDescription AS 'Phone3Type'
		,		ISNULL(cma.CenterManagementAreaSortOrder, 1) AS 'SortOrder'
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
					ON dct.CenterTypeKey = ctr.CenterTypeKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	dct.CenterTypeDescriptionShort IN ( 'C', 'HW' )
				AND ctr.CenterSSID <> 340
				AND ctr.Active = 'Y'


CREATE NONCLUSTERED INDEX IDX_Center_CenterSSID ON #Center ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );


UPDATE STATISTICS #Center;


/********************************** Return Final Data *************************************/
TRUNCATE TABLE dbCenter


INSERT	INTO dbCenter
		SELECT	c.AreaID
		,		c.Area
		,		c.CenterKey
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		c.Address1
		,		c.Address2
		,		c.Address3
		,		c.City
		,		c.StateCode
		,		c.ZipCode
		,		c.Phone1
		,		c.Phone1Type
		,		c.Phone2
		,		c.Phone2Type
		,		c.Phone3
		,		c.Phone3Type
		,		c.SortOrder
		FROM	#Center c
		ORDER BY c.CenterNumber

END
GO
