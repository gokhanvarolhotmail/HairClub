CREATE VIEW [dbo].[vwCfgCurrencyExchangeRate]
AS
SELECT     cer.CurrencyExchangeRateID, lkpCT.CurrencyTypeDescription, cer.ExchangeRate, cer.BeginDate, cer.EndDate, cer.IsActiveFlag, cer.CreateDate,
                      cer.CreateUser, cer.LastUpdate, cer.LastUpdateUser, cer.UpdateStamp
FROM         dbo.cfgCurrencyExchangeRate AS cer LEFT OUTER JOIN
                      dbo.lkpCurrencyType AS lkpCT ON lkpCT.CurrencyTypeID = cer.CurrencyTypeID
