SELECT TOP 10
       [s].[Appointment_Type__c]

     , [s].*
FROM [SF].[Task] AS [t]
LEFT JOIN [SF].[ServiceAppointment] AS [s] ON [t].[Service_Appointment__c] = [s].[Service_Appointment__c]
WHERE [s].[Appointment_Type__c] = 'Virtual'

