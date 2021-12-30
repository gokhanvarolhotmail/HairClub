/* CreateDate: 09/07/2020 17:40:27.640 , ModifyDate: 09/07/2020 17:40:27.640 */
GO
-- =============================================
-- Author:		rrojas
-- Create date: 19/08/2020
-- Description:	Get relaxer values for technical profile TFS14594
-- =============================================
CREATE PROCEDURE selGetRelaxerValues
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
	   [RelaxerBrandID]
      ,[RelaxerBrandSortOrder]
      ,[RelaxerBrandDescription]
      ,[RelaxerBrandDescriptionShort]
      ,[IsActiveFlag]
      ,[CreateDate]
      ,[CreateUser]
      ,[LastUpdate]
      ,[LastUpdateUser]
      ,[UpdateStamp]
  FROM [dbo].[lkpRelaxerBrand]
 where RelaxerBrandDescription not in( 'IGORA COLOR10', 'Matrix Prizms', 'Matrix SoColor', 'Matrix SoCult', 'Matrix So Cult','Matrix ColorSync')  and isActiveFlag=1
END
GO
