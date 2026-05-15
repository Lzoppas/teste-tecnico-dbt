select
    client_id,
    client_name,
    asset_ticker,
    sum(signed_quantity) as net_quantity,
    sum(signed_amount) as net_amount
from {{ ref('int_transactions') }}
group by
    client_id,
    client_name,
    asset_ticker