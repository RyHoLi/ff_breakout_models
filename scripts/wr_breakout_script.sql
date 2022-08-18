drop table wr_breakout_data;
create table wr_breakout_data as 
select
	t1.player_id
	, t1.name
	, t1.age
	, t1.draft_round
	, t1.draft_pick
	, t1.height
	, t1.weight
	, t1.season
	, t2.season as pred_season
	, CASE WHEN t1.completions IS NULL THEN 0 ELSE t1.completions END AS completions
	, CASE WHEN t1.targets IS NULL THEN 0 ELSE t1.targets END AS targets
	, CASE WHEN t1.receiving_yards IS NULL THEN 0 ELSE t1.receiving_yards END AS receiving_yards
	, CASE WHEN t1.receiving_tds IS NULL THEN 0 ELSE t1.receiving_tds END AS receiving_tds
	, CASE WHEN t1.adot IS NULL THEN 0 ELSE t1.adot END AS adot
	, CASE WHEN t1.receiving_yac IS NULL THEN 0 ELSE t1.receiving_yac END AS receiving_yac
	, CASE WHEN t1.firstdowns_per_tgt IS NULL THEN 0 ELSE t1.firstdowns_per_tgt END AS firstdowns_per_tgt
	, CASE WHEN t1.carries IS NULL THEN 0 ELSE t1.carries END AS carries
	, CASE WHEN t1.rushing_yards IS NULL THEN 0 ELSE t1.rushing_yards END AS rushing_yards
	, CASE WHEN t1.rushing_tds IS NULL THEN 0 ELSE t1.rushing_tds END AS rushing_tds
	, CASE WHEN t1.rushing_first_downs IS NULL THEN 0 ELSE t1.rushing_first_downs END AS rushing_first_downs
	, CASE WHEN t1.rushing_epa IS NULL THEN 0 ELSE t1.rushing_epa END AS rushing_epa
	, CASE WHEN t1.tgt_sh IS NULL THEN 0 ELSE t1.tgt_sh END AS tgt_sh
 	, CASE WHEN t1.ay_sh IS NULL THEN 0 ELSE t1.ay_sh END AS ay_sh
 	, CASE WHEN t1.yac_sh IS NULL THEN 0 ELSE t1.yac_sh END AS yac_sh
 	, CASE WHEN t1.wopr_y IS NULL THEN 0 ELSE t1.wopr_y END AS wopr_y
 	, CASE WHEN t1.rtd_sh IS NULL THEN 0 ELSE t1.rtd_sh END AS rtd_sh
 	, CASE WHEN t1.rfd_sh IS NULL THEN 0 ELSE t1.rfd_sh END AS rfd_sh
 	, CASE WHEN t1.rtdfd_sh IS NULL THEN 0 ELSE t1.rtdfd_sh END AS rtdfd_sh
 	, CASE WHEN t1.dom IS NULL THEN 0 ELSE t1.dom END AS dom
 	, CASE WHEN t1.w8dom IS NULL THEN 0 ELSE t1.w8dom END AS w8dom
 	, CASE WHEN t1.yptmpa IS NULL THEN 0 ELSE t1.yptmpa END AS yptmpa
 	, CASE WHEN t1.ppr_sh IS NULL THEN 0 ELSE t1.ppr_sh END AS ppr_sh
	, t1.fantasy_points_ppr
	, t2.fantasy_points_ppr as pred_fantasy_points
	, ((t2.fantasy_points_ppr - t1.fantasy_points_ppr) / NULLIF(t1.fantasy_points_ppr,0)::FLOAT)::DECIMAL(5,2) AS pct_increase
	, CASE WHEN ((t2.fantasy_points_ppr - t1.fantasy_points_ppr) / NULLIF(t1.fantasy_points_ppr,0)::FLOAT)::DECIMAL(5,2) >= .25
	AND t2.fantasy_points_ppr >= 10 AND t2.targets > 10 THEN 1 ELSE 0 END AS breakout
