/* CreateDate: 10/17/2007 08:55:08.540 , ModifyDate: 05/01/2010 14:48:10.423 */
GO
CREATE PROCEDURE [dbo].[spMNT_DeleteOpenOutCall]

AS


/*******************************************************************************************************

PROCEDURE:	spMNT_DeleteOpenOutCall	VERSION 2.0

DESTINATION SERVER:	HCSQL3\SQL2005

DESTINATION DATABASE: HCM

RELATED APPLICATION: Oncontact

AUTHOR:	Brian Kellman

IMPLEMENTOR: Brian Kellman

DATE IMPLEMENTED: 5/29/2007

DATE MODIFIED:	  10/10/2007

12/17/2008 ONC PSO Fred Remers - removed from nightly cleanup job. See comments at bottom of sp
--------------------------------------------------------------------------------------------------------
NOTES: This procedure deletes outcalls after a cutomer has already had contact with a center.
BK: 10/10/2007 Modified for new Oncontact application
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
exec spMNT_DeleteOpenOutCall

********************************************************************************************************/



DELETE FROM oncd_activity
WHERE EXISTS (SELECT 1 FROM oncd_activity a1 INNER JOIN oncd_activity_contact ac1
		ON ac1.activity_id = a1.activity_id
		AND ac1.primary_flag = 'Y'
		AND ac1.contact_id = (SELECT TOP 1 contact_id
								FROM oncd_activity_contact ac2
								WHERE ac2.primary_flag = 'Y'
								AND ac2.activity_id = oncd_activity.activity_id)
		AND a1.result_code = 'SHOWNOSALE')
        AND oncd_activity.action_code IN('NOSHOWCALL','BROCHCALL','CANCELCALL')
		AND (oncd_activity.result_code IS NULL OR oncd_activity.result_code = '')



-- ONC PSO FRED REMERS
-- The call to this stored proc was removed from the nightly job. If this needs to be called
-- at a later time, the SQL should be optimized as shown below. Furtermore, the list of
-- outbound action codes is not complete:
-- ('CONFIRM' ,'EXOUTCALL','OUTSELECT','BROCHCALL','CANCELCALL','NOSHOWCALL',’SHNOBUYCAL’)
-- and the a1.result_codes may also need to include SHOWSALE.

--DELETE FROM oncd_activity
--WHERE oncd_activity.action_code IN('NOSHOWCALL','BROCHCALL','CANCELCALL')
--      and (oncd_activity.result_code IS NULL OR oncd_activity.result_code = '')
--and EXISTS (SELECT 1
--FROM oncd_activity_contact ac2
--INNER JOIN oncd_activity_contact ac1 on ac2.contact_id = ac1.contact_id
--            AND ac1.primary_flag = 'Y'
--inner join oncd_activity a1 oN ac1.activity_id = a1.activity_id AND a1.result_code IN ('SHOWNOSALE','SHOWSALE')
--where ac2.activity_id = oncd_activity.activity_id
--and ac2.primary_flag = 'Y' )
GO
