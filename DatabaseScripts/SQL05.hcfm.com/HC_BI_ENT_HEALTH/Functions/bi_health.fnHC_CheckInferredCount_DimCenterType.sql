/* CreateDate: 05/12/2010 11:28:27.327 , ModifyDate: 05/13/2010 14:43:25.280 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimCenterType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimCenterType]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimCenterType]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimCenterType]'


	INSERT INTO @tbl
		SELECT @TableName, CenterTypeKey, CAST(CenterTypeSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimCenterType] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimCenterType] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
