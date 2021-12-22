/* CreateDate: 11/04/2015 13:41:54.507 , ModifyDate: 11/04/2015 13:41:54.507 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 14 November 2011
-- Description:	Uses onca_nickname to normalize the contact first name.
-- =============================================
CREATE FUNCTION [dbo].[pso_Soundex_NormalizeFirstName]
(
	@o_fname NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX) WITH SCHEMABINDING
AS
BEGIN
	DECLARE @ls_name NVARCHAR(MAX)
	SET @o_fname = UPPER(RTRIM(@o_fname))

	SET @ls_name = (SELECT MAX(actual_name) FROM dbo.onca_nickname WHERE nickname = @o_fname)
	SET @ls_name = UPPER(RTRIM(ISNULL(@ls_name,'')))

	IF (@ls_name = '')
	BEGIN
		SET @ls_name = @o_fname
	END

	-- Return the result of the function
	RETURN @ls_name

END
GO
