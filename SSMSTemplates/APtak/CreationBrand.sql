INSERT INTO dbo.lkpBrand
(
  BrandID,
  BrandSortOrder,
  BrandDescription,
  BrandDescriptionShort,
  IsActiveFlag,
  CreateDate,
  CreateUser,
  LastUpdate,
  LastUpdateUser
)
VALUES
(
  (SELECT max(BrandId)  +1 FROM lkpBrand),
  1,
  'Amika',
  'Amika',
  1,
  GETUTCDATE(),
  'TFS#14975',
  GETUTCDATE(),
  'TFS#14975'
)
