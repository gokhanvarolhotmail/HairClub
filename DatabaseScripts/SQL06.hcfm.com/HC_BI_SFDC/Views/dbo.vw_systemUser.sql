/* CreateDate: 06/29/2021 11:37:25.573 , ModifyDate: 06/29/2021 11:37:25.573 */
GO
Create View vw_systemUser
as

SELECT UserId,UserName,UserLogin FROM [Synapse_pool].[DimSystemUser]
union
SELECT Id,name,Username FROM SQL05.HC_BI_SFDC.dbo.[User]
GO
