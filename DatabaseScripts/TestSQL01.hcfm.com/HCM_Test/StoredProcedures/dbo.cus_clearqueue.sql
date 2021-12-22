/* CreateDate: 10/12/2006 14:41:26.430 , ModifyDate: 05/01/2010 14:48:12.210 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[cus_clearqueue] AS

DELETE FROM csta_queue_user
update 	oncd_activity
set 		cst_lock_by_user_code = null,
				cst_lock_date = null
where 	cst_lock_by_user_code is not null
GO
