-- =============================================
-- Author:		rrojas
-- Create date: 19/08/2019
-- Description:	Get perm brands TFS14594
-- =============================================
CREATE PROCEDURE selGetPermBrands
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [PermBrandID]
      ,[PermBrandSortOrder]
      ,[PermBrandDescription]
      ,[PermBrandDescriptionShort]
      ,[IsActiveFlag]
      ,[CreateDate]
      ,[CreateUser]
      ,[LastUpdate]
      ,[LastUpdateUser]
      ,[UpdateStamp]
  FROM [dbo].[lkpPermBrand]
	where PermBrandDescription not in( 'IGORA COLOR10', 'Matrix Prizms', 'Matrix SoColor', 'Matrix SoCult', 'Matrix So Cult','Matrix ColorSync') and IsActiveFlag=1
END
