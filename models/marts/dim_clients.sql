select
    c.client_id,
    c.name,
    c.city,
    c.state,
    c.created_at,
    coalesce(sum(p.net_amount), 0) as total_portfolio_amount
from {{ ref('stg_clients') }} c
left join {{ ref('mart_client_portfolio') }} p on c.client_id = p.client_id
group by
    c.client_id,
    c.name,
    c.city,
    c.state,
    c.created_at