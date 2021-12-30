/* CreateDate: 10/18/2007 11:23:48.613 , ModifyDate: 05/01/2010 14:48:10.517 */
GO
/*
==============================================================================

PROCEDURE:				spdts_CreateActivity_Company_ForAppts

VERSION:				v1.0

DESTINATION SERVER:		HCSQL3\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	OnContact

AUTHOR: 				On Contact during conversion for ONCV

IMPLEMENTOR: 			Howard Abelow

DATE IMPLEMENTED: 		 10/18/2007

LAST REVISION DATE: 	 10/18/2007

==============================================================================
DESCRIPTION:	Finds Daily Open Appts and creates a record in oncd_activity_company
==============================================================================

==============================================================================
NOTES:
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spdts_CreateActivity_Company_ForAppts
==============================================================================
*/
CREATE  PROCEDURE [dbo].[spdts_CreateActivity_Company_ForAppts]

AS


set nocount on

DECLARE @activity_id nchar(10);
DECLARE @activity_company_id nchar(10);
DECLARE @company_id nchar(10);
DECLARE @sort_order int;
DECLARE @cursorStatus int;
DECLARE @sql nchar(2000);

/*SET @sql = 'DECLARE record_cursor CURSOR FOR
	select a.activity_id ,cc.company_id
		from oncd_activity a
			inner join oncd_activity_contact ac on ac.activity_id = a.activity_id
			inner join oncd_contact_company cc on cc.contact_id = ac.contact_id
					and cc.primary_flag = ''Y''
			where a.action_code in (''APPOINT'',''INHOUSE'',''BEBACK'')
			and (a.result_code is null or a.result_code <= '''')
			and not (exists (select * from oncd_activity_company acomp where
					acomp.activity_id = a.activity_id))' */

SET @sql = 'DECLARE record_cursor CURSOR FOR
select a.activity_id ,cc.company_id
		from oncd_activity a
			inner join oncd_activity_contact ac on ac.activity_id = a.activity_id
			inner join oncd_contact_company cc on cc.contact_id = ac.contact_id
					and cc.primary_flag = ''Y''
			where (ltrim(rtrim(a.action_code)) in (''APPOINT'',''BEBACK'',''INHOUSE'')
			and (a.result_code is null or a.result_code = ''''))
			and not (exists (select * from oncd_activity_company acomp where
					acomp.activity_id = a.activity_id))'


EXEC ( @sql )

OPEN record_cursor

FETCH NEXT FROM record_cursor INTO @activity_id, @company_id



WHILE @@FETCH_STATUS = 0
BEGIN

	SET @activity_company_id = null;
	SET @sort_order = null;

	if ((select count(*) from oncd_activity_company acomp where
					acomp.activity_id = @activity_id) = 0 )
	BEGIN
		EXECUTE [onc_create_primary_key] 10, 'oncd_activity_company', 'activity_company_id',  @activity_company_id OUTPUT  ,'ONC'

		SET @sort_order = 1

		INSERT INTO [oncd_activity_company]
	       ([activity_company_id]
	       ,[activity_id]
	       ,[company_id]
	       ,[sort_order]
	       ,[creation_date]
	       ,[primary_flag])
		VALUES
	       (@activity_company_id
	       ,@activity_id
	       ,@company_id
	       ,@sort_order
	       ,getdate()
	       ,'Y')
	END

	FETCH NEXT FROM record_cursor INTO @activity_id,@company_id

END

CLOSE record_cursor
DEALLOCATE record_cursor
GO
