/* CreateDate: 05/12/2010 11:00:09.807 , ModifyDate: 05/13/2010 14:54:46.743 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimSource] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimSource]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimSource]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimSource]'


	INSERT INTO @tbl
		SELECT @TableName, SourceKey, SourceSSID
		FROM [bi_health].[synHC_DDS_DimSource] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimSource] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
