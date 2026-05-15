{% macro signed_value(operation_column, value_column) %}

    case 
        when {{operation_column}} = 'BUY' 
            then {{value_column}}
        when {{operation_column}} = 'SELL'
            then -{{value_column}}
    end

{% endmacro %}