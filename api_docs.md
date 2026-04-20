# ElanLedgers App API Docs

Base URL: `https://your-domain/api/v1`

All endpoints return JSON. Protected endpoints require a JWT in one of these headers:
- `Authorization: Bearer <token>`
- `Authorization: <token>`
- `token: <token>`

`POST` endpoints accept either JSON (`Content-Type: application/json`) or normal form payloads.

## App Auth Controller

Public discovery:
- `GET /app/auth/map` : list supported auth endpoints, auth requirements, and comments.

Public auth endpoints:
- `POST /app/auth/signin` : sign in with `username|phone|email` plus `password`, then return a JWT token.
- `POST /app/auth/signup` : alias of register for backward compatibility.
- `POST /app/auth/register` : create a user and first shop.
- `POST /app/auth/reset/send` : send OTP/reset password for `username|phone|email|user_id`.
- `GET|POST /app/auth/constants` : return public constants such as `business_category` and `dashboard_menu`.

Protected auth endpoints:
- `POST /app/auth/completeprofile` : finish onboarding with `region`, `lob_id`, and optional `reseller_id`.
- `POST /app/auth/addshop` : create another shop for the authenticated account.
- `POST /app/auth/switchshop` : switch the active session shop using `shop_id`.
- `GET|POST /app/auth/signout` : destroy the session restored from the JWT token.

## App Get Controller

Top-level endpoints:
- `GET /app/get/dashboard` : return dashboard menu data after restoring session from JWT.
- `GET /app/get/getdata/map` : return all mapped helper-backed and controller-backed GET data endpoints.
- `GET /app/get/getreport/map` : return all available report groups and report function names.
- `GET /app/get/getreport/reports` : return grouped report definitions from `reports()`.

Helper-backed `GET /app/get/getdata/{endpoint}` routes:
- `filter_range` : active date filter summary.
- `stock_category` : stock categories.
- `payment_mode` : payment methods/accounts for sales and purchases.
- `permissions` : available permission keys.
- `shop_settings` : current shop settings.
- `session_shop` : current shop/session shop record.
- `sidemenu` : menu configuration.
- `dashboard_summary` : dashboard summary values.
- `products`, `product_history`, `stock`, `stockCategoryWise`, `sellable_stock` : stock and product datasets.
- `profit_summary`, `salestable`, `sales`, `orders`, `productsInOrder`, `invoices`, `sales_orders`, `sales_summary`, `invoice_summary`, `order_summary` : sales datasets.
- `expense_accounts`, `expense_summary`, `cashbookAccounts`, `chatOfAccounts`, `sourceOfFundAccounts`, `cashflow`, `expenses` : accounting datasets.
- `team`, `waiters`, `staffInSales`, `waitersInSales`, `shops`, `users`, `session_user`, `my_shops` : people and session datasets.
- `reseller_summary`, `reseller_invited_shops` : reseller dashboards.
- `contact_category`, `contacts`, `customers`, `suppliers`, `oncredit_suppliers`, `oncash_suppliers`, `onorder_suppliers`, `oncredit_customers`, `customerInSales` : CRM datasets.
- `systeminfo`, `suUsers`, `suShops`, `packages`, `lobs`, `purchase_history`, `purchase_orders`, `importHistory`, `recycle_bin`, `tms` : utility datasets.
- `tellerCashManagement`, `customerCashManagement`, `customerAccountsSummary`, `bankingCustomerAccounts` : banking datasets.
- `totalStockReport`, `totalSalesReport` : report-style summary datasets.
- `loanProducts`, `loanApplications`, `loans`, `loanSchedules`, `guarantors`, `onlyguarantors` : microfinance datasets.

Controller-backed `GET /app/get/getdata/{endpoint}` routes:
- `customer/campaign-users` : privileged campaign recipients from system users.
- `customer/message-history` : message history for a contact phone or a specific `user_id`.
- `sales/record` : full sale header and sold items. Query param: `sale_id`.
- `stock/inventory` : live inventory JSON.
- `stock/lob-categories` : categories and subcategories for the current line of business.
- `stock/remote-shop-products` : products from another owned shop. Query param: `shop_id`.
- `settings/serverinfo` : server/system info payload.

Report execution:
- `GET /app/get/getreport/{reportFunction}` dispatches the matching `reports_model->{reportFunction}($filter)`.
- Use `GET /app/get/getreport/map` to discover the live report list for the current shop type.

## App Post Controller

Discovery:
- `POST /app/post/postdata/map` : list all mapped POST endpoints with comments.

Filter/session helpers:
- `POST /app/post/postdata/filter/set` : persist the shared date filter used by `getdata`.
- `POST /app/post/postdata/report/filter/set` : persist the shared date filter used by `getreport`.

Business operations:
- `POST /app/post/postdata/banking/customer-transaction` : create/update customer cash transaction.
- `POST /app/post/postdata/cashflow/add-fund` : add funds/cash in.
- `POST /app/post/postdata/cashflow/add-expense` : add expense.
- `POST /app/post/postdata/cashflow/delete-expenses` : archive one or more expenses.

