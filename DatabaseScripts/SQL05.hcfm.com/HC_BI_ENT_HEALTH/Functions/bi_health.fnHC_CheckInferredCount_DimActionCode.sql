/* CreateDate: 05/12/2010 11:02:37.317 , ModifyDate: 05/13/2010 14:39:28.607 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimActionCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimActionCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimActionCode]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimActionCode]'


	INSERT INTO @tbl
		SELECT @TableName, ActionCodeKey, ActionCodeSSID
		FROM [bi_health].[synHC_DDS_DimActionCode] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimActionCode] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
