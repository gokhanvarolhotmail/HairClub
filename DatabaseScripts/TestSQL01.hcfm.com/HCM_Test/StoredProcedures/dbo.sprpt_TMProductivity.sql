/* CreateDate: 10/17/2007 08:55:07.730 , ModifyDate: 05/01/2010 14:48:09.960 */
GO
/***********************************************************************

PROCEDURE:		sprpt_ShowRate_By_Confirmation

VERSION:		v2.0

DESTINATION SERVER:	HCSQL3

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	Email Confirmation Report

AUTHOR: 		Edgar O. Melendez 6/24/2000

IMPLEMENTOR: 		Howard Abelow ONCV

DATE IMPLEMENTED: 	10/12/2007

LAST REVISION DATE: 	10/12/2007

------------------------------------------------------------------------
NOTES:
			KM - 052207 - Added in an other condition to Inbound Lead - "result_code not like 'Q%'"
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC sprpt_TMProductivity '10/16/07', '10/18/07'

***********************************************************************/


CREATE PROCEDURE [dbo].[sprpt_TMProductivity]
    (
      @BegDt datetime,
      @EndDt datetime
    )
AS


--APPOINTMENT INFORMATION
--=============================================================================================
    SELECT  'Telemarketer' = MAX(telemarketer),
            'Inbound_Lead' = SUM(inbound_lead),
            'Inbound_Appt' = SUM(inbound_appt),
            'Inbound_Man_Hrs' = 0,
            'Outbound_Lead' = SUM(outbound_lead),
            'Outbound_Appt' = SUM(outbound_appt),
            'Outbound_Man_Hrs' = 0
    INTO    #appointments
    FROM    ( SELECT    'Telemarketer' = CASE WHEN action_code In ( 'APPOINT' )
                                                   AND cst_activity_type_code = 'INBOUND'
                                              THEN a.created_by_user_code
                                              ELSE CASE WHEN action_code In (
                                                             'APPOINT' )
                                                             AND cst_activity_type_code = 'OUTBOUND'
                                                        THEN ( SELECT   user_code
                                                               FROM     oncd_activity_user
                                                               WHERE    activity_id = a.activity_id
                                                                        AND primary_flag = 'Y'
                                                             )
                                                   END
                                         END,
                        'Inbound_Lead' = CASE WHEN action_code = 'INCALL'
                                                   AND cst_activity_type_code = 'INBOUND'
                                                   AND result_code not in (
                                                   'PRANK', 'WRNGNUM',
                                                   'CLIENT', 'RECOVERY' )
                                                   AND a.creation_date BETWEEN @begdt AND @enddt
                                                   + 1
                                                   AND ( c.first_name IS NOT NULL
                                                         OR c.last_name IS NOT NULL
                                                       ) THEN 1
                                              ELSE 0
                                         END,
                        'Inbound_Appt' = CASE WHEN action_code = 'INCALL'
                                                   AND cst_activity_type_code = 'INBOUND'
                                                   AND a.creation_date BETWEEN @begdt AND @enddt
                                                   + 1
                                                   AND result_code IN (
                                                   'APPOINT' ) THEN 1
                                              ELSE 0
                                         END,
                        'Inbound_Man_Hrs' = 0,
                        'Outbound_Lead' = CASE WHEN action_code In ( 'OUTCALL', 'APPOINT' )
                                                    AND cst_activity_type_code = 'OUTBOUND'
                                                    AND completion_date BETWEEN @begdt AND @enddt
                                               THEN 1
                                               ELSE 0
                                          END,
                        'Outbound_Appt' = CASE WHEN action_code In ( 'OUTCALL', 'APPOINT' )
                                                    AND cst_activity_type_code = 'OUTBOUND'
                                                    AND completion_date BETWEEN @begdt AND @enddt
                                                    AND dbo.ISAPPT(action_code) = 1
                                               THEN 1
                                               ELSE 0
                                          END,
                        'Outbound_Man_Hrs' = 0,
                        CASE WHEN action_code In ( 'INCALL', 'APPOINT' )
                                  AND cst_activity_type_code = 'INBOUND'
                             THEN c.created_by_user_code
                             ELSE CASE WHEN action_code In ( 'OUTCALL',
                                                             'APPOINT' )
                                            AND cst_activity_type_code = 'OUTBOUND'
                                       THEN au.user_code
                                  END
                        END tuser_code
              FROM      oncd_activity a WITH ( NOLOCK )
                        INNER JOIN oncd_activity_contact ac ON ac.activity_id = a.activity_id
                                                               AND ac.primary_flag = 'Y'
                        INNER JOIN oncd_contact c WITH ( NOLOCK ) ON ac.contact_id = c.contact_id
                        INNER JOIN oncd_activity_user au ON au.activity_id = a.activity_id
                                                            AND au.primary_flag = 'Y'
              WHERE     au.user_code LIKE 'TM%'
                        AND CASE WHEN action_code IN ( 'INCALL', 'APPOINT' )
                                      AND cst_activity_type_code = 'INBOUND'
                                 THEN a.creation_date
                                 ELSE CASE WHEN action_code IN ( 'OUTCALL', 'APPOINT' )
                                                AND cst_activity_type_code = 'OUTBOUND'
                                           THEN completion_date
                                      END
                            END Between @begdt
                                And     @enddt
            ) temp
    GROUP BY tuser_code


