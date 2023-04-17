WITH paic_oa_status AS (
  SELECT
    doi,
    academic_observatory.coki.oa_color.gold_just_doaj AND (doaj.apc != FALSE) as gold,
    academic_observatory.coki.oa_color.gold_just_doaj AND (doaj.apc = FALSE) as diamond,
    academic_observatory.coki.oa_color.hybrid as hybrid,
    academic_observatory.coki.oa_color.green_only as green,
    academic_observatory.coki.oa_color.bronze as bronze,
    academic_observatory.coki.oa_coki.closed as closed,
    academic_observatory.coki.oa_coki.open as open

    FROM

      `academic-observatory.observatory.doi20230325` as academic_observatory
      LEFT JOIN `utrecht-university.doaj.apc_issnl_20220427` as doaj on doaj.journal_issn_l = academic_observatory.unpaywall.journal_issn_l

    WHERE crossref.published_year > 2009 and crossref.published_year < 2023
),
  doi_sdgs AS (
    SELECT * FROM `coki-scratch-space.curtin.doi_sdgs`
    UNPIVOT(status FOR sdg IN (
        sdg_1_no_poverty,
        sdg_2_zero_hunger,
        sdg_3_health_well_being,
        sdg_4_quality_education,
        sdg_5_gender_equality,
        sdg_6_clean_water,
        sdg_7_clean_energy,
        sdg_8_decent_work,
        sdg_9_infrastructure_innovation,
        sdg_10_reduced_inequalities,
        sdg_11_sustainable_cities,
        sdg_12_responsible_consumption,
        sdg_13_climate_action,
        sdg_14_life_below_water,
        sdg_15_life_on_land,
        sdg_16_peace_institutions,
        sdg_17_partnerships
        ))
    )
SELECT
  sdgs.sdg,
  COUNTIF(gold) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_gold,
  COUNTIF(diamond) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_diamond,
  COUNTIF(hybrid) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_hybrid,
  COUNTIF(green) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_green,
  COUNTIF(bronze) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_bronze,
  COUNTIF(closed) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_closed,
  COUNTIF(gold) as gold,
  COUNTIF(diamond) as diamond,
  COUNTIF(hybrid) as hybrid,
  COUNTIF(green) as green,
  COUNTIF(bronze) as bronze,
  COUNTIF(closed) closed,

FROM
  paic_oa_status as oa
  LEFT JOIN `academic-observatory.observatory.doi20230325` as academic_observatory on academic_observatory.doi = oa.doi
  LEFT JOIN doi_sdgs as sdgs on sdgs.doi = academic_observatory.doi

WHERE sdgs.status = TRUE
GROUP BY sdgs.sdg
ORDER BY sdgs.sdg