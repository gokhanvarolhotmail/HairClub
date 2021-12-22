/* CreateDate: 10/17/2007 08:55:07.980 , ModifyDate: 05/01/2010 14:48:10.053 */
GO
/***********************************************************************

PROCEDURE:		sprpt_CallQueListCount

VERSION:		v2.0

DESTINATION SERVER:	HCSQL3

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	Cal Que List Count Report

AUTHOR: 		Howard Abelow 04/20/2007

IMPLEMENTOR: 		Howard Abelow ONCV

DATE IMPLEMENTED: 	10/12/2007

LAST REVISION DATE: 	10/12/2007

------------------------------------------------------------------------
NOTES: Gets a list of open calling cues and the counts For Report
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC sprpt_CallQueListCount

***********************************************************************/

CREATE PROCEDURE [dbo].[sprpt_CallQueListCount]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		a.project_code
	,	p.description project_desc
	,	count(activity_id) AS project_count
	FROM oncd_activity a
		INNER JOIN onca_project p
			ON a.project_code = p.project_code
	WHERE action_code  = 'OUTCALL'
		AND len(result_code) = 0
	GROUP BY a.project_code
	,	p.description
	ORDER BY
		a.project_code
END
GO
