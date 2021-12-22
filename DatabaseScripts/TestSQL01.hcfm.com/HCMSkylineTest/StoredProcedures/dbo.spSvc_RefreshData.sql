/* CreateDate: 07/08/2015 13:41:49.197 , ModifyDate: 07/08/2015 13:54:53.210 */
GO
/***********************************************************************
PROCEDURE:
DESTINATION SERVER:		HCTESTCMS
DESTINATION DATABASE:	HCMSkylineTest
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/08/2015
------------------------------------------------------------------------
NOTES:

Used to Refresh the Data in HCM_TEST
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_RefreshData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_RefreshData]
AS
BEGIN

DECLARE @refreshdate DATETIME


SET @refreshdate = DATEADD(dd, -1, GETDATE())


SELECT  a.activity_id
INTO    #ACTREFRESH
FROM    [SQL03].HCM.dbo.oncd_activity a
        INNER JOIN [SQL03].HCM.dbo.oncd_activity_company ac
            ON a.activity_id = ac.activity_id
        INNER JOIN [SQL03].HCM.dbo.oncd_company c
            ON ac.company_id = c.company_id
WHERE   ( a.due_date >= @refreshdate OR a.updated_date >= @refreshdate )
        AND a.action_code IN ( 'APPOINT', 'INHOUSE', 'BEBACK', 'RECOVERY' )
		AND c.cst_center_number IN ( 201, 292 )


SELECT  contact_id
INTO    #CTREFRESH
FROM    [SQL03].HCM.dbo.oncd_activity_contact ac
        INNER JOIN #ACTREFRESH
            ON #ACTREFRESH.activity_id = ac.activity_id
GROUP BY contact_id


--
-- onca_user
--
INSERT  INTO [dbo].[onca_user]
        ( [user_code]
        ,[department_code]
        ,[job_function_code]
        ,[login_id]
        ,[password_value]
        ,[password_date]
        ,[password_expires]
        ,[change_password]
        ,[first_name]
        ,[middle_name]
        ,[last_name]
        ,[full_name]
        ,[description]
        ,[title]
        ,[cti_server]
        ,[cti_user_code]
        ,[cti_password]
        ,[cti_station]
        ,[cti_extension]
        ,[action_set_code]
        ,[startup_object_id]
        ,[clear_cache]
        ,[active]
        ,[display_name]
        ,[license_type]
        ,[outlook_sync_frequency]
        ,[outlook_sync_confirm] )
        SELECT  [user_code]
        ,       [department_code]
        ,       [job_function_code]
        ,       [login_id]
        ,       [password_value]
        ,       [password_date]
        ,       [password_expires]
        ,       [change_password]
        ,       [first_name]
        ,       [middle_name]
        ,       [last_name]
        ,       [full_name]
        ,       [description]
        ,       [title]
        ,       [cti_server]
        ,       [cti_user_code]
        ,       [cti_password]
        ,       [cti_station]
        ,       [cti_extension]
        ,       [action_set_code]
        ,       [startup_object_id]
        ,       [clear_cache]
        ,       [active]
        ,       [display_name]
        ,       [license_type]
        ,       [outlook_sync_frequency]
        ,       [outlook_sync_confirm]
        FROM    [SQL03].HCM.dbo.[onca_user]
        WHERE   user_code NOT IN ( SELECT   user_code
                                   FROM     [dbo].[onca_user] )



--
-- csta_promotion_code
--
INSERT  INTO csta_promotion_code
        (promotion_code
        ,description
        ,active )
        SELECT  csta_promotion_code.promotion_code
        ,       csta_promotion_code.description
        ,       csta_promotion_code.active
        FROM    [SQL03].HCM.dbo.[csta_promotion_code]
        WHERE   promotion_code NOT IN ( SELECT  promotion_code
                                        FROM    [dbo].csta_promotion_code )


--
-- onca_source
--
INSERT  INTO [dbo].[onca_source]
        ( [source_code]
        ,[description]
        ,[campaign_code]
        ,[active]
        ,[cst_dnis_number]
        ,[cst_promotion_code]
        ,[cst_age_range_code]
        ,[cst_hair_loss_code]
        ,[cst_language_code]
        ,[cst_created_by_user_code]
        ,[cst_created_date]
        ,[cst_updated_by_user_code]
        ,[cst_updated_date]
        ,[publish] )
        SELECT  [source_code]
        ,       [description]
        ,       [campaign_code]
        ,       [active]
        ,       [cst_dnis_number]
        ,       [cst_promotion_code]
        ,       [cst_age_range_code]
        ,       [cst_hair_loss_code]
        ,       [cst_language_code]
        ,       [cst_created_by_user_code]
        ,       [cst_created_date]
        ,       [cst_updated_by_user_code]
        ,       [cst_updated_date]
        ,       [publish]
        FROM    [SQL03].HCM.dbo.[onca_source]
        WHERE   source_code NOT IN ( SELECT source_code
                                     FROM   [dbo].[onca_source] )


--
-- oncd_activity
--
INSERT  INTO [dbo].[oncd_activity]
        ( [activity_id]
        ,[recur_id]
        ,[opportunity_id]
        ,[incident_id]
        ,[due_date]
        ,[start_time]
        ,[duration]
        ,[action_code]
        ,[description]
        ,[creation_date]
        ,[created_by_user_code]
        ,[completion_date]
        ,[completion_time]
        ,[completed_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[result_code]
        ,[batch_status_code]
        ,[batch_result_code]
        ,[batch_address_type_code]
        ,[priority]
        ,[project_code]
        ,[notify_when_completed]
        ,[campaign_code]
        ,[source_code]
        ,[confirmed_time]
        ,[confirmed_time_from]
        ,[confirmed_time_to]
        ,[document_id]
        ,[milestone_activity_id]
        ,[cst_override_time_zone]
        ,[cst_lock_date]
        ,[cst_lock_by_user_code]
        ,[cst_activity_type_code]
        ,[cst_promotion_code]
        ,[cst_no_followup_flag]
        ,[cst_followup_time]
        ,[cst_followup_date]
        ,[cst_time_zone_code]
        ,[project_id]
        ,[cst_utc_start_date]
        ,[cst_brochure_download] )
        SELECT  oa.[activity_id]
        ,       [recur_id]
        ,       [opportunity_id]
        ,       [incident_id]
        ,       [due_date]
        ,       [start_time]
        ,       [duration]
        ,       [action_code]
        ,       [description]
        ,       [creation_date]
        ,       [created_by_user_code]
        ,       [completion_date]
        ,       [completion_time]
        ,       [completed_by_user_code]
        ,       [updated_date]
        ,       [updated_by_user_code]
        ,       [result_code]
        ,       [batch_status_code]
        ,       [batch_result_code]
        ,       [batch_address_type_code]
        ,       [priority]
        ,       [project_code]
        ,       [notify_when_completed]
        ,       [campaign_code]
        ,       [source_code]
        ,       [confirmed_time]
        ,       [confirmed_time_from]
        ,       [confirmed_time_to]
        ,       [document_id]
        ,       [milestone_activity_id]
        ,       [cst_override_time_zone]
        ,       [cst_lock_date]
        ,       [cst_lock_by_user_code]
        ,       [cst_activity_type_code]
        ,       [cst_promotion_code]
        ,       [cst_no_followup_flag]
        ,       [cst_followup_time]
        ,       [cst_followup_date]
        ,       [cst_time_zone_code]
        ,       [project_id]
        ,       [cst_utc_start_date]
        ,       [cst_brochure_download]
        FROM    #ACTREFRESH a
                INNER JOIN [SQL03].HCM.dbo.[oncd_activity] oa
                    ON a.activity_id = oa.activity_id
        WHERE   a.activity_id NOT IN ( SELECT   activity_id
                                       FROM     oncd_activity )


UPDATE  at
SET     at.[recur_id] = acts.[recur_id]
,       at.[opportunity_id] = acts.[opportunity_id]
,       at.[incident_id] = acts.[incident_id]
,       at.[due_date] = acts.[due_date]
,       at.[start_time] = acts.[start_time]
,       at.[duration] = acts.[duration]
,       at.[action_code] = acts.[action_code]
,       at.[description] = acts.[description]
,       at.[creation_date] = acts.[creation_date]
,       at.[created_by_user_code] = acts.[created_by_user_code]
,       at.[completion_date] = acts.[completion_date]
,       at.[completion_time] = acts.[completion_time]
,       at.[completed_by_user_code] = acts.[completed_by_user_code]
,       at.[updated_date] = acts.[updated_date]
,       at.[updated_by_user_code] = acts.[updated_by_user_code]
,       at.[result_code] = acts.[result_code]
,       at.[batch_status_code] = acts.[batch_status_code]
,       at.[batch_result_code] = acts.[batch_result_code]
,       at.[batch_address_type_code] = acts.[batch_address_type_code]
,       at.[priority] = acts.[priority]
,       at.[project_code] = acts.[project_code]
,       at.[notify_when_completed] = acts.[notify_when_completed]
,       at.[campaign_code] = acts.[campaign_code]
,       at.[source_code] = acts.[source_code]
,       at.[confirmed_time] = acts.[confirmed_time]
,       at.[confirmed_time_from] = acts.[confirmed_time_from]
,       at.[confirmed_time_to] = acts.[confirmed_time_to]
,       at.[document_id] = acts.[document_id]
,       at.[milestone_activity_id] = acts.[milestone_activity_id]
,       at.[cst_override_time_zone] = acts.[cst_override_time_zone]
,       at.[cst_lock_date] = acts.[cst_lock_date]
,       at.[cst_lock_by_user_code] = acts.[cst_lock_by_user_code]
,       at.[cst_activity_type_code] = acts.[cst_activity_type_code]
,       at.[cst_promotion_code] = acts.[cst_promotion_code]
,       at.[cst_no_followup_flag] = acts.[cst_no_followup_flag]
,       at.[cst_followup_time] = acts.[cst_followup_time]
,       at.[cst_followup_date] = acts.[cst_followup_date]
,       at.[cst_time_zone_code] = acts.[cst_time_zone_code]
,       at.[project_id] = acts.[project_id]
,       at.[cst_utc_start_date] = acts.[cst_utc_start_date]
,       at.[cst_brochure_download] = acts.[cst_brochure_download]
FROM    [oncd_activity] at
        INNER JOIN [SQL03].HCM.dbo.oncd_activity acts
            ON at.activity_id = acts.activity_id
WHERE   acts.due_date >= @refreshdate


--
-- oncd_contact
--
INSERT  INTO [dbo].[oncd_contact]
        ( [contact_id]
        ,[greeting]
        ,[first_name]
        ,[middle_name]
        ,[last_name]
        ,[suffix]
        ,[first_name_search]
        ,[last_name_search]
        ,[first_name_soundex]
        ,[last_name_soundex]
        ,[salutation_code]
        ,[contact_status_code]
        ,[external_id]
        ,[contact_method_code]
        ,[do_not_solicit]
        ,[duplicate_check]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[status_updated_date]
        ,[status_updated_by_user_code]
        ,[cst_gender_code]
        ,[cst_call_time]
        ,[cst_complete_sale]
        ,[cst_research]
        ,[cst_dnc_flag]
        ,[cst_referring_store]
        ,[cst_referring_stylist]
        ,[cst_do_not_call]
        ,[cst_language_code]
        ,[cst_promotion_code]
        ,[cst_request_code]
        ,[cst_age_range_code]
        ,[cst_hair_loss_code]
        ,[cst_dnc_date]
        ,[cst_sessionid]
        ,[cst_affiliateid]
        ,[alt_center]
        ,[cst_loginid]
        ,[cst_do_not_email]
        ,[cst_do_not_mail]
        ,[cst_do_not_text]
        ,[surgery_consultation_flag]
        ,[cst_age]
        ,[cst_hair_loss_spot_code]
        ,[cst_hair_loss_experience_code]
        ,[cst_hair_loss_product]
        ,[cst_hair_loss_in_family_code]
        ,[cst_hair_loss_family_code] )
        SELECT  c.[contact_id]
        ,       [greeting]
        ,       [first_name]
        ,       [middle_name]
        ,       [last_name]
        ,       [suffix]
        ,       [first_name_search]
        ,       [last_name_search]
        ,       [first_name_soundex]
        ,       [last_name_soundex]
        ,       [salutation_code]
        ,       [contact_status_code]
        ,       [external_id]
        ,       [contact_method_code]
        ,       [do_not_solicit]
        ,       [duplicate_check]
        ,       [creation_date]
        ,       [created_by_user_code]
        ,       [updated_date]
        ,       [updated_by_user_code]
        ,       [status_updated_date]
        ,       [status_updated_by_user_code]
        ,       [cst_gender_code]
        ,       [cst_call_time]
        ,       [cst_complete_sale]
        ,       [cst_research]
        ,       [cst_dnc_flag]
        ,       [cst_referring_store]
        ,       [cst_referring_stylist]
        ,       [cst_do_not_call]
        ,       [cst_language_code]
        ,       [cst_promotion_code]
        ,       [cst_request_code]
        ,       [cst_age_range_code]
        ,       [cst_hair_loss_code]
        ,       [cst_dnc_date]
        ,       [cst_sessionid]
        ,       [cst_affiliateid]
        ,       [alt_center]
        ,       [cst_loginid]
        ,       [cst_do_not_email]
        ,       [cst_do_not_mail]
        ,       ISNULL([cst_do_not_text], 'N')
        ,       [surgery_consultation_flag]
        ,       [cst_age]
        ,       [cst_hair_loss_spot_code]
        ,       [cst_hair_loss_experience_code]
        ,       [cst_hair_loss_product]
        ,       [cst_hair_loss_in_family_code]
        ,       [cst_hair_loss_family_code]
        FROM    #CTREFRESH cd
                INNER JOIN [SQL03].HCM.dbo.[oncd_contact] c
                    ON cd.contact_id = c.contact_id
        WHERE   cd.contact_id NOT IN ( SELECT   contact_id
                                       FROM     oncd_contact )


UPDATE  ct
SET     ct.[greeting] = cs.[greeting]
,       ct.[first_name] = cs.[first_name]
,       ct.[middle_name] = cs.[middle_name]
,       ct.[last_name] = cs.[last_name]
,       ct.[suffix] = cs.[suffix]
,       ct.[first_name_search] = cs.[first_name_search]
,       ct.[last_name_search] = cs.[last_name_search]
,       ct.[first_name_soundex] = cs.[first_name_soundex]
,       ct.[last_name_soundex] = cs.[last_name_soundex]
,       ct.[salutation_code] = cs.[salutation_code]
,       ct.[contact_status_code] = cs.[contact_status_code]
,       ct.[external_id] = cs.[external_id]
,       ct.[contact_method_code] = cs.[contact_method_code]
,       ct.[do_not_solicit] = cs.[do_not_solicit]
,       ct.[duplicate_check] = cs.[duplicate_check]
,       ct.[creation_date] = cs.[creation_date]
,       ct.[created_by_user_code] = cs.[created_by_user_code]
,       ct.[updated_date] = cs.[updated_date]
,       ct.[updated_by_user_code] = cs.[updated_by_user_code]
,       ct.[status_updated_date] = cs.[status_updated_date]
,       ct.[status_updated_by_user_code] = cs.[status_updated_by_user_code]
,       ct.[cst_gender_code] = cs.[cst_gender_code]
,       ct.[cst_call_time] = cs.[cst_call_time]
,       ct.[cst_complete_sale] = cs.[cst_complete_sale]
,       ct.[cst_research] = cs.[cst_research]
,       ct.[cst_dnc_flag] = cs.[cst_dnc_flag]
,       ct.[cst_referring_store] = cs.[cst_referring_store]
,       ct.[cst_referring_stylist] = cs.[cst_referring_stylist]
,       ct.[cst_do_not_call] = cs.[cst_do_not_call]
,       ct.[cst_language_code] = cs.[cst_language_code]
,       ct.[cst_promotion_code] = cs.[cst_promotion_code]
,       ct.[cst_request_code] = cs.[cst_request_code]
,       ct.[cst_age_range_code] = cs.[cst_age_range_code]
,       ct.[cst_hair_loss_code] = cs.[cst_hair_loss_code]
,       ct.[cst_dnc_date] = cs.[cst_dnc_date]
,       ct.[cst_sessionid] = cs.[cst_sessionid]
,       ct.[cst_affiliateid] = cs.[cst_affiliateid]
,       ct.[alt_center] = cs.[alt_center]
,       ct.[cst_loginid] = cs.[cst_loginid]
,       ct.[cst_do_not_email] = ISNULL(cs.[cst_do_not_email], 'N')
,       ct.[cst_do_not_mail] = ISNULL(cs.[cst_do_not_mail], 'N')
,       ct.[cst_do_not_text] = ISNULL(cs.[cst_do_not_text], 'N')
,       ct.[surgery_consultation_flag] = cs.[surgery_consultation_flag]
,       ct.[cst_age] = cs.[cst_age]
,       ct.[cst_hair_loss_spot_code] = cs.[cst_hair_loss_spot_code]
,       ct.[cst_hair_loss_experience_code] = cs.[cst_hair_loss_experience_code]
,       ct.[cst_hair_loss_product] = cs.[cst_hair_loss_product]
,       ct.[cst_hair_loss_in_family_code] = cs.[cst_hair_loss_in_family_code]
,       ct.[cst_hair_loss_family_code] = cs.[cst_hair_loss_family_code]
FROM    [oncd_contact] ct
        INNER JOIN [SQL03].HCM.dbo.oncd_contact cs
            ON ct.contact_id = cs.contact_id
WHERE   cs.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- oncd_activity_contact
--
INSERT  INTO [dbo].[oncd_activity_contact]
        ( [activity_contact_id]
        ,[activity_id]
        ,[contact_id]
        ,[assignment_date]
        ,[attendance]
        ,[sort_order]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[primary_flag] )
        SELECT  [activity_contact_id]
        ,       ao.[activity_id]
        ,       [contact_id]
        ,       [assignment_date]
        ,       [attendance]
        ,       [sort_order]
        ,       ao.[creation_date]
        ,       ao.[created_by_user_code]
        ,       ao.[updated_date]
        ,       ao.[updated_by_user_code]
        ,       [primary_flag]
        FROM    #ACTREFRESH a
                INNER JOIN [SQL03].HCM.dbo.[oncd_activity_contact] ao
                    ON a.activity_id = ao.activity_id
        WHERE   ao.[activity_contact_id] NOT IN ( SELECT    activity_contact_id
                                                  FROM      oncd_activity_contact )


UPDATE  act
SET     act.[activity_id] = acs.[activity_id]
,       act.[contact_id] = acs.[contact_id]
,       act.[assignment_date] = acs.[assignment_date]
,       act.[attendance] = acs.[attendance]
,       act.[sort_order] = acs.[sort_order]
,       act.[creation_date] = acs.[creation_date]
,       act.[created_by_user_code] = acs.[created_by_user_code]
,       act.[updated_date] = acs.[updated_date]
,       act.[updated_by_user_code] = acs.[updated_by_user_code]
,       act.[primary_flag] = acs.[primary_flag]
FROM    oncd_activity_contact act
        INNER JOIN [SQL03].HCM.dbo.[oncd_activity_contact] acs
            ON act.activity_contact_id = acs.activity_contact_id
WHERE   acs.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- oncd_activity_user
--

INSERT  INTO [dbo].[oncd_activity_user]
        ( [activity_user_id]
        ,[activity_id]
        ,[user_code]
        ,[assignment_date]
        ,[attendance]
        ,[sort_order]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[primary_flag] )
        SELECT  [activity_user_id]
        ,       au.[activity_id]
        ,       [user_code]
        ,       [assignment_date]
        ,       [attendance]
        ,       [sort_order]
        ,       au.[creation_date]
        ,       au.[created_by_user_code]
        ,       au.[updated_date]
        ,       au.[updated_by_user_code]
        ,       [primary_flag]
        FROM    #ACTREFRESH a
                INNER JOIN [SQL03].HCM.dbo.[oncd_activity_user] au
                    ON a.activity_id = au.activity_id
        WHERE   activity_user_id NOT IN ( SELECT    activity_user_id
                                          FROM      oncd_activity_user )


UPDATE  aut
SET     aut.[activity_id] = aus.[activity_id]
,       aut.[user_code] = aus.[user_code]
,       aut.[assignment_date] = aus.[assignment_date]
,       aut.[attendance] = aus.[attendance]
,       aut.[sort_order] = aus.[sort_order]
,       aut.[creation_date] = aus.[creation_date]
,       aut.[created_by_user_code] = aus.[created_by_user_code]
,       aut.[updated_date] = aus.[updated_date]
,       aut.[updated_by_user_code] = aus.[updated_by_user_code]
,       aut.[primary_flag] = aus.[primary_flag]
FROM    oncd_activity_user aut
        INNER JOIN [SQL03].HCM.dbo.[oncd_activity_user] aus
            ON aut.activity_user_id = aus.activity_user_id
        INNER JOIN #ACTREFRESH a
            ON a.activity_id = aut.activity_id
WHERE   aus.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- cstd_contact_completion
--
INSERT  INTO [dbo].[cstd_contact_completion]
        ( [contact_completion_id]
        ,[company_id]
        ,[created_by_user_code]
        ,[updated_by_user_code]
        ,[contact_id]
        ,[sale_type_code]
        ,[sale_type_description]
        ,[show_no_show_flag]
        ,[sale_no_sale_flag]
        ,[contract_number]
        ,[contract_amount]
        ,[client_number]
        ,[initial_payment]
        ,[systems]
        ,[services]
        ,[number_of_graphs]
        ,[original_appointment_date]
        ,[date_saved]
        ,[status_line]
        ,[head_size]
        ,[base_price]
        ,[discount_amount]
        ,[discount_percentage]
        ,[balance_amount]
        ,[balance_percentage]
        ,[hair_length]
        ,[reschedule_flag]
        ,[date_rescheduled]
        ,[time_rescheduled]
        ,[discount_markup_flag]
        ,[comment]
        ,[followup_result_id]
        ,[followup_result]
        ,[surgery_offered_flag]
        ,[referred_to_doctor_flag]
        ,[creation_date]
        ,[updated_date]
        ,[activity_id]
        ,[length_price]
        ,[surgery_consultation_flag] )
        SELECT  [contact_completion_id]
        ,       [company_id]
        ,       cc.[created_by_user_code]
        ,       cc.[updated_by_user_code]
        ,       cc.[contact_id]
        ,       [sale_type_code]
        ,       [sale_type_description]
        ,       [show_no_show_flag]
        ,       [sale_no_sale_flag]
        ,       [contract_number]
        ,       [contract_amount]
        ,       [client_number]
        ,       [initial_payment]
        ,       [systems]
        ,       [services]
        ,       [number_of_graphs]
        ,       [original_appointment_date]
        ,       [date_saved]
        ,       [status_line]
        ,       [head_size]
        ,       [base_price]
        ,       [discount_amount]
        ,       [discount_percentage]
        ,       [balance_amount]
        ,       [balance_percentage]
        ,       [hair_length]
        ,       [reschedule_flag]
        ,       [date_rescheduled]
        ,       [time_rescheduled]
        ,       [discount_markup_flag]
        ,       [comment]
        ,       [followup_result_id]
        ,       [followup_result]
        ,       [surgery_offered_flag]
        ,       [referred_to_doctor_flag]
        ,       cc.[creation_date]
        ,       cc.[updated_date]
        ,       cc.[activity_id]
        ,       [length_price]
        ,       [surgery_consultation_flag]
        FROM    #ACTREFRESH a
                INNER JOIN [SQL03].HCM.dbo.[cstd_contact_completion] cc
                    ON a.activity_id = cc.activity_id
                INNER JOIN #CTREFRESH c
                    ON cc.contact_id = c.contact_id
        WHERE   a.[activity_id] NOT IN ( SELECT activity_id
                                         FROM   [cstd_contact_completion] )
                AND cc.[contact_completion_id] NOT IN ( SELECT  [contact_completion_id]
                                                        FROM    [cstd_contact_completion] )


UPDATE  cct
SET     cct.[company_id] = ccs.[company_id]
,       cct.[created_by_user_code] = ccs.[created_by_user_code]
,       cct.[updated_by_user_code] = ccs.[updated_by_user_code]
,       cct.[contact_id] = ccs.[contact_id]
,       cct.[sale_type_code] = ccs.[sale_type_code]
,       cct.[sale_type_description] = ccs.[sale_type_description]
,       cct.[show_no_show_flag] = ccs.[show_no_show_flag]
,       cct.[sale_no_sale_flag] = ccs.[sale_no_sale_flag]
,       cct.[contract_number] = ccs.[contract_number]
,       cct.[contract_amount] = ccs.[contract_amount]
,       cct.[client_number] = ccs.[client_number]
,       cct.[initial_payment] = ccs.[initial_payment]
,       cct.[systems] = ccs.[systems]
,       cct.[services] = ccs.[services]
,       cct.[number_of_graphs] = ccs.[number_of_graphs]
,       cct.[original_appointment_date] = ccs.[original_appointment_date]
,       cct.[date_saved] = ccs.[date_saved]
,       cct.[status_line] = ccs.[status_line]
,       cct.[head_size] = ccs.[head_size]
,       cct.[base_price] = ccs.[base_price]
,       cct.[discount_amount] = ccs.[discount_amount]
,       cct.[discount_percentage] = ccs.[discount_percentage]
,       cct.[balance_amount] = ccs.[balance_amount]
,       cct.[balance_percentage] = ccs.[balance_percentage]
,       cct.[hair_length] = ccs.[hair_length]
,       cct.[reschedule_flag] = ccs.[reschedule_flag]
,       cct.[date_rescheduled] = ccs.[date_rescheduled]
,       cct.[time_rescheduled] = ccs.[time_rescheduled]
,       cct.[discount_markup_flag] = ccs.[discount_markup_flag]
,       cct.[comment] = ccs.[comment]
,       cct.[followup_result_id] = ccs.[followup_result_id]
,       cct.[followup_result] = ccs.[followup_result]
,       cct.[surgery_offered_flag] = ccs.[surgery_offered_flag]
,       cct.[referred_to_doctor_flag] = ccs.[referred_to_doctor_flag]
,       cct.[creation_date] = ccs.[creation_date]
,       cct.[updated_date] = ccs.[updated_date]
,       cct.[activity_id] = ccs.[activity_id]
,       cct.[length_price] = ccs.[length_price]
,       cct.[surgery_consultation_flag] = ccs.[surgery_consultation_flag]
FROM    cstd_contact_completion cct
        INNER JOIN [SQL03].HCM.dbo.[cstd_contact_completion] ccs
            ON cct.[contact_completion_id] = ccs.[contact_completion_id]
WHERE   ccs.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- cstd_activity_demographic
--
INSERT  INTO [dbo].[cstd_activity_demographic]
        ( [activity_demographic_id]
        ,[activity_id]
        ,[gender]
        ,[birthday]
        ,[occupation_code]
        ,[ethnicity_code]
        ,[maritalstatus_code]
        ,[norwood]
        ,[ludwig]
        ,[age]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[performer]
        ,[price_quoted]
        ,[solution_offered]
        ,[no_sale_reason]
        ,[disc_style] )
        SELECT  [activity_demographic_id]
        ,       ad.[activity_id]
        ,       [gender]
        ,       [birthday]
        ,       [occupation_code]
        ,       [ethnicity_code]
        ,       [maritalstatus_code]
        ,       [norwood]
        ,       [ludwig]
        ,       [age]
        ,       ad.[creation_date]
        ,       ad.[created_by_user_code]
        ,       ad.[updated_date]
        ,       ad.[updated_by_user_code]
        ,       [performer]
        ,       [price_quoted]
        ,       [solution_offered]
        ,       [no_sale_reason]
        ,       [disc_style]
        FROM    #ACTREFRESH a
                INNER JOIN [SQL03].HCM.dbo.[cstd_activity_demographic] ad
                    ON ad.activity_id = a.activity_id
        WHERE   ad.[activity_demographic_id] NOT IN ( SELECT    activity_demographic_id
                                                      FROM      [cstd_activity_demographic] )


UPDATE  adt
SET     adt.[activity_id] = ads.[activity_id]
,       adt.[gender] = ads.[gender]
,       adt.[birthday] = ads.[birthday]
,       adt.[occupation_code] = ads.[occupation_code]
,       adt.[ethnicity_code] = ads.[ethnicity_code]
,       adt.[maritalstatus_code] = ads.[maritalstatus_code]
,       adt.[norwood] = ads.[norwood]
,       adt.[ludwig] = ads.[ludwig]
,       adt.[age] = ads.[age]
,       adt.[creation_date] = ads.[creation_date]
,       adt.[created_by_user_code] = ads.[created_by_user_code]
,       adt.[updated_date] = ads.[updated_date]
,       adt.[updated_by_user_code] = ads.[updated_by_user_code]
,       adt.[performer] = ads.[performer]
,       adt.[price_quoted] = ads.[price_quoted]
,       adt.[solution_offered] = ads.[solution_offered]
,       adt.[no_sale_reason] = ads.[no_sale_reason]
,       adt.[disc_style] = ads.[disc_style]
FROM    cstd_activity_demographic adt
        INNER JOIN [SQL03].HCM.dbo.[cstd_activity_demographic] ads
            ON adt.[activity_demographic_id] = ads.[activity_demographic_id]
WHERE   ads.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- oncd_contact_address
--
INSERT  INTO [dbo].[oncd_contact_address]
        ( [contact_address_id]
        ,[contact_id]
        ,[address_type_code]
        ,[address_line_1]
        ,[address_line_2]
        ,[address_line_3]
        ,[address_line_4]
        ,[address_line_1_soundex]
        ,[address_line_2_soundex]
        ,[city]
        ,[city_soundex]
        ,[state_code]
        ,[zip_code]
        ,[county_code]
        ,[country_code]
        ,[time_zone_code]
        ,[sort_order]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[primary_flag]
        ,[company_address_id] )
        SELECT  [contact_address_id]
        ,       ca.[contact_id]
        ,       [address_type_code]
        ,       [address_line_1]
        ,       [address_line_2]
        ,       [address_line_3]
        ,       [address_line_4]
        ,       [address_line_1_soundex]
        ,       [address_line_2_soundex]
        ,       [city]
        ,       [city_soundex]
        ,       [state_code]
        ,       [zip_code]
        ,       [county_code]
        ,       [country_code]
        ,       [time_zone_code]
        ,       [sort_order]
        ,       [creation_date]
        ,       [created_by_user_code]
        ,       [updated_date]
        ,       [updated_by_user_code]
        ,       [primary_flag]
        ,       [company_address_id]
        FROM    #CTREFRESH cd
                INNER JOIN [SQL03].HCM.dbo.[oncd_contact_address] ca
                    ON cd.contact_id = ca.contact_id
        WHERE   ca.contact_address_id NOT IN ( SELECT   contact_address_id
                                               FROM     oncd_contact_address )


UPDATE  cat
SET     cat.[contact_id] = cas.[contact_id]
,       cat.[address_type_code] = cas.[address_type_code]
,       cat.[address_line_1] = cas.[address_line_1]
,       cat.[address_line_2] = cas.[address_line_2]
,       cat.[address_line_3] = cas.[address_line_3]
,       cat.[address_line_4] = cas.[address_line_4]
,       cat.[address_line_1_soundex] = cas.[address_line_1_soundex]
,       cat.[address_line_2_soundex] = cas.[address_line_2_soundex]
,       cat.[city] = cas.[city]
,       cat.[city_soundex] = cas.[city_soundex]
,       cat.[state_code] = cas.[state_code]
,       cat.[zip_code] = cas.[zip_code]
,       cat.[county_code] = cas.[county_code]
,       cat.[country_code] = cas.[country_code]
,       cat.[time_zone_code] = cas.[time_zone_code]
,       cat.[sort_order] = cas.[sort_order]
,       cat.[creation_date] = cas.[creation_date]
,       cat.[created_by_user_code] = cas.[created_by_user_code]
,       cat.[updated_date] = cas.[updated_date]
,       cat.[updated_by_user_code] = cas.[updated_by_user_code]
,       cat.[primary_flag] = cas.[primary_flag]
,       cat.[company_address_id] = cas.[company_address_id]
FROM    oncd_contact_address cat
        INNER JOIN [SQL03].HCM.dbo.[oncd_contact_address] cas
            ON cat.contact_address_id = cas.contact_address_id
WHERE   cas.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- oncd_company
--
INSERT  INTO oncd_company
        (company_id
        ,company_name_1
        ,company_name_2
        ,company_name_1_search
        ,company_name_2_search
        ,company_name_1_soundex
        ,company_name_2_soundex
        ,annual_sales
        ,number_of_employees
        ,profile_code
        ,external_id
        ,company_type_code
        ,contact_method_code
        ,do_not_solicit
        ,company_status_code
        ,duplicate_check
        ,creation_date
        ,created_by_user_code
        ,updated_date
        ,updated_by_user_code
        ,status_updated_date
        ,status_updated_by_user_code
        ,parent_company_id
        ,cst_center_number
        ,cst_company_map_link
        ,cst_center_manager_name
        ,cst_director_name
        ,cst_dma )
        SELECT  c.company_id
        ,       c.company_name_1
        ,       c.company_name_2
        ,       c.company_name_1_search
        ,       c.company_name_2_search
        ,       c.company_name_1_soundex
        ,       c.company_name_2_soundex
        ,       c.annual_sales
        ,       c.number_of_employees
        ,       c.profile_code
        ,       c.external_id
        ,       c.company_type_code
        ,       c.contact_method_code
        ,       c.do_not_solicit
        ,       c.company_status_code
        ,       c.duplicate_check
        ,       c.creation_date
        ,       c.created_by_user_code
        ,       c.updated_date
        ,       c.updated_by_user_code
        ,       c.status_updated_date
        ,       c.status_updated_by_user_code
        ,       c.parent_company_id
        ,       c.cst_center_number
        ,       c.cst_company_map_link
        ,       c.cst_center_manager_name
        ,       c.cst_director_name
        ,       c.cst_dma
        FROM    [SQL03].HCM.dbo.[oncd_company] c
        WHERE   c.company_id NOT IN ( SELECT    company_id
                                      FROM      oncd_company )


UPDATE  c
SET     c.company_name_1 = oc.company_name_1
,       c.company_name_2 = oc.company_name_2
,       c.company_name_1_search = oc.company_name_1_search
,       c.company_name_2_search = oc.company_name_2_search
,       c.company_name_1_soundex = oc.company_name_1_soundex
,       c.company_name_2_soundex = oc.company_name_2_soundex
,       c.annual_sales = oc.annual_sales
,       c.number_of_employees = oc.number_of_employees
,       c.profile_code = oc.profile_code
,       c.external_id = oc.external_id
,       c.company_type_code = oc.company_type_code
,       c.contact_method_code = oc.contact_method_code
,       c.do_not_solicit = oc.do_not_solicit
,       c.company_status_code = oc.company_status_code
,       c.duplicate_check = oc.duplicate_check
,       c.creation_date = oc.creation_date
,       c.created_by_user_code = oc.created_by_user_code
,       c.updated_date = oc.updated_date
,       c.updated_by_user_code = oc.updated_by_user_code
,       c.status_updated_date = oc.status_updated_date
,       c.status_updated_by_user_code = oc.status_updated_by_user_code
,       c.parent_company_id = oc.parent_company_id
,       c.cst_center_number = oc.cst_center_number
,       c.cst_company_map_link = oc.cst_company_map_link
,       c.cst_center_manager_name = oc.cst_center_manager_name
,       c.cst_director_name = oc.cst_director_name
,       c.cst_dma = oc.cst_dma
FROM    oncd_company c
        INNER JOIN [SQL03].HCM.dbo.[oncd_company] oc
            ON oc.[company_id] = c.[company_id]


--
-- oncd_contact_company
--
INSERT  INTO [dbo].[oncd_contact_company]
        ( [contact_company_id]
        ,[contact_id]
        ,[company_id]
        ,[company_role_code]
        ,[description]
        ,[sort_order]
        ,[reports_to_contact_id]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[primary_flag]
        ,[title]
        ,[department_code]
        ,[internal_title_code]
        ,[cst_preferred_center_flag] )
        SELECT  [contact_company_id]
        ,       cc.[contact_id]
        ,       [company_id]
        ,       [company_role_code]
        ,       [description]
        ,       [sort_order]
        ,       [reports_to_contact_id]
        ,       [creation_date]
        ,       [created_by_user_code]
        ,       [updated_date]
        ,       [updated_by_user_code]
        ,       [primary_flag]
        ,       [title]
        ,       [department_code]
        ,       [internal_title_code]
        ,       [cst_preferred_center_flag]
        FROM    #CTREFRESH cd
                INNER JOIN [SQL03].HCM.dbo.[oncd_contact_company] cc
                    ON cd.contact_id = cc.contact_id
        WHERE   cc.contact_company_id NOT IN ( SELECT   contact_company_id
                                               FROM     oncd_contact_company )


UPDATE  cct
SET     cct.[company_id] = ccs.[company_id]
,       cct.[company_role_code] = ccs.[company_role_code]
,       cct.[description] = ccs.[description]
,       cct.[sort_order] = ccs.[sort_order]
,       cct.[reports_to_contact_id] = ccs.[reports_to_contact_id]
,       cct.[creation_date] = ccs.[creation_date]
,       cct.[created_by_user_code] = ccs.[created_by_user_code]
,       cct.[updated_date] = ccs.[updated_date]
,       cct.[updated_by_user_code] = ccs.[updated_by_user_code]
,       cct.[primary_flag] = ccs.[primary_flag]
,       cct.[title] = ccs.[title]
,       cct.[department_code] = ccs.[department_code]
,       cct.[internal_title_code] = ccs.[internal_title_code]
,       cct.[cst_preferred_center_flag] = ccs.[cst_preferred_center_flag]
FROM    oncd_contact_company cct
        INNER JOIN [SQL03].HCM.dbo.[oncd_contact_company] ccs
            ON cct.[contact_company_id] = ccs.[contact_company_id]
        INNER JOIN #CTREFRESH
            ON cct.contact_id = #CTREFRESH.contact_id
WHERE   ccs.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- oncd_contact_email
--
INSERT  INTO [dbo].[oncd_contact_email]
        ( [contact_email_id]
        ,[contact_id]
        ,[email_type_code]
        ,[email]
        ,[description]
        ,[active]
        ,[sort_order]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[primary_flag] )
        SELECT  [contact_email_id]
        ,       cd.[contact_id]
        ,       [email_type_code]
        ,       [email]
        ,       [description]
        ,       [active]
        ,       [sort_order]
        ,       [creation_date]
        ,       [created_by_user_code]
        ,       [updated_date]
        ,       [updated_by_user_code]
        ,       [primary_flag]
        FROM    #CTREFRESH cd
                INNER JOIN [SQL03].HCM.dbo.[oncd_contact_email] ce
                    ON cd.contact_id = ce.contact_id
        WHERE   ce.contact_email_id NOT IN ( SELECT contact_email_id
                                             FROM   oncd_contact_email )


UPDATE  cet
SET     cet.[contact_id] = ces.[contact_id]
,       cet.[email_type_code] = ces.[email_type_code]
,       cet.[email] = ces.[email]
,       cet.[description] = ces.[description]
,       cet.[active] = ces.[active]
,       cet.[sort_order] = ces.[sort_order]
,       cet.[creation_date] = ces.[creation_date]
,       cet.[created_by_user_code] = ces.[created_by_user_code]
,       cet.[updated_date] = ces.[updated_date]
,       cet.[updated_by_user_code] = ces.[updated_by_user_code]
,       cet.[primary_flag] = ces.[primary_flag]
FROM    oncd_contact_email cet
        INNER JOIN [SQL03].HCM.dbo.[oncd_contact_email] ces
            ON cet.contact_email_id = ces.contact_email_id
        INNER JOIN #CTREFRESH
            ON ces.contact_id = #CTREFRESH.contact_id
WHERE   ces.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- oncd_contact_phone
--
INSERT  INTO [dbo].[oncd_contact_phone]
        ( [contact_phone_id]
        ,[contact_id]
        ,[phone_type_code]
        ,[country_code_prefix]
        ,[area_code]
        ,[phone_number]
        ,[extension]
        ,[description]
        ,[active]
        ,[sort_order]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[primary_flag] )
        SELECT  [contact_phone_id]
        ,       cd.[contact_id]
        ,       [phone_type_code]
        ,       [country_code_prefix]
        ,       [area_code]
        ,       [phone_number]
        ,       [extension]
        ,       [description]
        ,       [active]
        ,       [sort_order]
        ,       [creation_date]
        ,       [created_by_user_code]
        ,       [updated_date]
        ,       [updated_by_user_code]
        ,       [primary_flag]
        FROM    #CTREFRESH cd
                INNER JOIN [SQL03].HCM.dbo.[oncd_contact_phone] cp
                    ON cd.contact_id = cp.contact_id
        WHERE   contact_phone_id NOT IN ( SELECT    contact_phone_id
                                          FROM      oncd_contact_phone )


UPDATE  cpt
SET     cpt.[contact_id] = cps.[contact_id]
,       cpt.[phone_type_code] = cps.[phone_type_code]
,       cpt.[country_code_prefix] = cps.[country_code_prefix]
,       cpt.[area_code] = cps.[area_code]
,       cpt.[phone_number] = cps.[phone_number]
,       cpt.[extension] = cps.[extension]
,       cpt.[description] = cps.[description]
,       cpt.[active] = cps.[active]
,       cpt.[sort_order] = cps.[sort_order]
,       cpt.[creation_date] = cps.[creation_date]
,       cpt.[created_by_user_code] = cps.[created_by_user_code]
,       cpt.[updated_date] = cps.[updated_date]
,       cpt.[updated_by_user_code] = cps.[updated_by_user_code]
,       cpt.[primary_flag] = cps.[primary_flag]
FROM    oncd_contact_phone cpt
        INNER JOIN [SQL03].HCM.dbo.[oncd_contact_phone] cps
            ON cpt.contact_phone_id = cps.contact_phone_id
        INNER JOIN #CTREFRESH
            ON cpt.contact_id = #CTREFRESH.contact_id
WHERE   cps.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- oncd_contact_source
--
INSERT  INTO [dbo].[oncd_contact_source]
        ( [contact_source_id]
        ,[contact_id]
        ,[source_code]
        ,[media_code]
        ,[sort_order]
        ,[assignment_date]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code]
        ,[primary_flag]
        ,[cst_dnis_number]
        ,[cst_sub_source_code] )
        SELECT  [contact_source_id]
        ,       cs.[contact_id]
        ,       [source_code]
        ,       [media_code]
        ,       [sort_order]
        ,       [assignment_date]
        ,       [creation_date]
        ,       [created_by_user_code]
        ,       [updated_date]
        ,       [updated_by_user_code]
        ,       [primary_flag]
        ,       [cst_dnis_number]
        ,       [cst_sub_source_code]
        FROM    #CTREFRESH cd
                INNER JOIN [SQL03].HCM.dbo.[oncd_contact_source] cs
                    ON cd.contact_id = cs.contact_id
        WHERE   contact_source_id NOT IN ( SELECT   contact_source_id
                                           FROM     oncd_contact_source )


UPDATE  cst
SET     cst.[contact_id] = css.[contact_id]
,       cst.[source_code] = css.[source_code]
,       cst.[media_code] = css.[media_code]
,       cst.[sort_order] = css.[sort_order]
,       cst.[assignment_date] = css.[assignment_date]
,       cst.[creation_date] = css.[creation_date]
,       cst.[created_by_user_code] = css.[created_by_user_code]
,       cst.[updated_date] = css.[updated_date]
,       cst.[updated_by_user_code] = css.[updated_by_user_code]
,       cst.[primary_flag] = css.[primary_flag]
,       cst.[cst_dnis_number] = css.[cst_dnis_number]
,       cst.[cst_sub_source_code] = css.[cst_sub_source_code]
FROM    oncd_contact_source cst
        INNER JOIN [SQL03].HCM.dbo.[oncd_contact_source] css
            ON cst.contact_source_id = css.contact_source_id
        INNER JOIN #CTREFRESH
            ON css.contact_id = #CTREFRESH.contact_id
WHERE   css.updated_date >= DATEADD(dd, -1, GETDATE())


--
-- oncd_contact_user
--
INSERT  INTO [dbo].[oncd_contact_user]
        ( [contact_user_id]
        ,[contact_id]
        ,[user_code]
        ,[job_function_code]
        ,[primary_flag]
        ,[sort_order]
        ,[assignment_date]
        ,[creation_date]
        ,[created_by_user_code]
        ,[updated_date]
        ,[updated_by_user_code] )
        SELECT  [contact_user_id]
        ,       cu.[contact_id]
        ,       [user_code]
        ,       [job_function_code]
        ,       [primary_flag]
        ,       [sort_order]
        ,       [assignment_date]
        ,       [creation_date]
        ,       [created_by_user_code]
        ,       [updated_date]
        ,       [updated_by_user_code]
        FROM    #CTREFRESH cd
                INNER JOIN [SQL03].HCM.dbo.[oncd_contact_user] cu
                    ON cd.contact_id = cu.contact_id
        WHERE   contact_user_id NOT IN ( SELECT contact_user_id
                                         FROM   oncd_contact_user )


UPDATE  cut
SET     cut.[contact_id] = cus.[contact_id]
,       cut.[user_code] = cus.[user_code]
,       cut.[job_function_code] = cus.[job_function_code]
,       cut.[primary_flag] = cus.[primary_flag]
,       cut.[sort_order] = cus.[sort_order]
,       cut.[assignment_date] = cus.[assignment_date]
,       cut.[creation_date] = cus.[creation_date]
,       cut.[created_by_user_code] = cus.[created_by_user_code]
,       cut.[updated_date] = cus.[updated_date]
,       cut.[updated_by_user_code] = cus.[updated_by_user_code]
FROM    oncd_contact_user cut
        INNER JOIN [SQL03].HCM.dbo.[oncd_contact_user] cus
            ON cut.contact_user_id = cus.contact_user_id
        INNER JOIN #CTREFRESH
            ON cut.contact_id = #CTREFRESH.contact_id
WHERE   cus.updated_date >= DATEADD(dd, -1, GETDATE())

END
GO
