/* CreateDate: 05/12/2010 10:54:41.663 , ModifyDate: 05/13/2010 14:40:34.367 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimActivityResult] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimActivityResult]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimActivityResult]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivityResult]'


	INSERT INTO @tbl
		SELECT @TableName, ActivityResultKey, ActivityResultSSID
		FROM [bi_health].[synHC_DDS_DimActivityResult] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimActivityResult] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
