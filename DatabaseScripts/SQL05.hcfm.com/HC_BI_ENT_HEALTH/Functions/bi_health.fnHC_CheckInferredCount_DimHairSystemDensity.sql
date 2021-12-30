/* CreateDate: 10/24/2011 13:41:37.433 , ModifyDate: 10/24/2011 13:41:37.433 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimHairSystemDensity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimHairSystemDensity]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimHairSystemDensity]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemDensity]'


	INSERT INTO @tbl
		SELECT @TableName, HairSystemDensityKey, CAST(HairSystemDensitySSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimHairSystemDensity] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimClient] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
