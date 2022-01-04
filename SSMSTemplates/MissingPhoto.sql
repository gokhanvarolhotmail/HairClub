-- THERE ARE 2 [ClientMembershipGUID] FOR THIS CLIENT '379928E2-A0C6-4139-9208-E4CE9BAE6E69' AND 'E5F86A27-33D5-4240-9E74-B0BBC9E3F1B0' , THE LATTER CONTAINS YEAR 2013
-- THE FIRST COLUMN BEFORE IS HOW MANY AppointmentPhoto's exists for the appointment if it's not null
-- NOTE IN THE BOTTOM DATASET ALL OF THEM ARE 0 AND IN THE FIRST DATASET LARGER THAN 0

SELECT ( SELECT COUNT(DISTINCT [a].[AppointmentPhoto])FROM [dbo].[datAppointmentPhoto] AS [a] WHERE [a].[AppointmentGUID] = [s].[AppointmentGUID] ) AS [Cnt]
     , [s].[AppointmentGUID]
     , *
FROM [dbo].[datSalesOrder] AS [s]
WHERE [s].[ClientMembershipGUID] = '379928E2-A0C6-4139-9208-E4CE9BAE6E69' ;

SELECT ( SELECT COUNT(DISTINCT [a].[AppointmentPhoto])FROM [dbo].[datAppointmentPhoto] AS [a] WHERE [a].[AppointmentGUID] = [s].[AppointmentGUID] ) AS [Cnt]
     , [s].[AppointmentGUID]
     , *
FROM [dbo].[datSalesOrder] AS [s]
WHERE [s].[ClientMembershipGUID] = 'E5F86A27-33D5-4240-9E74-B0BBC9E3F1B0' ;