Customers and campaigns:
- `POST /app/post/postdata/customer/create` : create/update customer.
- `POST /app/post/postdata/customer/delete` : soft-delete customers.
- `POST /app/post/postdata/customer/import` : import customers from spreadsheet.
- `POST /app/post/postdata/customer/category/create` : create/update contact category.
- `POST /app/post/postdata/customer/category/delete` : delete unused contact category.
- `POST /app/post/postdata/customer/contact/create` : create/update campaign contact.
- `POST /app/post/postdata/customer/contact/bulk-categorize` : bulk-assign contact category.
- `POST /app/post/postdata/customer/sms/send-bulk` : send bulk SMS.

Auth-adjacent legacy/business actions:
- `POST /app/post/postdata/home/password/change` : change current user password.
- `POST /app/post/postdata/reseller/join` : join reseller program.
- `POST /app/post/postdata/welcome/register` : legacy register alias, no JWT required.
- `POST /app/post/postdata/welcome/reset/send` : legacy OTP/reset alias, no JWT required.
- `POST /app/post/postdata/welcome/add-shop` : legacy add-shop alias.
- `POST /app/post/postdata/welcome/switch-shop` : legacy switch-shop alias.

Microfinance:
- `POST /app/post/postdata/microfinance/loan-product/create` : create/update loan product.
- `POST /app/post/postdata/microfinance/guarantor/create` : create/update guarantor.
- `POST /app/post/postdata/microfinance/import` : import microfinance contacts.
- `POST /app/post/postdata/microfinance/category/create` : create microfinance category.
- `POST /app/post/postdata/microfinance/contact/create` : create microfinance contact.
- `POST /app/post/postdata/microfinance/sms/send-bulk` : bulk SMS using shared customer SMS sender.
- `POST /app/post/postdata/microfinance/loan/create` : create loan application.
- `POST /app/post/postdata/microfinance/loan/update` : review/approve/reject/disburse/update loan.

Sales:
- `POST /app/post/postdata/sales/add` : create sale/invoice/order/quotation.
- `POST /app/post/postdata/sales/update` : update sale record.
- `POST /app/post/postdata/sales/add-payment` : add invoice payment.
- `POST /app/post/postdata/sales/delete-record` : delete/archive sale record.
- `POST /app/post/postdata/sales/order-status/update` : update order status. Payload: `sale_id`.
- `POST /app/post/postdata/sales/receipt/email` : email invoice/receipt/quotation. Payload: `sale_id`.

Settings and administration:
- `POST /app/post/postdata/settings/account/create` : create account.
- `POST /app/post/postdata/settings/record/update` : generic single-field record update.
- `POST /app/post/postdata/settings/shop/update` : update shop field.
- `POST /app/post/postdata/settings/record/delete` : delete/archive/restore record.
- `POST /app/post/postdata/settings/account/delete` : delete current shop/account.
- `POST /app/post/postdata/settings/shop/reset` : clear primary sales/products data for current shop.
- `POST /app/post/postdata/settings/sms-account/verify` : verify SMS provider account.
- `POST /app/post/postdata/settings/email/send` : send email with configured sender.
- `POST /app/post/postdata/su/shop/update` : update shop from super-user panel.

Stock and suppliers:
- `POST /app/post/postdata/stock/register/create` : create product/service.
- `POST /app/post/postdata/stock/register/import` : import products/services.
- `POST /app/post/postdata/stock/restock/create` : record stock purchase/restock.
- `POST /app/post/postdata/stock/restock/balance` : apply stock balance adjustment.
- `POST /app/post/postdata/stock/product/update` : update product/batch.
- `POST /app/post/postdata/stock/product/delete-bulk` : delete many products.
- `POST /app/post/postdata/stock/product/category-bulk` : bulk recategorize products.
- `POST /app/post/postdata/stock/product/photo-delete` : delete product photo.
- `POST /app/post/postdata/stock/category/create` : create stock category.
- `POST /app/post/postdata/stock/transfer` : transfer stock.
- `POST /app/post/postdata/stock/copy-in-products` : copy products from another shop.
- `POST /app/post/postdata/stock/purchase/delete` : archive purchases.
- `POST /app/post/postdata/supplier/add` : create/update supplier.
- `POST /app/post/postdata/supplier/delete` : soft-delete suppliers.

Subscription, team, and uploads:
- `POST /app/post/postdata/subscription/package/create` : create package.
- `POST /app/post/postdata/subscription/package/update` : update package.
- `POST /app/post/postdata/subscription/payment/complete` : complete package payment.
- `POST /app/post/postdata/team/waiter/create` : create/update waiter.
- `POST /app/post/postdata/team/staff/add` : add staff member.
- `POST /app/post/postdata/team/nonstaff/add` : add nonstaff member.
- `POST /app/post/postdata/team/member/update` : update team member.
- `POST /app/post/postdata/team/status/update` : toggle team status. Payload: `role_id`.
- `POST /app/post/postdata/team/permission/update` : update one permission. Payload: `role_id`, `col`, `status`.
- `POST /app/post/postdata/upload/logo` : upload business logo.

## Token Debug Mode

For `app/get/*` and `app/post/postdata/*`, you can inspect token resolution with any of:
- query string `?debug_token=1`
- request body field `debug_token=1`
- header `X-Debug-Token: 1`

## Notes

- The plain-text file requested as `api_doc.text` maps to this repo file: `api_docs.txt`.
- Use the new map endpoints instead of hard-coding endpoint lists where possible:
  - `GET /app/auth/map`
  - `GET /app/get/getdata/map`
  - `GET /app/get/getreport/map`
  - `POST /app/post/postdata/map`
