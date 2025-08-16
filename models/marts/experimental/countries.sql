{% set country_types = {
    'US': 1,
    'CA': 2,
    'GB': 3,
    'AU': 4,
} %}


select
    *,
    case
        {% for country_code, rank in country_types.items() %}
            when country_code like '{{ country_code }}' then '{{ rank }}'::int
        {% endfor %}
        else -1
    end as country_rank,
    1 as test_fail
from {{ ref('country_codes') }}
