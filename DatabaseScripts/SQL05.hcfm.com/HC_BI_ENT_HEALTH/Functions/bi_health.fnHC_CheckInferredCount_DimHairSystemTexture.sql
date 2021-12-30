/* CreateDate: 10/24/2011 16:45:56.207 , ModifyDate: 10/24/2011 16:45:56.207 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimHairSystemTexture] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimHairSystemTexture]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimHairSystemTexture]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemTexture]'


	INSERT INTO @tbl
		SELECT @TableName, HairSystemTextureKey, CAST(HairSystemTextureSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimHairSystemTexture] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimClient] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
