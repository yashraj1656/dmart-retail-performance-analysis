CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE staging.fmcg_warehouse_raw (
    warehouse_id                  VARCHAR(30),
    wh_manager_id                 VARCHAR(30),
    location_type                 VARCHAR(20),
    wh_capacity_size              VARCHAR(20),
    zone                          VARCHAR(20),
    wh_regional_zone              VARCHAR(20),
    num_refill_req_l3m            INTEGER,
    transport_issue_l1y           INTEGER,
    competitor_in_mkt             INTEGER,
    retail_shop_num               NUMERIC(12, 2),
    wh_owner_type                 VARCHAR(30),
    distributor_num               INTEGER,
    flood_impacted                SMALLINT,
    flood_proof                   SMALLINT,
    electric_supply               SMALLINT,
    dist_from_hub                 INTEGER,
    workers_num                   INTEGER,
    storage_issue_reported_l3m    INTEGER,
    temp_reg_mach                 SMALLINT,
    approved_wh_govt_certificate  VARCHAR(10),
    wh_breakdown_l3m              INTEGER,
    govt_check_l3m                INTEGER,
    product_wg_ton                INTEGER
);


select * from staging.fmcg_warehouse_raw;

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT warehouse_id) AS unique_warehouses,
    COUNT(*) FILTER (WHERE warehouse_id IS NULL) AS missing_warehouse_ids
FROM staging.fmcg_warehouse_raw;


SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(warehouse_id) AS missing_warehouse_ids,
    COUNT(*) - COUNT(wh_manager_id) AS missing_manager_ids,
    COUNT(DISTINCT warehouse_id) AS unique_warehouses,
    COUNT(DISTINCT wh_manager_id) AS unique_managers,
    COUNT(*) FILTER (
        WHERE flood_impacted NOT IN (0, 1)
           OR flood_proof NOT IN (0, 1)
           OR electric_supply NOT IN (0, 1)
           OR temp_reg_mach NOT IN (0, 1)
    ) AS invalid_binary_rows
FROM staging.fmcg_warehouse_raw;


SELECT
    MIN(num_refill_req_l3m) AS min_refill_requests,
    MAX(num_refill_req_l3m) AS max_refill_requests,
    MIN(transport_issue_l1y) AS min_transport_issues,
    MAX(transport_issue_l1y) AS max_transport_issues,
    MIN(retail_shop_num) AS min_retail_shops,
    MAX(retail_shop_num) AS max_retail_shops,
    MIN(dist_from_hub) AS min_distance_from_hub,
    MAX(dist_from_hub) AS max_distance_from_hub,
    MIN(product_wg_ton) AS min_product_weight,
    MAX(product_wg_ton) AS max_product_weight
FROM staging.fmcg_warehouse_raw;



SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (
        warehouse_id,
        wh_manager_id,
        location_type,
        wh_capacity_size,
        zone,
        wh_regional_zone,
        num_refill_req_l3m,
        transport_issue_l1y,
        competitor_in_mkt,
        retail_shop_num,
        wh_owner_type,
        distributor_num,
        flood_impacted,
        flood_proof,
        electric_supply,
        dist_from_hub,
        workers_num,
        storage_issue_reported_l3m,
        temp_reg_mach,
        approved_wh_govt_certificate,
        wh_breakdown_l3m,
        govt_check_l3m,
        product_wg_ton
    )) AS distinct_records
FROM staging.fmcg_warehouse_raw;


SELECT
    transport_issue_l1y AS transport_issue_count,
    COUNT(*) AS warehouse_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS warehouse_percentage
FROM staging.fmcg_warehouse_raw
GROUP BY transport_issue_l1y
ORDER BY transport_issue_count;


SELECT
    zone,
    COUNT(*) AS total_warehouses,
    SUM(transport_issue_l1y) AS total_transport_issues,
    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS warehouses_with_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS issue_warehouse_percentage,
    ROUND(
        AVG(transport_issue_l1y),
        2
    ) AS avg_issues_per_warehouse
FROM staging.fmcg_warehouse_raw
GROUP BY zone
ORDER BY issue_warehouse_percentage DESC;

SELECT
    wh_capacity_size AS capacity_size,
    COUNT(*) AS total_warehouses,
    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS warehouses_with_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS issue_warehouse_percentage,
    ROUND(
        AVG(transport_issue_l1y),
        2
    ) AS avg_issues_per_warehouse,
    ROUND(
        AVG(dist_from_hub),
        2
    ) AS avg_distance_from_hub
