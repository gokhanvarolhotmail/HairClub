/* CreateDate: 05/12/2010 11:12:11.803 , ModifyDate: 10/26/2011 15:08:11.027 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimClientMembershipAccum] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimClientMembershipAccum]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimClientMembershipAccum]()
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

 	SET @TableName = N'[bi_cms_dds].[DimClientMembershipAccum]'


	INSERT INTO @tbl
		SELECT @TableName, ClientMembershipAccumKey, CAST(ClientMembershipAccumSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimClientMembershipAccum] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1

	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimClientMembershipAccum] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
