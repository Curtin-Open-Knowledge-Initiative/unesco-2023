SELECT
  COUNT(DISTINCT doi) as works,
  repos.coki_repository_name as coki_repository_name,
  MAX(repos.url) as url,
  MAX(ror.id) as ror,
  MAX(ror.country.country_name) as country,
  MAX(ror.country.country_code) as country_code

  FROM `academic-observatory.observatory.doi20230325`,
  UNNEST(coki.repositories) as repos,
  UNNEST(repos.rors) as rors
  LEFT JOIN `academic-observatory.ror.ror20230330` as ror on rors.id = ror.id

GROUP BY repos.coki_repository_name
ORDER BY works DESC

