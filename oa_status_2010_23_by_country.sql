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
    )

SELECT
  aff.name,
  aff.identifier,
  COUNT(DISTINCT academic_observatory.doi) as country_count,
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
  COUNTIF(closed) as closed,

FROM
  paic_oa_status as oa
  LEFT JOIN `academic-observatory.observatory.doi20230325` as academic_observatory on academic_observatory.doi = oa.doi
  , UNNEST(affiliations.countries) as aff

GROUP BY aff.name, aff.identifier
ORDER BY aff.name ASC
