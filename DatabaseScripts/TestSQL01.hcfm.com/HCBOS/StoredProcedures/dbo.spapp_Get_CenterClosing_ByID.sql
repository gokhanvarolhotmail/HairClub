/* CreateDate: 08/10/2006 13:53:11.687 , ModifyDate: 01/25/2010 08:11:31.730 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- SELECTS ALL CURRENT CLOSINGS FOR THE WEB INETRFACE

-- EXEC spapp_Get_CenterClosing_ByID 1722
-- =============================================
CREATE   PROCEDURE [dbo].[spapp_Get_CenterClosing_ByID]
	@closingID integer

AS
	SELECT closingID
	,	CAST(closings.Center AS VARCHAR(3)) as 'Center' --+ ' - ' + centers.center
	,	CloseDate
	,	FromTime
	,	ToTime
	, 	Active
	FROM dbo.Appointments_Special_Closings closings
		--ON CAST(closings.center AS VARCHAR(3)) = centers.Center_Num
	WHERE Active = 1
	--AND Closedate >= CONVERT(Varchar(10), GetDate(), 101)
	AND CAST(Closedate as DateTime) >=  CAST(CONVERT(varchar(10), GetDate(), 110) AS datetime)
	AND Closingid = @closingID
	ORDER BY CAST(Closedate as DateTime), closings.Center
GO