FROM staging.fmcg_warehouse_raw
GROUP BY wh_capacity_size
ORDER BY issue_warehouse_percentage DESC;


WITH distance_groups AS (
    SELECT
        CASE
            WHEN dist_from_hub < 100 THEN '01. Under 100'
            WHEN dist_from_hub < 150 THEN '02. 100–149'
            WHEN dist_from_hub < 200 THEN '03. 150–199'
            ELSE '04. 200 and above'
        END AS distance_band,
        dist_from_hub,
        transport_issue_l1y
    FROM staging.fmcg_warehouse_raw
)
SELECT
    distance_band,
    COUNT(*) AS total_warehouses,
    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS warehouses_with_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS issue_warehouse_percentage,
    ROUND(
        AVG(transport_issue_l1y),
        2
    ) AS avg_transport_issues
FROM distance_groups
GROUP BY distance_band
ORDER BY distance_band;


SELECT
    CASE
        WHEN electric_supply = 1 THEN 'Electricity available'
        WHEN electric_supply = 0 THEN 'No electricity recorded'
        ELSE 'Unknown'
    END AS electricity_status,
    COUNT(*) AS total_warehouses,
    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS warehouses_with_transport_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS transport_issue_rate_pct,
    ROUND(
        AVG(transport_issue_l1y),
        2
    ) AS avg_transport_issues
FROM staging.fmcg_warehouse_raw
GROUP BY electric_supply
ORDER BY electric_supply DESC;

SELECT
    CASE
        WHEN temp_reg_mach = 1
            THEN 'Temperature machinery available'
        WHEN temp_reg_mach = 0
            THEN 'No temperature machinery recorded'
        ELSE 'Unknown'
    END AS temperature_machinery_status,
    COUNT(*) AS total_warehouses,
    SUM(storage_issue_reported_l3m) AS total_reported_storage_issues,
    ROUND(
        AVG(storage_issue_reported_l3m),
        2
    ) AS avg_storage_issues_per_warehouse,
    COUNT(*) FILTER (
        WHERE storage_issue_reported_l3m > 0
    ) AS warehouses_with_storage_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE storage_issue_reported_l3m > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS storage_issue_warehouse_percentage
FROM staging.fmcg_warehouse_raw
GROUP BY temp_reg_mach
ORDER BY temp_reg_mach DESC;

SELECT
    wh_breakdown_l3m AS breakdown_count,
    COUNT(*) AS total_warehouses,
    ROUND(
        AVG(storage_issue_reported_l3m),
        2
    ) AS avg_storage_issues,
    COUNT(*) FILTER (
        WHERE storage_issue_reported_l3m > 0
    ) AS warehouses_with_storage_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE storage_issue_reported_l3m > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS storage_issue_rate_pct
FROM staging.fmcg_warehouse_raw
GROUP BY wh_breakdown_l3m
ORDER BY breakdown_count;

SELECT
    CORR(
        wh_breakdown_l3m::NUMERIC,
        storage_issue_reported_l3m::NUMERIC
    ) AS breakdown_storage_correlation,
    COUNT(*) FILTER (
        WHERE wh_breakdown_l3m = 0
          AND storage_issue_reported_l3m = 0
    ) AS both_zero,
    COUNT(*) FILTER (
        WHERE wh_breakdown_l3m = 0
          AND storage_issue_reported_l3m > 0
    ) AS breakdown_zero_storage_positive,
    COUNT(*) FILTER (
        WHERE wh_breakdown_l3m > 0
          AND storage_issue_reported_l3m = 0
    ) AS breakdown_positive_storage_zero,
    COUNT(*) FILTER (
        WHERE wh_breakdown_l3m > 0
          AND storage_issue_reported_l3m > 0
    ) AS both_positive
FROM staging.fmcg_warehouse_raw;

SELECT
    approved_wh_govt_certificate AS certificate_grade,
    COUNT(*) AS total_warehouses,
    COUNT(*) FILTER (
        WHERE storage_issue_reported_l3m > 0
    ) AS warehouses_with_storage_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE storage_issue_reported_l3m > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS storage_issue_rate_pct,
    ROUND(
        AVG(storage_issue_reported_l3m),
        2
    ) AS avg_storage_issues
