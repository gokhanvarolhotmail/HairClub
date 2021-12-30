/* CreateDate: 09/30/2020 08:54:56.563 , ModifyDate: 09/30/2020 11:07:07.557 */
GO
CREATE	FUNCTION [bi_mktg_stage].[fn_IsLead] (@FirstName NVARCHAR(50), @LastName NVARCHAR(50), @EmailAddress NVARCHAR(103), @PhoneNumber NVARCHAR(50))
RETURNS BIT
AS
BEGIN
	RETURN	(CASE WHEN (
						(
							@FirstName LIKE 'aaa%'
							OR @FirstName LIKE 'bbb%'
							OR @FirstName LIKE 'ccc%'
							OR @FirstName LIKE 'ddd%'
							OR @FirstName LIKE 'eee%'
							OR @FirstName LIKE 'fff%'
							OR @FirstName LIKE 'ggg%'
							OR @FirstName LIKE 'hhh%'
							OR @FirstName LIKE 'iii%'
							OR @FirstName LIKE 'jjj%'
							OR @FirstName LIKE 'kkk%'
							OR @FirstName LIKE 'llll%'
							OR @FirstName LIKE 'mmm%'
							OR @FirstName LIKE 'nnn%'
							OR @FirstName LIKE 'ooo%'
							OR @FirstName LIKE 'ppp%'
							OR @FirstName LIKE 'qqq%'
							OR @FirstName LIKE 'rrr%'
							OR @FirstName LIKE 'sss%'
							OR @FirstName LIKE 'ttt%'
							OR @FirstName LIKE 'uuu%'
							OR @FirstName LIKE 'vvv%'
							OR @FirstName LIKE 'www%'
							OR @FirstName LIKE 'xxx%'
							OR @FirstName LIKE 'yyy%'
							OR @FirstName LIKE 'zzz%'
							OR @FirstName LIKE '%[%$!#@*]%'
							OR @FirstName LIKE '[0-9]%'
							OR @FirstName LIKE 'test%[0-9]'
							OR @FirstName LIKE '123%'
							OR @FirstName IN ('FUCK','ASSHOLE','FUCKBOY','SHIT','BITCH','DICKHEAD','MOTHERFUCKER')
							OR @FirstName IS NULL
						)
						OR (
							@LastName LIKE 'aaa%'
							OR @LastName LIKE 'bbb%'
							OR @LastName LIKE 'ccc%'
							OR @LastName LIKE 'ddd%'
							OR @LastName LIKE 'eee%'
							OR @LastName LIKE 'fff%'
							OR @LastName LIKE 'ggg%'
							OR @LastName LIKE 'hhh%'
							OR @LastName LIKE 'iii%'
							OR @LastName LIKE 'jjj%'
							OR @LastName LIKE 'kkk%'
							OR @LastName LIKE 'llll%'
							OR @LastName LIKE 'mmm%'
							OR @LastName LIKE 'nnn%'
							OR @LastName LIKE 'ooo%'
							OR @LastName LIKE 'ppp%'
							OR @LastName LIKE 'qqq%'
							OR @LastName LIKE 'rrr%'
							OR @LastName LIKE 'sss%'
							OR @LastName LIKE 'ttt%'
							OR @LastName LIKE 'uuu%'
							OR @LastName LIKE 'vvv%'
							OR @LastName LIKE 'www%'
							OR @LastName LIKE 'xxx%'
							OR @LastName LIKE 'yyy%'
							OR @LastName LIKE 'zzz%'
							OR @LastName LIKE '%[&%$!#@*]%'
							OR @LastName LIKE '[0-9]%'
							OR @LastName LIKE 'test%[0-9]'
							OR @LastName LIKE '123%'
							OR @LastName IN ('FUCK','ASSHOLE','FUCKBOY','SHIT','BITCH','DICKHEAD','MOTHERFUCKER')
							OR LEN(@LastName) = 1
							OR @LastName IS NULL
						)
						OR (
								(@FirstName = 'fat' AND @LastName = 'ass')
							OR	(@FirstName = 'mickey' AND @LastName = 'mouse')
							OR	(@FirstName = 'minnie' AND @LastName = 'mouse')
							OR	(@FirstName = 'donald' AND @LastName = 'duck')
							OR	(@FirstName = 'daisy' AND @LastName = 'duck')
							OR	(@FirstName = 'fuck' AND @LastName = 'off')
							OR	(@FirstName = 'do not' AND @LastName = 'use')
						)
					)
					OR (
						(
							@EmailAddress NOT LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%'
							OR @EmailAddress LIKE '%@hcfm.com'
							OR @EmailAddress LIKE '%hairclub.com'
							OR @EmailAddress LIKE '%@test.com'
							OR @EmailAddress LIKE '%aaaa%'
							OR @EmailAddress LIKE '%bbbb%'
							OR @EmailAddress LIKE '%cccc%'
							OR @EmailAddress LIKE '%dddd%'
							OR @EmailAddress LIKE '%eeee%'
							OR @EmailAddress LIKE '%ffff%'
							OR @EmailAddress LIKE '%gggg%'
							OR @EmailAddress LIKE '%hhhh%'
							OR @EmailAddress LIKE '%iiii%'
							OR @EmailAddress LIKE '%jjjj%'
							OR @EmailAddress LIKE '%kkkk%'
							OR @EmailAddress LIKE '%llll%'
							OR @EmailAddress LIKE '%mmmm%'
							OR @EmailAddress LIKE '%nnnn%'
							OR @EmailAddress LIKE '%oooo%'
							OR @EmailAddress LIKE '%pppp%'
							OR @EmailAddress LIKE '%rrrr%'
							OR @EmailAddress LIKE '%ssss%'
							OR @EmailAddress LIKE '%tttt%'
							OR @EmailAddress LIKE '%uuuu%'
							OR @EmailAddress LIKE '%vvvv%'
							OR @EmailAddress LIKE '%wwww%'
							OR @EmailAddress LIKE '%xxxx%'
							OR @EmailAddress LIKE '%yyyy%'
							OR @EmailAddress LIKE '%zzzz%'
							OR @EmailAddress LIKE '%EMAIL.COM'
							OR @EmailAddress LIKE 'TEST123@%'
							OR @EmailAddress LIKE 'TEST@%'
							OR @EmailAddress LIKE 'TEST#@%'
							OR @EmailAddress LIKE 'TESTPERSON@%'
							OR @EmailAddress LIKE 'TESTWEB@%'
							OR @EmailAddress LIKE 'TESTWEB#@%'
							OR @EmailAddress IS NULL
						)
						AND (
								LEN(@PhoneNumber) NOT BETWEEN 10 AND 15
								OR @PhoneNumber LIKE '0000%'
								OR @PhoneNumber LIKE '1111%'
								OR @PhoneNumber LIKE '2222%'
								OR @PhoneNumber LIKE '333%'
								OR @PhoneNumber LIKE '4444%'
								OR @PhoneNumber LIKE '5555%'
								OR @PhoneNumber LIKE '666%'
								OR @PhoneNumber LIKE '7777777%'
								OR @PhoneNumber LIKE '8888888%'
								OR @PhoneNumber LIKE '9999%'
								OR @PhoneNumber LIKE '123%'
								OR ISNUMERIC(@PhoneNumber) = 0
								OR @PhoneNumber IS NULL
							)
					) THEN 0
				ELSE 1
			END
		)

END
GO
