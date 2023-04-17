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
  concept.id,
  concept.display_name,
  COUNTIF(gold) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_gold,
  COUNTIF(diamond) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_diamond,
  COUNTIF(hybrid) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_hybrid,
  COUNTIF(green) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_green,
  COUNTIF(bronze) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_bronze,
  COUNTIF(closed) / COUNT(DISTINCT academic_observatory.doi) * 100 as pc_closed,

FROM
  paic_oa_status as oa
  LEFT JOIN `academic-observatory.observatory.doi20230325` as academic_observatory on academic_observatory.doi = oa.doi
  , UNNEST(academic_observatory.openalex.concepts) as concept

WHERE concept.level = 0
GROUP BY concept.display_name, concept.id
ORDER BY concept.id