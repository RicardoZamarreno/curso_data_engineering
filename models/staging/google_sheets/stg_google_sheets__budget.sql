{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
          _row
        , product_id
        , quantity
        , DATE_PART (month, month) as month
        , convert_timezone('UTC', _fivetran_synced) as date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted