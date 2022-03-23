/* CreateDate: 03/21/2022 07:50:21.507 , ModifyDate: 03/21/2022 07:50:21.507 */
GO
Create View [dbo].[vw_systemUser]
as

SELECT UserId,UserName,UserLogin FROM [Synapse_pool].[DimSystemUser]
union
SELECT Id,name,Username FROM SQL05.HC_BI_SFDC.dbo.[User]
GO