FROM 
(select
	a.player_id
	, b.name
	, CASE 
		WHEN a.season = 2021 THEN (EXTRACT(year from '2021-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2020 THEN (EXTRACT(year from '2020-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2019 THEN (EXTRACT(year from '2019-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2018 THEN (EXTRACT(year from '2018-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2017 THEN (EXTRACT(year from '2017-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2016 THEN (EXTRACT(year from '2016-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
        WHEN a.season = 2015 THEN (EXTRACT(year from '2015-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2014 THEN (EXTRACT(year from '2014-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2013 THEN (EXTRACT(year from '2013-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2012 THEN (EXTRACT(year from '2012-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2011 THEN (EXTRACT(year from '2011-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2010 THEN (EXTRACT(year from '2010-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2009 THEN (EXTRACT(year from '2009-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2008 THEN (EXTRACT(year from '2008-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2007 THEN (EXTRACT(year from '2007-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2006 THEN (EXTRACT(year from '2006-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2005 THEN (EXTRACT(year from '2005-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
        ELSE 0
			  END AS age
	, CASE WHEN b.draft_round IS NULL then 8 ELSE b.draft_round END AS draft_round
	, CASE WHEN b.draft_pick IS NULL THEN 32 ELSE b.draft_pick END AS draft_pick
	, b.height
	, b.weight
	, a.season
 	, c.gp
	, (receptions::float / NULLIF(targets,0))::DECIMAL(5,2) AS completions
	, targets
	, (receiving_yards::float / NULLIF(targets,0))::DECIMAL(5,2) AS receiving_yards
	, (receiving_tds::float / NULLIF(targets,0))::DECIMAL(5,2) AS receiving_tds	
	, (receiving_air_yards::float / NULLIF(targets,0))::DECIMAL(5,2) AS adot
	, (receiving_yards_after_catch::float / NULLIF(targets,0))::DECIMAL(5,2) AS receiving_yac
	, (receiving_first_downs::float / NULLIF(targets,0))::DECIMAL(5,2) AS firstdowns_per_tgt	
	, carries
	, (rushing_yards::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_yards
	, (rushing_tds::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_tds
	, (rushing_first_downs::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_first_downs
	, (rushing_epa::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_epa	
	, tgt_sh
 	, ay_sh
 	, yac_sh
 	, wopr_y
 	, rtd_sh
 	, rfd_sh
 	, rtdfd_sh
 	, dom
 	, w8dom
 	, yptmpa
 	, ppr_sh
	, (fantasy_points_ppr::float / NULLIF(gp,0))::DECIMAL(5,2) AS fantasy_points_ppr
FROM nfl_seasonal a
JOIN player_mapping b ON (a.player_id = b.gsis_id)
JOIN (SELECT player_id, season, COUNT(*) as gp FROM nfl_weekly WHERE targets >= 1 GROUP BY 1,2) c 
ON (a.player_id = c.player_id AND a.season = c.season )
WHERE b.position = 'WR') t1
LEFT JOIN 
(select
	a.player_id
	, b.name
	, CASE 
		WHEN a.season = 2021 THEN (EXTRACT(year from '2021-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2020 THEN (EXTRACT(year from '2020-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2019 THEN (EXTRACT(year from '2019-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
		WHEN a.season = 2018 THEN (EXTRACT(year from '2018-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2017 THEN (EXTRACT(year from '2017-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2016 THEN (EXTRACT(year from '2016-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
        WHEN a.season = 2015 THEN (EXTRACT(year from '2015-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2014 THEN (EXTRACT(year from '2014-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2013 THEN (EXTRACT(year from '2013-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2012 THEN (EXTRACT(year from '2012-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2011 THEN (EXTRACT(year from '2011-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2010 THEN (EXTRACT(year from '2010-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2009 THEN (EXTRACT(year from '2009-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2008 THEN (EXTRACT(year from '2008-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2007 THEN (EXTRACT(year from '2007-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2006 THEN (EXTRACT(year from '2006-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
 		WHEN a.season = 2005 THEN (EXTRACT(year from '2005-09-01'::DATE) - EXTRACT(year from b.birthdate::DATE))::int
        ELSE 0
			  END AS age
	, CASE WHEN b.draft_round IS NULL then 8 ELSE b.draft_round END AS draft_round
	, CASE WHEN b.draft_pick IS NULL THEN 32 ELSE b.draft_pick END AS draft_pick
	, b.height
	, b.weight
	, a.season
 	, c.gp
	, (receptions::float / NULLIF(targets,0))::DECIMAL(5,2) AS completions
	, targets
	, (receiving_yards::float / NULLIF(targets,0))::DECIMAL(5,2) AS receiving_yards
	, (receiving_tds::float / NULLIF(targets,0))::DECIMAL(5,2) AS receiving_tds	
	, (receiving_air_yards::float / NULLIF(targets,0))::DECIMAL(5,2) AS adot
	, (receiving_yards_after_catch::float / NULLIF(targets,0))::DECIMAL(5,2) AS receiving_yac
	, (receiving_first_downs::float / NULLIF(targets,0))::DECIMAL(5,2) AS firstdowns_per_tgt	
	, carries
	, (rushing_yards::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_yards
	, (rushing_tds::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_tds
	, (rushing_first_downs::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_first_downs
	, (rushing_epa::float / NULLIF(carries,0))::DECIMAL(5,2) AS rushing_epa	
	, tgt_sh
 	, ay_sh
 	, yac_sh
 	, wopr_y
 	, rtd_sh
 	, rfd_sh
 	, rtdfd_sh
 	, dom
 	, w8dom
 	, yptmpa
 	, ppr_sh
	, (fantasy_points_ppr::float / NULLIF(gp,0))::DECIMAL(5,2) AS fantasy_points_ppr
FROM nfl_seasonal a
JOIN player_mapping b ON (a.player_id = b.gsis_id)
JOIN (SELECT player_id, season, COUNT(*) as gp FROM nfl_weekly WHERE targets >= 1 GROUP BY 1,2) c 
ON (a.player_id = c.player_id AND a.season = c.season )
WHERE b.position = 'WR') t2 
ON (t1.player_id = t2.player_id
AND t1.season = t2.season - 1);

COPY wr_breakout_data TO 'C:/Users/Ryan/Documents/nfl_models/breakout_players/data/wr_breakout_data.csv' csv header;