/* CreateDate: 06/29/2021 11:37:25.573 , ModifyDate: 06/29/2021 11:37:25.573 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View vw_systemUser
as

SELECT UserId,UserName,UserLogin FROM [Synapse_pool].[DimSystemUser]
union
SELECT Id,name,Username FROM SQL05.HC_BI_SFDC.dbo.[User]
GO
