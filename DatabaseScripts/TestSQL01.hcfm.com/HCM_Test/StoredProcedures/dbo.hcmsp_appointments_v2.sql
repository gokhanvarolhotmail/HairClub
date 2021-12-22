/* CreateDate: 06/06/2007 11:17:41.317 , ModifyDate: 05/01/2010 14:48:12.120 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[hcmsp_appointments_v2](@center as varchar(3), @begdt as datetime, @enddt as datetime) AS

DECLARE @terr_desc as varchar(50)

SELECT @terr_desc = company_name_1
FROM oncd_company
WHERE cst_center_number=@center



		SELECT 	a.contact_id,
				first_name,
				last_name,
				a.creation_date,
				--create_time,
				a.created_by_user_code,
				address_line_1,
				address_line_2,
				city,
				state_code,
				zip_code,
				adi_flag,
				email,
				territory,
				alt_center,
				cst_promotion_code,
				sale_type_code,
				sale_type_description,
				status_line,
				date_saved,phone_number,
				comment,
				date_rescheduled,
				original_appointment_date,
				source_code,
				CASE WHEN a.alt_center >0 OR a.alt_center IS NOT NULL THEN a.alt_center ELSE a.territory END master
		FROM lead_info a
		LEFT OUTER JOIN cstd_contact_completion b
		ON a.contact_id=b.contact_id
		LEFT OUTER JOIN oncd_contact_source c
		ON a.contact_id=c.contact_id
		WHERE
			(b.date_saved BETWEEN @BegDt AND @EndDt
			OR b.date_rescheduled BETWEEN @BegDt AND @EndDt)
			AND
			(a.territory=@center OR a.alt_center =@center)
			AND (b.sale_no_sale_flag='N' or b.sale_no_sale_flag is null)

		ORDER BY 	date_rescheduled,
				last_name,
				first_name,
				sale_type_code desc
GO