FROM staging.fmcg_warehouse_raw
GROUP BY approved_wh_govt_certificate
ORDER BY
    CASE approved_wh_govt_certificate
        WHEN 'A+' THEN 1
        WHEN 'A'  THEN 2
        WHEN 'B+' THEN 3
        WHEN 'B'  THEN 4
        WHEN 'C'  THEN 5
        ELSE 6
    END;


	SELECT
    approved_wh_govt_certificate AS certificate_grade,
    COUNT(*) AS total_warehouses,
    ROUND(
        AVG(wh_breakdown_l3m),
        2
    ) AS avg_breakdowns,
    COUNT(*) FILTER (
        WHERE wh_breakdown_l3m = 0
    ) AS warehouses_with_zero_breakdowns,
    ROUND(
        COUNT(*) FILTER (
            WHERE wh_breakdown_l3m = 0
        ) * 100.0 / COUNT(*),
        2
    ) AS zero_breakdown_rate_pct,
    ROUND(
        AVG(storage_issue_reported_l3m),
        2
    ) AS avg_storage_issues
FROM staging.fmcg_warehouse_raw
GROUP BY approved_wh_govt_certificate
ORDER BY
    CASE approved_wh_govt_certificate
        WHEN 'A+' THEN 1
        WHEN 'A'  THEN 2
        WHEN 'B+' THEN 3
        WHEN 'B'  THEN 4
        WHEN 'C'  THEN 5
        ELSE 6
    END;

SELECT
    wh_capacity_size AS capacity_size,
    approved_wh_govt_certificate AS certificate_grade,
    COUNT(*) AS total_warehouses,
    ROUND(
        AVG(wh_breakdown_l3m),
        2
    ) AS avg_breakdowns,
    ROUND(
        AVG(storage_issue_reported_l3m),
        2
    ) AS avg_storage_issues,
    COUNT(*) FILTER (
        WHERE wh_breakdown_l3m = 0
    ) AS zero_breakdown_warehouses
FROM staging.fmcg_warehouse_raw
GROUP BY
    wh_capacity_size,
    approved_wh_govt_certificate
ORDER BY
    wh_capacity_size,
    CASE approved_wh_govt_certificate
        WHEN 'A+' THEN 1
        WHEN 'A'  THEN 2
        WHEN 'B+' THEN 3
        WHEN 'B'  THEN 4
        WHEN 'C'  THEN 5
        ELSE 6
    END;


SELECT
    wh_capacity_size AS capacity_size,
    approved_wh_govt_certificate AS certificate_grade,
    COUNT(*) AS total_warehouses,
    ROUND(AVG(wh_breakdown_l3m), 2) AS avg_breakdowns,
    ROUND(AVG(storage_issue_reported_l3m), 2) AS avg_storage_issues,
    COUNT(*) FILTER (
        WHERE wh_breakdown_l3m = 0
    ) AS zero_breakdown_warehouses
FROM staging.fmcg_warehouse_raw
WHERE wh_capacity_size = 'Small'
GROUP BY
    wh_capacity_size,
    approved_wh_govt_certificate
ORDER BY
    CASE approved_wh_govt_certificate
        WHEN 'A+' THEN 1
        WHEN 'A' THEN 2
        WHEN 'B+' THEN 3
        WHEN 'B' THEN 4
        WHEN 'C' THEN 5
        ELSE 6
    END;


SELECT
    num_refill_req_l3m AS refill_requests,
    COUNT(*) AS warehouse_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS warehouse_percentage,
    ROUND(
        AVG(storage_issue_reported_l3m),
        2
    ) AS avg_storage_issues,
    ROUND(
        AVG(wh_breakdown_l3m),
        2
    ) AS avg_breakdowns
FROM staging.fmcg_warehouse_raw
GROUP BY num_refill_req_l3m
ORDER BY refill_requests;

SELECT
    num_refill_req_l3m AS refill_requests,
    COUNT(*) AS warehouse_count,
    ROUND(
        AVG(transport_issue_l1y),
        2
    ) AS avg_transport_issues,
    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS warehouses_with_transport_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS transport_issue_rate_pct
FROM staging.fmcg_warehouse_raw
GROUP BY num_refill_req_l3m
ORDER BY refill_requests;


SELECT
    wh_capacity_size,
    num_refill_req_l3m AS refill_requests,
    COUNT(*) AS warehouse_count,
    ROUND(
        AVG(transport_issue_l1y),
        2
    ) AS avg_transport_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS transport_issue_rate_pct
FROM staging.fmcg_warehouse_raw
GROUP BY
    wh_capacity_size,
    num_refill_req_l3m
