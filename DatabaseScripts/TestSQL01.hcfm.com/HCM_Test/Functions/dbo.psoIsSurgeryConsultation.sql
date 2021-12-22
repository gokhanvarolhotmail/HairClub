/* CreateDate: 01/03/2013 10:22:39.203 , ModifyDate: 01/03/2013 10:22:39.203 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[psoIsSurgeryConsultation]
(
	@ContactId NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN
	DECLARE @SurgeryConsultation NCHAR(1)

	SELECT TOP 1
	@SurgeryConsultation = surgery_consultation_flag
	FROM oncd_contact
	WHERE contact_id = @ContactId

	RETURN @SurgeryConsultation
END
GO
