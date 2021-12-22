/* CreateDate: 01/03/2013 10:22:39.200 , ModifyDate: 03/13/2013 12:20:45.233 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 24 September 2012
-- Description:	Removes Unicode from provided value.
-- =============================================
CREATE FUNCTION [dbo].[RemoveUnicode]
(
	@Input NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Output NVARCHAR(MAX)

	SET @Output = dbo.RegexReplace(@Input, '[^\u0000-\u007F]','')

	IF (RTRIM(@Output) = '' AND RTRIM(@Input) <> '')
	BEGIN
		SET @Output = 'UNICODE'
	END

	RETURN @Output
END
GO