ORDER BY
    CASE wh_capacity_size
        WHEN 'Small' THEN 1
        WHEN 'Mid' THEN 2
        WHEN 'Large' THEN 3
        ELSE 4
    END,
    refill_requests;


SELECT
    flood_impacted,
    flood_proof,
    COUNT(*) AS warehouse_count,
    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS warehouses_with_transport_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS transport_issue_rate_pct,
    ROUND(
        AVG(transport_issue_l1y),
        2
    ) AS avg_transport_issues
FROM staging.fmcg_warehouse_raw
GROUP BY
    flood_impacted,
    flood_proof
ORDER BY
    flood_impacted,
    flood_proof;


SELECT
    flood_impacted,
    flood_proof,
    COUNT(*) AS warehouse_count,
    ROUND(
        AVG(storage_issue_reported_l3m),
        2
    ) AS avg_storage_issues,
    ROUND(
        AVG(wh_breakdown_l3m),
        2
    ) AS avg_breakdowns,
    COUNT(*) FILTER (
        WHERE storage_issue_reported_l3m > 0
    ) AS warehouses_with_storage_issues
FROM staging.fmcg_warehouse_raw
GROUP BY
    flood_impacted,
    flood_proof
ORDER BY
    flood_impacted,
    flood_proof;



SELECT
    flood_impacted,
    flood_proof,
    COUNT(*) AS warehouse_count,
    COUNT(*) FILTER (
        WHERE storage_issue_reported_l3m > 0
    ) AS warehouses_with_storage_issues,
    ROUND(
        COUNT(*) FILTER (
            WHERE storage_issue_reported_l3m > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS storage_issue_rate_pct
FROM staging.fmcg_warehouse_raw
GROUP BY
    flood_impacted,
    flood_proof
ORDER BY
    flood_impacted,
    flood_proof;


SELECT
    COUNT(*) AS total_warehouses,

    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS warehouses_with_transport_issues,

    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / COUNT(*),
        2
    ) AS transport_issue_rate_pct,

    ROUND(
        AVG(storage_issue_reported_l3m),
        2
    ) AS avg_storage_issues,

    ROUND(
        AVG(wh_breakdown_l3m),
        2
    ) AS avg_breakdowns,

    COUNT(*) FILTER (
        WHERE temp_reg_mach = 1
    ) AS warehouses_with_temp_regulation,

    COUNT(*) FILTER (
        WHERE electric_supply = 0
    ) AS warehouses_without_recorded_electricity

FROM staging.fmcg_warehouse_raw;



CREATE OR REPLACE VIEW staging.vw_warehouse_baseline_kpis AS
SELECT
    COUNT(*) AS total_warehouses,

    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS warehouses_with_transport_issues,

    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS transport_issue_rate_pct,

    ROUND(AVG(storage_issue_reported_l3m), 2)
        AS avg_storage_issues,

    ROUND(AVG(wh_breakdown_l3m), 2)
        AS avg_breakdowns,

    COUNT(*) FILTER (
        WHERE temp_reg_mach = 1
    ) AS warehouses_with_temp_regulation,

    ROUND(
        COUNT(*) FILTER (
            WHERE temp_reg_mach = 1
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS temp_regulation_coverage_pct,

    COUNT(*) FILTER (
        WHERE electric_supply = 0
    ) AS warehouses_without_recorded_electricity,

    ROUND(
        COUNT(*) FILTER (
            WHERE electric_supply = 0
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS no_recorded_electricity_pct

FROM staging.fmcg_warehouse_raw;

SELECT * FROM staging.vw_warehouse_baseline_kpis;


CREATE OR REPLACE VIEW staging.vw_warehouse_segment_kpis AS
SELECT
    wh_capacity_size,
    zone,
    wh_owner_type,

    COUNT(*) AS warehouse_count,

    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS transport_issue_rate_pct,

    ROUND(
        AVG(transport_issue_l1y),
        2
    ) AS avg_transport_issues,

    ROUND(
        AVG(storage_issue_reported_l3m),
        2
    ) AS avg_storage_issues,

    ROUND(
        AVG(wh_breakdown_l3m),
        2
    ) AS avg_breakdowns,

    ROUND(
        COUNT(*) FILTER (
            WHERE electric_supply = 0
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS no_recorded_electricity_pct,

    ROUND(
        COUNT(*) FILTER (
            WHERE temp_reg_mach = 1
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS temp_regulation_coverage_pct

FROM staging.fmcg_warehouse_raw
GROUP BY
    wh_capacity_size,
    zone,
    wh_owner_type;

SELECT *
FROM staging.vw_warehouse_segment_kpis
ORDER BY
    wh_capacity_size,
    zone,
    wh_owner_type;

CREATE OR REPLACE VIEW staging.vw_transport_priority AS
SELECT
    wh_capacity_size,
    zone,
    wh_owner_type,
    warehouse_count,
    transport_issue_rate_pct,
    avg_transport_issues,
    no_recorded_electricity_pct,
    CASE
        WHEN warehouse_count < 100 THEN 'Small sample'
        WHEN transport_issue_rate_pct >= 42 THEN 'High issue rate'
        WHEN transport_issue_rate_pct >= 40 THEN 'Elevated issue rate'
        ELSE 'Lower relative issue rate'
    END AS investigation_priority
FROM staging.vw_warehouse_segment_kpis;

SELECT *
FROM staging.vw_transport_priority
ORDER BY
    CASE investigation_priority
        WHEN 'High issue rate' THEN 1
        WHEN 'Elevated issue rate' THEN 2
        WHEN 'Small sample' THEN 3
        ELSE 4
    END,
    transport_issue_rate_pct DESC;


SELECT
    wh_capacity_size,
    zone,
    wh_owner_type,
    COUNT(*) AS warehouse_count,
    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS affected_warehouses,
    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS transport_issue_rate_pct
FROM staging.fmcg_warehouse_raw
GROUP BY
    wh_capacity_size,
    zone,
    wh_owner_type
HAVING COUNT(*) >= 100
ORDER BY
    wh_capacity_size,
    zone,
    wh_owner_type;

WITH ownership_comparison AS (
    SELECT
        wh_capacity_size,
        zone,
        COUNT(*) FILTER (
            WHERE wh_owner_type = 'Company Owned'
        ) AS company_owned_count,
        COUNT(*) FILTER (
            WHERE wh_owner_type = 'Rented'
        ) AS rented_count,
        COUNT(*) FILTER (
            WHERE wh_owner_type = 'Company Owned'
              AND transport_issue_l1y > 0
        ) AS company_owned_affected,
        COUNT(*) FILTER (
            WHERE wh_owner_type = 'Rented'
              AND transport_issue_l1y > 0
        ) AS rented_affected
    FROM staging.fmcg_warehouse_raw
    GROUP BY wh_capacity_size, zone
)
SELECT
    wh_capacity_size,
    zone,
    company_owned_count,
    rented_count,
    ROUND(
        company_owned_affected * 100.0
        / NULLIF(company_owned_count, 0), 2
    ) AS company_owned_issue_rate_pct,
    ROUND(
        rented_affected * 100.0
        / NULLIF(rented_count, 0), 2
    ) AS rented_issue_rate_pct,
    ROUND(
        rented_affected * 100.0
        / NULLIF(rented_count, 0)
        - company_owned_affected * 100.0
        / NULLIF(company_owned_count, 0), 2
    ) AS rented_minus_company_pp
FROM ownership_comparison
WHERE company_owned_count >= 100
  AND rented_count >= 100
ORDER BY rented_minus_company_pp DESC;


CREATE OR REPLACE VIEW staging.vw_warehouse_dashboard_kpis AS
SELECT
    COUNT(*) AS total_warehouses,

    COUNT(*) FILTER (
        WHERE transport_issue_l1y > 0
    ) AS warehouses_with_transport_issues,

    ROUND(
        COUNT(*) FILTER (
            WHERE transport_issue_l1y > 0
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS transport_issue_rate_pct,

    ROUND(AVG(transport_issue_l1y), 2)
        AS avg_transport_issues_per_warehouse,

    ROUND(AVG(storage_issue_reported_l3m), 2)
        AS avg_storage_issues_per_warehouse,

    ROUND(AVG(wh_breakdown_l3m), 2)
        AS avg_breakdowns_per_warehouse,

    COUNT(*) FILTER (
        WHERE electric_supply = 0
    ) AS warehouses_without_recorded_electricity,

    ROUND(
        COUNT(*) FILTER (
            WHERE electric_supply = 0
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS no_recorded_electricity_pct,

    COUNT(*) FILTER (
        WHERE temp_reg_mach = 1
    ) AS warehouses_with_temp_regulation,

    ROUND(
        COUNT(*) FILTER (
            WHERE temp_reg_mach = 1
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS temp_regulation_coverage_pct

FROM staging.fmcg_warehouse_raw;

SELECT *
FROM staging.vw_transport_priority
order by wh_capacity_size asc;


