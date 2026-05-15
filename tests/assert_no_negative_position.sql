{{ config(severity='warn') }}

-- Teste singular responsável por identificar
-- clientes com posição líquida negativa

select *
from {{ ref('mart_client_portfolio') }}
where net_quantity < 0