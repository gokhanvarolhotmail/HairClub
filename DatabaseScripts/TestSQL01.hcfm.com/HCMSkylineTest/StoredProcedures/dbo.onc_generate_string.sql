/* CreateDate: 11/29/2012 15:31:56.620 , ModifyDate: 11/29/2012 15:31:56.620 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create PROC [dbo].[onc_generate_string]
( @string_length  int,
  @seed                 int,
  @return_string  varchar(255) output)
AS

BEGIN
SET NOCOUNT ON

DECLARE @counter int
DECLARE @seconds int
DECLARE @minutes int
DECLARE @hours int
DECLARE @micro_sec int
DECLARE @number int
DECLARE @temp_number int
DECLARE @index int

DECLARE @return varchar(255)
DECLARE @char_string varchar(255)


select @hours = DATEPART( hh, GETDATE())
select @minutes = DATEPART( mm, GETDATE())
select @seconds = DATEPART(ss, GETDATE())
select @micro_sec = DATEPART(ms, GETDATE())

SELECT @return = ''
SELECT @counter = 1
select @char_string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
select @number = (@seed * 47 ) +
                (@micro_sec * 23) +
                (@seconds * 100 * 19) +
                (@minutes * 60 * 100 * 13) +
                (@hours  * 60 * 60 * 100 * 7 )

WHILE  @counter <=  @string_length
BEGIN
      select @index = @number % 36
      select @index = @index + 1
      select @return = @return + substring(@char_string, @index, 1);
      select @number = ((@number / 37) * 17)

      if @number < 36
      begin
            select @seconds = DATEPART(ss, GETDATE())
            select @micro_sec = DATEPART(ms, GETDATE())

            select @number = (@seed * 47 ) +
                            (@micro_sec * 23) +
                            (@seconds * 100 * 19) +
                            (@minutes * 60 * 100 * 13) +
                            (@hours  * 60 * 60 * 100 * 7 )

      end
      select @counter = @counter + 1
END

select @return_string = @return
END
GO
