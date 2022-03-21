USE [HairClubCMSStaging_NoImg] ;
GO
DROP TABLE IF EXISTS [#temp] ;
GO
SELECT
    [vdata].[SKU]
  , [vdata].[Product Description]
  , [vdata].[Discontinued/Phase Out Product  or  Replacement SKU?]
INTO [#temp]
FROM( VALUES( '02-03-06-003', 'Maxxam Intensive Conditioning Unifier 6oz. ', 'Discontinued Product' )
          , ( '03-03-03-010', 'Maxxam Hair Sheen 3oz. ', 'Discontinued Product' )
          , ( '03-03-06-007', 'Maxxam ice 6oz', 'Discontinued Product' )
          , ( '03-03-06-008', 'Maxxam Kiss 6oz.', 'Discontinued Product' )
          , ( '04-03-03-001/', '90ml EXT Argan Oil 3oz. ', 'Discontinued Product' )
          , ( '04-03-27-004', 'EXT Strand Builder-Medium Brown 27gr.', 'Discontinued Product' )
          , ( '05-04-03-004/', 'Trax Clear Lace Solvent 3oz.', 'Discontinued SKU; Replacement SKU: 840223300347 Trax Clear Lace Solvent 3oz.' )
          , ( '01-02-10-004/', 'Maxxam Creme Rinse Detangler 10oz', 'Discontinued SKU; Has a replacement SKU 840223300156 Maxxam Creme Rinse Detangler 10oz' )
          , ( '01-02-10-003/', 'Maxxam Hair Reconstructor 10oz', 'Discontinued SKU; Replacement SKU: 840223300224 Maxxam Hair Reconstructor 10oz' )
          , ( '01-02-10-009/', 'Maxxam Alive 10oz', 'Discontinued SKU; Has a replacement SKU 840223300064 Maxxam Alive 10oz' )
          , ( '01-01-10-002/', 'Maxxam Clarifying Shampoo 10oz', 'Discontinued SKU; Replacement SKU: 840223300026 Maxxam Clarifying Shampoo 10oz' )
          , ( '04-02-10-001/', 'EXT Energizing Conditioner 10oz', 'Discontinued SKU; Has a replacement SKU 840223300101 EXT Energizing Conditioner 10oz' )
          , ( '03-03-08-002/', 'Maxxam Hair & Scalp Mender 8oz', 'Discontinued SKU; Has a replacement SKU 840223300491 Maxxam Hair & Scalp Mender 8oz' )
          , ( '04-01-10-001/', 'EXT Revitalizing Cleanser 10oz', 'Discontinued SKU; Has a replacement SKU 840223300088 EXT Revitalizing Cleanser 10oz' )
          , ( '04-03-08-003/', 'EXT Scalp & Follicle Enzyme Cleanser 8oz', 'Discontinued SKU; Has a replacement SKU 840223300118 EXT Scalp & Follicle Enzyme Cleanser 8oz' )
          , ( '05-04-03-10/', 'Trax Skin Prep 3oz', 'Discontinued SKU; Replacement SKU: 840223300262 Trax Skin Prep 3oz' )
          , ( '01-02-33-001/', 'Maxxam Moisturizing Conditioner 33oz. ', 'Discontinued SKU; Has a replacement SKU 840223300231 Maxxam Moisturizing Conditioner 33oz. ' )
          , ( '04-02-08-002', 'EXT Non-Sensitizing Conditioner 8oz', 'Discontinued SKU; Has a replacement SKU 840223300521 EXT Non-Sensitizing Conditioner 10oz' )
          , ( '04-02-10-004/', 'EXT Volumizing Conditioner 10oz', 'Discontinued SKU; Has a replacement SKU 840223300538 EXT Volumizing Conditioner 10oz' )
          , ( '02-03-06-011', 'Maxxam Body Building Mousse 6oz', 'Discontinued SKU; Has a replacement SKU 840223300125 Maxxam Kiss 6oz.' )
          , ( '03-03-08-003/', 'Maxxam Nutrient Maximizer 8oz', 'Discontinued SKU; Has a replacement SKU 840223300507 Maxxam Nutrient Maximizer 8oz' )
          , ( '01-01-10-001/', 'Maxxam Moisturizing Shampoo 10oz', 'Discontinued SKU; Replacement SKU: 840223300019 Maxxam Moisturizing Shampoo 10oz' )
          , ( '01-01-10-003/', 'Maxxam Normalizing Shampoo 10oz', 'Discontinued SKU; Replacement SKU: 840223300033 Maxxam Normalizing Shampoo 10oz' )
          , ( '01-01-33-002/', 'Maxxam Clarifying Shampoo 33oz. ', 'Discontinued SKU; Replacement SKU: 840223300149 Maxxam Clarifying Shampoo 33oz. ' )
          , ( '01-02-33-004', 'Maxxam Creme Rinse Detangler 33oz', 'Discontinued SKU; Replacement SKU: 840223300255 Maxxam Creme Rinse Detangler 33oz' )
          , ( '02-03-02-009/', 'Maxxam Groom Pomade 2oz.', 'Discontinued SKU; Replacement SKU: 840223300361 Maxxam Groom Pomade 2oz.' )
          , ( '02-03-03-013', 'Maxxam High Tech Hair Gloss 3oz.', 'Discontinued SKU; Replacement SKU: 840223300415 Maxxam High Tech Hair Gloss 3oz' )
          , ( '03-03-06-013', 'Maxxam Strengthen & Repair Protectant Spray 6oz. ', 'Discontinued SKU; Replacement Sku 840223300354 Maxxam Strengthen & Repair Protectant Spray 6oz. ' )
          , ( '04-05-02-001/', 'EXT Extreme Hair Therapy Minoxidil 2% For  Women 2oz', 'Discontinued SKU' )
          , ( '04-06-02-001/', 'EXT Extreme Hair Therapy Minoxidil 5% 60ml 2oz', 'Discontinued SKU' )
          , ( '05-04-02-007/', 'Trax Perm Waving Lotion 2oz.', 'Discontinued SKU; Replacement SKU: 840223300279 Trax Perm Waving Lotion 2oz.' )
          , ( '05-04-02-008/', 'Trax Perm Neutralizer 2oz. ', 'Discontinued SKU; Replacement SKU: 840223300286 Trax Perm Neutralizer 2oz. ' )
          , ( '05-04-33-001/', 'Trax Organic Citrus Solvent 33oz. ', 'Discontinued SKU; Replacement SKU: 840223300293 Trax Organic Citrus Solvent 33oz. ' )
          , ( '05-04-33-004/', 'Trax Clear Lace Solvent 33oz.', 'Discontinued SKU; Replacement SKU: 840223300330 Trax Clear Lace Solvent 33oz.' )
          , ( '06-05-33-001/', 'Maxx Polyfuse+ 33oz. ', 'Discontinued SKU' )) AS [vdata]( [SKU], [Product Description], [Discontinued/Phase Out Product  or  Replacement SKU?] ) ;

SELECT
    [a].[SalesCodeCenterID]
  , [a].[SalesCodeID]
  , [a].[IsActiveFlag]
  , [b].[SalesCodeID]
  , [b].[IsActiveFlag]
  , [b].[SalesCodeDescription]
  , [b].[SalesCodeDescriptionShort]
  , [c].[SKU]
  , [c].[Product Description]
FROM [dbo].[cfgSalesCodeCenter] AS [a]
INNER JOIN [dbo].[cfgSalesCode] AS [b] ON [b].[SalesCodeID] = [a].[SalesCodeID]
INNER JOIN [#temp] AS [c] ON [b].[SalesCodeDescription] = [c].[Product Description]
WHERE [a].[CenterID] IN (1091, 1098) ;
GO
RETURN ;

UPDATE [b]
SET [b].[IsActiveFlag] = 0
FROM [dbo].[cfgSalesCodeCenter] AS [a]
INNER JOIN [dbo].[cfgSalesCode] AS [b] ON [b].[SalesCodeID] = [a].[SalesCodeID]
INNER JOIN [#temp] AS [c] ON [b].[SalesCodeDescription] = [c].[Product Description]
WHERE [a].[CenterID] IN (1091, 1098) ;
GO
RETURN ;

UPDATE [a]
SET [a].[IsActiveFlag] = 0
FROM [dbo].[cfgSalesCodeCenter] AS [a]
INNER JOIN [dbo].[cfgSalesCode] AS [b] ON [b].[SalesCodeID] = [a].[SalesCodeID]
INNER JOIN [#temp] AS [c] ON [b].[SalesCodeDescription] = [c].[Product Description]
WHERE [a].[CenterID] IN (1091, 1098) ;
GO
