/* CreateDate: 09/04/2007 12:42:33.373 , ModifyDate: 05/01/2010 14:48:11.617 */
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[onc_upper_first_character](
@source_string varchar(4000) output
)
as
begin
Declare @current_position int
declare @original_string varchar(4000)
declare @last_was_space char(10)

SET @current_position =  1
SET @original_string = RTRIM(@source_string)
SET @last_was_space = 'true'
SET @source_string = ''

while @current_position <= len(@original_string)
begin
	if @last_was_space = 'true'
		SET @source_string = @source_string +
				     upper(substring(@original_string,@current_position,1))
	else
		SET @source_string = @source_string +
				     substring(@original_string,@current_position,1)

	if substring(@original_string,@current_position,1) = ' '
		SET @last_was_space = 'true'
	else
		SET @last_was_space = 'false'

	SET @current_position =  @current_position + 1
end

end
GO
