select
    t.transaction_id,
    t.client_id,
    c.name as client_name,
    t.asset_ticker,
    t.operation,
    t.quantity,
    t.unit_price,
    t.transaction_date,
    t.quantity * t.unit_price as gross_amount,
    {{ signed_value('t.operation', 't.quantity') }} as signed_quantity,
    case
        when t.operation = 'BUY' then t.quantity * t.unit_price
        when t.operation = 'SELL' then -(t.quantity * t.unit_price)
    end as signed_amount
from {{ ref('stg_transactions') }} t
left join {{ ref('stg_clients') }} c
    on t.client_id = c.client_id