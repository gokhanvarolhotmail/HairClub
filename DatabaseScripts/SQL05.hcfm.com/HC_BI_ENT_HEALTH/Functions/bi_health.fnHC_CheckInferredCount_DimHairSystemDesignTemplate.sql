/* CreateDate: 10/24/2011 13:56:52.837 , ModifyDate: 10/24/2011 13:56:52.837 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimHairSystemDesignTemplate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimHairSystemDesignTemplate]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimHairSystemDesignTemplate]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemDesignTemplate]'


	INSERT INTO @tbl
		SELECT @TableName, HairSystemDesignTemplateKey, CAST(HairSystemDesignTemplateSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimHairSystemDesignTemplate] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimClient] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
