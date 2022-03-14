--UPDATE [datHairSystemOrder] SET UpdatedDueDate = '01/29/2021' , LastUpdateUser = 'TFS#14765', LastUpdate = GETUTCDATE() WHERE HairSystemOrderNumber = 6512545

/*

Andre Ptak Internal
Yesterday 19:29
Issue:
Hair Orders placed during the date range of 3/1/21 to 2/9/22 have an inaccurate 'Due Date' value compared to the actual lead time for a hair order (approximately 8 months)
 
Request:
Update the 'Updated Due Date' field value on all Hair Orders placed 3/1/21 to 2/9/22
Update the 'UpdatedDueDate' field value in [HairClubCMS].[dbo].[datHairSystemOrder] to 240 days after the 'CreateDate' value
 
 */

SELECT TOP 1000
       [a].[UpdatedDueDate]
     , DATEADD(DAY, 240, [a].[CreateDate])
FROM [dbo].[datHairSystemOrder] AS [a]
--INNER JOIN [lkpHairSystemOrderStatus] b ON a.[HairSystemOrderStatusID] = b.[HairSystemOrderStatusID]
WHERE [a].[HairSystemOrderDate] >= '20210301' AND [a].[HairSystemOrderDate] <= '20220209' AND [a].[HairSystemOrderStatusID] = 8 ;
GO
RETURN ;

UPDATE [a]
SET
    [a].[UpdatedDueDate] = DATEADD(DAY, 240, [a].[CreateDate])
  , [a].[LastUpdateUser] = 'ZND#17164'
  , [a].[LastUpdate] = GETUTCDATE()
FROM [dbo].[datHairSystemOrder] AS [a]
WHERE [a].[HairSystemOrderDate] >= '20210301' AND [a].[HairSystemOrderDate] <= '20220209' AND [a].[HairSystemOrderStatusID] = 8 ;
GO

SELECT
    CAST([a].[UpdatedDueDate] AS DATE) AS [Dt]
  , COUNT(1) AS [cnt]
FROM [dbo].[datHairSystemOrder] AS [a]
--INNER JOIN [lkpHairSystemOrderStatus] b ON a.[HairSystemOrderStatusID] = b.[HairSystemOrderStatusID]
WHERE [a].[HairSystemOrderDate] >= '20210301' AND [a].[HairSystemOrderDate] <= '20220209' AND [a].[HairSystemOrderStatusID] = 8
GROUP BY CAST([a].[UpdatedDueDate] AS DATE)
ORDER BY COUNT(1) DESC ;

-- 155,587