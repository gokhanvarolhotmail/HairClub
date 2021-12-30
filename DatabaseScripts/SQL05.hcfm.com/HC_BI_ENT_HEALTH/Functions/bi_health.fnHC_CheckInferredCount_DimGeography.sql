/* CreateDate: 05/12/2010 11:33:32.123 , ModifyDate: 05/13/2010 14:48:43.880 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimGeography] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimGeography]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimGeography]()
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

 	SET @TableName = N'[bi_cms_dds].[DimGeography]'


	INSERT INTO @tbl
		SELECT @TableName, GeographyKey, CAST(PostalCode as varchar(150))
		FROM [bi_health].[synHC_DDS_DimGeography] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimGeography] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
