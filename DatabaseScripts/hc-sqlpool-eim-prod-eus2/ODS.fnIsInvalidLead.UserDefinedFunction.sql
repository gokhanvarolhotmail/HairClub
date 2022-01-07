/****** Object:  UserDefinedFunction [ODS].[fnIsInvalidLead]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [ODS].[fnIsInvalidLead] (@SFDC_LeadID [NVARCHAR](30)) RETURNS TABLE
AS
RETURN (
        SELECT DISTINCT
                l.Id
        ,       1 AS 'IsInvalidLead'
        FROM    ODS.SFDC_Lead l
        WHERE   l.Id = @SFDC_LeadID
                AND ((
                        (
                            l.FirstName LIKE 'aaa%'
                            OR l.FirstName LIKE 'bbb%'
                            OR l.FirstName LIKE 'ccc%'
                            OR l.FirstName LIKE 'ddd%'
                            OR l.FirstName LIKE 'eee%'
                            OR l.FirstName LIKE 'fff%'
                            OR l.FirstName LIKE 'ggg%'
                            OR l.FirstName LIKE 'hhh%'
                            OR l.FirstName LIKE 'iii%'
                            OR l.FirstName LIKE 'jjj%'
                            OR l.FirstName LIKE 'kkk%'
                            OR l.FirstName LIKE 'llll%'
                            OR l.FirstName LIKE 'mmm%'
                            OR l.FirstName LIKE 'nnn%'
                            OR l.FirstName LIKE 'ooo%'
                            OR l.FirstName LIKE 'ppp%'
                            OR l.FirstName LIKE 'qqq%'
                            OR l.FirstName LIKE 'rrr%'
                            OR l.FirstName LIKE 'sss%'
                            OR l.FirstName LIKE 'ttt%'
                            OR l.FirstName LIKE 'uuu%'
                            OR l.FirstName LIKE 'vvv%'
                            OR l.FirstName LIKE 'www%'
                            OR l.FirstName LIKE 'xxx%'
                            OR l.FirstName LIKE 'yyy%'
                            OR l.FirstName LIKE 'zzz%'
                            OR l.FirstName LIKE '%[%$!#@*]%'
                            OR l.FirstName LIKE '[0-9]%'
                            OR l.FirstName LIKE 'test%[0-9]'
                            OR l.FirstName LIKE 'test'
                            OR l.FirstName LIKE '123%'
                            OR l.FirstName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )
                            OR l.FirstName IS NULL
                        )
                        OR (
                            l.LastName LIKE 'aaa%'
                            OR  l.LastName LIKE 'bbb%'
                            OR  l.LastName LIKE 'ccc%'
                            OR  l.LastName LIKE 'ddd%'
                            OR  l.LastName LIKE 'eee%'
                            OR  l.LastName LIKE 'fff%'
                            OR  l.LastName LIKE 'ggg%'
                            OR  l.LastName LIKE 'hhh%'
                            OR  l.LastName LIKE 'iii%'
                            OR  l.LastName LIKE 'jjj%'
                            OR  l.LastName LIKE 'kkk%'
                            OR  l.LastName LIKE 'llll%'
                            OR  l.LastName LIKE 'mmm%'
                            OR  l.LastName LIKE 'nnn%'
                            OR  l.LastName LIKE 'ooo%'
                            OR  l.LastName LIKE 'ppp%'
                            OR  l.LastName LIKE 'qqq%'
                            OR  l.LastName LIKE 'rrr%'
                            OR  l.LastName LIKE 'sss%'
                            OR  l.LastName LIKE 'ttt%'
                            OR  l.LastName LIKE 'uuu%'
                            OR  l.LastName LIKE 'vvv%'
                            OR  l.LastName LIKE 'www%'
                            OR  l.LastName LIKE 'xxx%'
                            OR  l.LastName LIKE 'yyy%'
                            OR  l.LastName LIKE 'zzz%'
                            OR  l.LastName LIKE '%[&%$!#@*]%'
                            OR  l.LastName LIKE '[0-9]%'
                            OR  l.LastName LIKE 'test%[0-9]'
                            OR  l.LastName LIKE 'test'
                            OR  l.LastName LIKE '%test'
                            OR  l.LastName LIKE '123%'
                            OR  l.LastName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )
                            OR  l.LastName IS NULL
                        )
                        OR ((l.FirstName = 'fat' AND l.LastName = 'ass')
                            OR (l.FirstName = 'mickey' AND l.LastName = 'mouse')
                            OR (l.FirstName = 'minnie' AND l.LastName = 'mouse')
                            OR (l.FirstName = 'donald' AND l.LastName = 'duck')
                            OR (l.FirstName = 'daisy' AND l.LastName = 'duck')
                            OR (l.FirstName = 'fuck' AND l.LastName = 'off')
                            OR (l.FirstName = 'do not' AND l.LastName = 'use')
                        )
                    )
                OR (
                    (
                        l.Name NOT LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%'
                        OR  l.Name LIKE '%@hcfm.com'
                        OR  l.Name LIKE '%hairclub.com'
                        OR  l.Name LIKE '%@test.com'
                        OR  l.Name LIKE '%aaaa%'
                        OR  l.Name LIKE '%bbbb%'
                        OR  l.Name LIKE '%cccc%'
                        OR  l.Name LIKE '%dddd%'
                        OR  l.Name LIKE '%eeee%'
                        OR  l.Name LIKE '%ffff%'
                        OR  l.Name LIKE '%gggg%'
                        OR  l.Name LIKE '%hhhh%'
                        OR  l.Name LIKE '%iiii%'
                        OR  l.Name LIKE '%jjjj%'
                        OR  l.Name LIKE '%kkkk%'
                        OR  l.Name LIKE '%llll%'
                        OR  l.Name LIKE '%mmmm%'
                        OR  l.Name LIKE '%nnnn%'
                        OR  l.Name LIKE '%oooo%'
                        OR  l.Name LIKE '%pppp%'
                        OR  l.Name LIKE '%rrrr%'
                        OR  l.Name LIKE '%ssss%'
                        OR  l.Name LIKE '%tttt%'
                        OR  l.Name LIKE '%uuuu%'
                        OR  l.Name LIKE '%vvvv%'
                        OR  l.Name LIKE '%wwww%'
                        OR  l.Name LIKE '%xxxx%'
                        OR  l.Name LIKE '%yyyy%'
                        OR  l.Name LIKE '%zzzz%'
                        OR  l.Name LIKE '%EMAIL.COM'
                        OR  l.Name LIKE 'TEST123@%'
                        OR  l.Name LIKE 'TEST@%'
                        OR  l.Name LIKE 'TEST#@%'
                        OR  l.Name LIKE 'TESTPERSON@%'
                        OR  l.Name LIKE 'TESTWEB@%'
                        OR  l.Name LIKE 'TESTWEB#@%'
                        OR  l.Name IS NULL
                    )
                    AND (
                            LEN(l.PhoneAbr__c) NOT BETWEEN 10 AND 15
                            OR  l.PhoneAbr__c LIKE '0000%'
                            OR  l.PhoneAbr__c LIKE '1111%'
                            OR  l.PhoneAbr__c LIKE '2222%'
                            OR  l.PhoneAbr__c LIKE '333%'
                            OR  l.PhoneAbr__c LIKE '4444%'
                            OR  l.PhoneAbr__c LIKE '5555%'
                            OR  l.PhoneAbr__c LIKE '666%'
                            OR  l.PhoneAbr__c LIKE '7777777%'
                            OR  l.PhoneAbr__c LIKE '8888888%'
                            OR  l.PhoneAbr__c LIKE '9999%'
                            OR  l.PhoneAbr__c LIKE '123%'
                            OR  ISNUMERIC(l.PhoneAbr__c) = 0
                            OR  l.PhoneAbr__c IS NULL
                        )
                ))
)
GO
