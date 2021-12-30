/* CreateDate: 05/12/2010 11:27:08.740 , ModifyDate: 05/13/2010 14:42:44.523 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimCenter] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimCenter]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimCenter]()
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

 	SET @TableName = N'[bi_cms_dds].[DimCenter]'


	INSERT INTO @tbl
		SELECT @TableName, CenterKey, CAST(CenterSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimCenter] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimCenter] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
