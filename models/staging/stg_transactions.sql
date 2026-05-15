select
    transaction_id,
    client_id,
    asset_ticker,
    operation,
    cast(quantity as integer) as quantity,
    cast(unit_price as numeric(10,2)) as unit_price,
    cast(transaction_date as date) as transaction_date
from {{ ref('transactions') }}
where client_id is not null
  and quantity > 0

