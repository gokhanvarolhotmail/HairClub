/* CreateDate: 10/24/2011 14:00:46.243 , ModifyDate: 10/24/2011 14:00:46.243 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimHairSystemFrontalDensity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimHairSystemFrontalDensity]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimHairSystemFrontalDensity]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemFrontalDensity]'


	INSERT INTO @tbl
		SELECT @TableName, HairSystemFrontalDensityKey, CAST(HairSystemFrontalDensitySSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimHairSystemFrontalDensity] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimClient] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
