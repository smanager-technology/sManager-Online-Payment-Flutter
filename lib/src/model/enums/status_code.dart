/// 200	success
/// 400	The transaction id field is required
/// 404	The given transaction ID not found
/// 501	This client is not published
/// 502	The ip <$ip> you are accessing from is not whitelisted
/// 503	Client id or secret is missing from the request
/// 504	Client ID and Secret does not match
/// 505	Invalid Transaction ID, Please provide a unique transaction ID
/// 507	Failed to initiate Payment Link
///
enum StatusCode {
  SUCCESS,
  TRANSACTION_ID_FIELD_REQUIRED,
  TRANSACTION_ID_NOT_FOUND,
  CLIENT_NOT_PUBLISHED,
  IP_NOT_WHITELIST,
  CLIENT_ID_OR_SECRET_MISSING,
  CLIENT_ID_OR_SECRET_NOT_MATCH,
  INVALID_TRANSACTION_ID,
  FAILED_TO_INITIATE,
}
