WITH sat_with_effective_to AS (
    SELECT 
        scd.CUSTOMER_PK,
        scd.first_name,
        scd.last_name,
        scd.email,
        scd.EFFECTIVE_FROM,
        LEAD(scd.EFFECTIVE_FROM, 1, date '9999-12-31') OVER(PARTITION BY scd.CUSTOMER_PK ORDER BY scd.EFFECTIVE_FROM) as EFFECTIVE_TO
    FROM 
        {{ref('sat_customer_details')}} scd
)
SELECT 
    vpcd.as_of_date,
    swet.CUSTOMER_PK,
    swet.first_name,
    swet.last_name,
    swet.email,
    swet.EFFECTIVE_FROM,
    swet.EFFECTIVE_TO
FROM 
    {{ref('pit_customer_details')}} vpcd 
    LEFT JOIN sat_with_effective_to swet ON vpcd.sat_customer_details_pk = swet.CUSTOMER_PK
ORDER BY 
    swet.CUSTOMER_PK,
    vpcd.as_of_date
