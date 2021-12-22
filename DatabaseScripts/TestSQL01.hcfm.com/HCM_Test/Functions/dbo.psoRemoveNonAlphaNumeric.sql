/* CreateDate: 09/17/2014 10:08:46.887 , ModifyDate: 09/17/2014 10:08:46.887 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[psoRemoveNonAlphaNumeric]
(
	-- Add the parameters for the function here
	@Value	NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @KeepValues AS NVARCHAR(50)
    Set @KeepValues = '%[^a-z0-9 ]%'
    While PatIndex(@KeepValues, @Value) > 0
        Set @Value = Stuff(@Value, PatIndex(@KeepValues, @Value), 1, '')

    Return @Value
END
GO
