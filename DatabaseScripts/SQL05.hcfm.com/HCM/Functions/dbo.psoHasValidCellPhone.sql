/* CreateDate: 09/30/2013 10:58:42.923 , ModifyDate: 09/30/2013 10:58:42.923 */
GO
create FUNCTION [dbo].[psoHasValidCellPhone]
(
	@ContactId	NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN
	RETURN ISNULL((	SELECT TOP 1 onca_phone_type.cst_is_cell_phone
					FROM oncd_contact_phone
					INNER JOIN onca_phone_type ON oncd_contact_phone.phone_type_code = onca_phone_type.phone_type_code
					WHERE
					oncd_contact_phone.contact_id = @ContactId AND
					oncd_contact_phone.cst_valid_flag = 'Y'
					ORDER BY onca_phone_type.cst_is_cell_phone DESC),'N')
END
GO
