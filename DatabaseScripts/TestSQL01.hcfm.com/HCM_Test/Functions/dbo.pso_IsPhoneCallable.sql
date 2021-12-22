/* CreateDate: 03/22/2016 11:02:44.610 , ModifyDate: 03/22/2016 11:02:44.610 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW - Workwise, LLC
-- Create date: 2016-01-25
-- Description:	Determine if phone number is callable based on DNC information
-- =============================================
CREATE FUNCTION [dbo].[pso_IsPhoneCallable]
(
	@phonenumber nvarchar(30),
	@contact_id nchar(10)
)
RETURNS nchar(1)
AS
BEGIN
	DECLARE @return nchar(1)
	SELECT @return = CASE	WHEN dnc_flag = 'Y' THEN 'N'
							WHEN ebr_dnc_flag = 'Y' AND cp.phone_type_code = 'SKIP' THEN 'N'
							WHEN ebr_dnc_flag = 'Y' AND dbo.pso_EBRDateforContact(@contact_id) < DATEADD(d,-90,GETDATE()) THEN 'N'
							ELSE 'Y'
						END
		FROM cstd_phone_dnc_wireless dw
		LEFT OUTER JOIN oncd_contact_phone cp WITH (NOLOCK)
			ON cp.contact_id = @contact_id AND cp.cst_full_phone_number = dw.phonenumber AND cp.phone_type_code = 'SKIP'
		WHERE dw.phonenumber = @phonenumber

	RETURN @return
END
GO
