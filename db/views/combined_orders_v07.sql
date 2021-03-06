SELECT
shipwire_orders.id AS id,
shopify_orders.shopify_id AS shopify_identifier,
shipwire_orders.shopify_id AS shipwire_identifier,
xero_invoices.shopify_id AS xero_identifier,
shopify_orders.id AS shopify_order_id,
shipwire_orders.id AS shipwire_order_id,
xero_invoices.id AS xero_invoice_id,
shopify_orders.fulfillment_status AS shopify_status,
shipwire_orders.fulfillment_status AS shipwire_status,
xero_invoices.invoice_status AS xero_status,
shopify_orders.order_updated_at AS shopify_updated_at,
shipwire_orders.order_updated_at AS shipwire_updated_at,
xero_invoices.order_updated_at AS xero_updated_at,
shopify_orders.total_shipping AS shopify_total_shipping,
shipwire_orders.total_shipping AS shipwire_total_shipping,
shopify_orders.sub_total AS shopify_sub_total,
xero_invoices.sub_total AS xero_sub_total,
shopify_orders.total AS shopify_total,
xero_invoices.total AS xero_total,
shopify_orders.discount_total AS shopify_discount_total,
shopify_orders.paid_date AS shopify_paid_date,
shipwire_orders.accepted_at AS shipwire_accepted_at,
shipwire_orders.shipped_at AS shipwire_shipped_at
FROM shipwire_orders
LEFT OUTER JOIN shopify_orders ON shipwire_orders.shopify_id ILIKE shopify_orders.shopify_id || '%'
LEFT OUTER JOIN xero_invoices ON shipwire_orders.shopify_id ILIKE xero_invoices.shopify_id || '%'
