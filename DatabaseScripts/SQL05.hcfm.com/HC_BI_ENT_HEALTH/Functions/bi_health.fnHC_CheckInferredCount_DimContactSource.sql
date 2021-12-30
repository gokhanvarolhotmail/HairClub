/* CreateDate: 05/12/2010 10:56:48.470 , ModifyDate: 05/13/2010 14:46:33.883 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimContactSource] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimContactSource]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimContactSource]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactSource]'


	INSERT INTO @tbl
		SELECT @TableName, ContactSourceKey, ContactSourceSSID
		FROM [bi_health].[synHC_DDS_DimContactSource] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimContactSource] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