--COMPLETION INFORMATION
--=============================================================================================

    SELECT  'Telemarketer' = user_code,
            'Inbound_Show_Appt' = SUM(CASE WHEN action_code IN ( 'APPOINT' )
                                                AND cst_activity_type_code = 'INBOUND'
                                                AND result_code IN (
                                                'SHOWSALE', 'SHOWNOSALE',
                                                'NOSHOW' ) THEN 1
                                           ELSE 0
                                      END),
            'Inbound_Shows' = SUM(CASE WHEN action_code IN ( 'APPOINT' )
                                            AND cst_activity_type_code = 'INBOUND'
                                            AND result_code IN ( 'SHOWSALE', 'SHOWNOSALE' )
                                       THEN 1
                                       ELSE 0
                                  END),
            'InBound_Sales' = SUM(CASE WHEN action_code IN ( 'APPOINT' )
                                            AND cst_activity_type_code = 'INBOUND'
                                            AND result_code IN ( 'SHOWSALE' )
                                       THEN 1
                                       ELSE 0
                                  END),
            'Outbound_Show_Appt' = SUM(CASE WHEN action_code IN ( 'APPOINT' )
                                                 AND cst_activity_type_code = 'OUTBOUND'
                                                 AND result_code IN (
                                                 'SHOWSALE', 'SHOWNOSALE',
                                                 'NOSHOW' ) THEN 1
                                            ELSE 0
                                       END),
            'Outbound_Shows' = SUM(CASE WHEN action_code IN ( 'APPOINT' )
                                             AND cst_activity_type_code = 'OUTBOUND'
                                             AND result_code IN ( 'SHOWSALE', 'SHOWNOSALE' )
                                        THEN 1
                                        ELSE 0
                                   END),
            'OutBound_Sales' = SUM(CASE WHEN action_code IN ( 'APPOINT' )
                                             AND cst_activity_type_code = 'OUTBOUND'
                                             AND result_code IN ( 'SHOWSALE' )
                                        THEN 1
                                        ELSE 0
                                   END)
    INTO    #completion
    FROM    oncd_activity a WITH ( NOLOCK )
            INNER JOIN oncd_activity_contact ac ON ac.activity_id = a.activity_id
                                                   AND ac.primary_flag = 'Y'
            INNER JOIN oncd_contact c WITH ( NOLOCK ) ON ac.contact_id = c.contact_id
            INNER JOIN oncd_activity_user au ON au.activity_id = a.activity_id
                                                AND au.primary_flag = 'Y'
    WHERE   due_date BETWEEN @begdt AND @enddt
            AND user_code LIKE 'TM%'
    GROUP BY user_code


--CALLS INFORMATION
--=============================================================================================

    SELECT  Telemarketer,
            'Total_Hits' = SUM([Total Hits]),
            'Total_Calls' = SUM([Total Calls]),
            'Dials' = SUM([Dials]),
            'Inbound_Hours' = SUM([Inbound Hours]),
            'Outbound_Hours' = SUM([Outbond Hours]),
            'Required_Hours' = SUM([Required Hours])
    INTO    #calls
    FROM    hcmtbl_tmproductivity WITH ( NOLOCK )
    WHERE   [Date] between @begdt and @enddt
    GROUP BY Telemarketer


