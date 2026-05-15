{{
    config(
        materialized='incremental',
        unique_key='transaction_id'
    )
}}

select *
from {{ ref('int_transactions') }}

{% if is_incremental() %}

where transaction_date >
    (
        select max(transaction_date)
        from {{ this }}
    )

{% endif %}