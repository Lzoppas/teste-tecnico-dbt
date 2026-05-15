select distinct on (client_id)
    client_id,
    name,
    city,
    state,
    cast(created_at as date) as created_at
from {{ ref('clients') }}
where client_id is not null
order by client_id