--FINAL RESULT INFORMATION
--=============================================================================================

    SELECT  'Grp_Order' = 1,
            'TM_Title' = hcmvw_slspsn.title,
            'TM_Order' = CASE WHEN RIGHT(hcmvw_slspsn.telemarketer, 3) LIKE '%[a-z]%'
                              THEN 0
                              ELSE CONVERT (int, RIGHT(hcmvw_slspsn.telemarketer,
                                                       3))
                         END,
            'Telemarketer' = MAX(hcmvw_slspsn.telemarketer),
            'Name' = MAX(hcmvw_slspsn.description),
            'Total_Hits' = SUM(CASE WHEN [total_hits] IS NULL THEN 0
                                    ELSE [total_hits]
                               END),
            'Total_Calls' = SUM(CASE WHEN [total_calls] IS NULL THEN 0
                                     ELSE [total_calls]
                                END),
            'Inbound_Hours' = SUM(CASE WHEN [inbound_hours] IS NULL THEN 0
                                       ELSE [inbound_hours]
                                  END) / 60,
            'Outbound_Hours' = SUM(CASE WHEN [outbound_hours] IS NULL THEN 0
                                        ELSE [outbound_hours]
                                   END) / 60,
            'Required_Hours' = SUM(CASE WHEN [required_hours] IS NULL THEN 0
                                        ELSE [required_hours]
                                   END) / 60,
            'Inbound_Leads' = SUM(CASE WHEN [inbound_lead] IS NULL THEN 0
                                       ELSE [inbound_lead]
                                  END),
            'Inbound_Appts' = SUM(CASE WHEN [inbound_appt] IS NULL THEN 0
                                       ELSE [inbound_appt]
                                  END),
            'Inbound_Man_Hrs' = SUM(CASE WHEN [inbound_man_hrs] IS NULL THEN 0
                                         ELSE [inbound_man_hrs]
                                    END) / 60,
            'Dials' = SUM(CASE WHEN [dials] IS NULL THEN 0
                               ELSE [dials]
                          END),
            'Outbound_Leads' = Sum(CASE WHEN [Outbound_Lead] IS NULL THEN 0
                                        ELSE [Outbound_Lead]
                                   END),
            'Outbound_Appts' = Sum(CASE WHEN [Outbound_Appt] IS NULL THEN 0
                                        ELSE [Outbound_Appt]
                                   END),
            'Outbound_Man_Hrs' = Convert(numeric(38, 2), Sum(CASE WHEN [Outbound_Man_Hrs] IS NULL THEN 0
                                                                  ELSE [Outbound_Man_Hrs]
                                                             END) / 60),
            'Inbound_Show_Appts' = SUM(CASE WHEN [inbound_show_appt] IS NULL
                                            THEN 0
                                            ELSE [inbound_show_appt]
                                       END),
            'Inbound_Shows' = SUM(CASE WHEN [inbound_shows] IS NULL THEN 0
                                       ELSE [inbound_shows]
                                  END),
            'Inbound_Sales' = SUM(CASE WHEN [inbound_sales] IS NULL THEN 0
                                       ELSE [inbound_sales]
                                  END),
            'Outbound_Show_Appts' = SUM(CASE WHEN [outbound_show_appt] IS NULL
                                             THEN 0
                                             ELSE [outbound_show_appt]
                                        END),
            'Outbound_Shows' = SUM(CASE WHEN [outbound_shows] IS NULL THEN 0
                                        ELSE [outbound_shows]
                                   END),
            'Outbound_Sales' = SUM(CASE WHEN [outbound_sales] IS NULL THEN 0
                                        ELSE [outbound_sales]
                                   END)
    FROM    hcmvw_slspsn WITH ( NOLOCK )
            LEFT OUTER JOIN  #completion ON hcmvw_slspsn.Telemarketer = #completion.Telemarketer
            LEFT OUTER JOIN  #appointments ON hcmvw_slspsn.Telemarketer = #appointments.Telemarketer
            LEFT OUTER JOIN  #calls ON hcmvw_slspsn.Telemarketer = #calls.Telemarketer
    GROUP BY CASE WHEN RIGHT(hcmvw_slspsn.telemarketer, 3) LIKE '%[a-z]%'
                  THEN 0
                  ELSE CONVERT (int, RIGHT(hcmvw_slspsn.telemarketer, 3))
             END,
            title



/*
SELECT
'Grp Order' = [Order],
'TM Order' = SUM(CASE WHEN RIGHT(hcmvw_slspsn.telemarketer,3)  LIKE '%[a-z]%'  THEN  0  ELSE  CONVERT (int, RIGHT (hcmvw_slspsn.telemarketer,3) ) END)
--'Telemarketer' =
--	MAX(hcmvw_slspsn.telemarketer),
--'Name' =
--	MAX(hcmvw_slspsn.description)
FROM hcmvw_slspsn
Group by hcmvw_slspsn.[order]
*/
GO
