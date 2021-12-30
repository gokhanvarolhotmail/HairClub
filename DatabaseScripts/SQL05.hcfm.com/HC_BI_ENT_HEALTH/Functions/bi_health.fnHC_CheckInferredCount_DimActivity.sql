/* CreateDate: 05/08/2010 17:29:02.610 , ModifyDate: 05/13/2010 14:39:50.780 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimActivity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimActivity]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimActivity]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivity]'


	INSERT INTO @tbl
		SELECT @TableName, ActivityKey, ActivitySSID
		FROM [bi_health].[synHC_DDS_DimActivity] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimActivity] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
