/* CreateDate: 08/10/2006 13:53:09.797 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****

	BK: Uses HCSQL2 linked server 8/14/2006
	KM: Changed hcfmdirectory to hcsql2\sql2005 3/31/08

****/

-- =============================================
-- SELECTS ALL CURRENT CLOSINGS FOR THE WEB INETRFACE
-- =============================================
CREATE       PROCEDURE [dbo].[spapp_Get_CenterClosings]

AS
	SELECT closingID
	,	CAST(closings.Center AS VARCHAR(3)) + ' - ' + centers.center as 'Center'
	,	CloseDate
	,	FromTime
	,	ToTime
	FROM dbo.Appointments_Special_Closings closings
		INNER JOIN [HCSQL2\sql2005].HCFMDirectory.dbo.tblCenter centers
		ON CAST(closings.center AS VARCHAR(3)) = centers.Center_Num
	WHERE Active = 1
	AND CAST(Closedate as DateTime) >=  CAST(CONVERT(varchar(10), GetDate(), 110) AS datetime)
	--AND Closedate >= CONVERT(Varchar(10), GetDate(), 101) :  eliminated the next year so repalce with statement above (HA 12/14/2006)
	ORDER BY CAST(Closedate as DateTime), closings.Center
GO
