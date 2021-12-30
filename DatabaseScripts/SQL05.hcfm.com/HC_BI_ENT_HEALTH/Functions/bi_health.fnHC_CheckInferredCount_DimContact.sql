/* CreateDate: 05/12/2010 10:57:49.443 , ModifyDate: 05/13/2010 14:45:03.637 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimContact] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimContact]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimContact]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimContact]'


	INSERT INTO @tbl
		SELECT @TableName, ContactKey, ContactSSID
		FROM [bi_health].[synHC_DDS_DimContact] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimContact] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
