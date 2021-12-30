/* CreateDate: 05/12/2010 11:09:58.060 , ModifyDate: 05/13/2010 14:25:47.447 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimAccumulator] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimAccumulator]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimAccumulator]()
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulator]'


	INSERT INTO @tbl
		SELECT @TableName, AccumulatorKey, CAST(AccumulatorSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimAccumulator] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimAccumulator] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
