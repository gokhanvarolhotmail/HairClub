/* CreateDate: 05/12/2010 10:52:57.230 , ModifyDate: 05/13/2010 14:51:13.457 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimResultCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimResultCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimResultCode]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimResultCode]'


	INSERT INTO @tbl
		SELECT @TableName, ResultCodeKey, ResultCodeSSID
		FROM [bi_health].[synHC_DDS_DimResultCode] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimResultCode] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
