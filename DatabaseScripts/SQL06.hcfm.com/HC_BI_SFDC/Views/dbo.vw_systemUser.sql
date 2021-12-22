Create View vw_systemUser
as

SELECT UserId,UserName,UserLogin FROM [Synapse_pool].[DimSystemUser]
union
SELECT Id,name,Username FROM SQL05.HC_BI_SFDC.dbo.[User]
