
drop table te_breakout_data;
create table te_breakout_data as 
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
	, t1.completions
	, t1.targets
	, t1.receiving_yards_yards
	, t1.receiving_tds	
	, t1.adot
	, t1.receiving_yac
	, t1.firstdowns_per_tgt
	, t1.carries
	, t1.rushing_yards
	, t1.rushing_tds
	, t1.rushing_first_downs
	, t1.rushing_epa	
	, t1.tgt_sh
 	, t1.ay_sh
 	, t1.yac_sh
 	, t1.wopr_y
 	, t1.rtd_sh
 	, t1.rfd_sh
 	, t1.rtdfd_sh
 	, t1.dom
 	, t1.w8dom
 	, t1.yptmpa
 	, t1.ppr_sh
	, t1.fantasy_points_ppr
	, t2.fantasy_points_ppr as pred_fantasy_points
	, ((t2.fantasy_points_ppr - t1.fantasy_points_ppr) / NULLIF(t1.fantasy_points_ppr,0)::FLOAT)::DECIMAL(5,2) AS pct_increase
	, CASE WHEN (((t2.fantasy_points_ppr - t1.fantasy_points_ppr) / NULLIF(t1.fantasy_points_ppr,0)::FLOAT)::DECIMAL(5,2) >= .3
	OR t2.fantasy_points_ppr >= 14) AND t2.targets > 10 THEN 1 ELSE 0 END AS breakout
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
	, b.draft_round
	, b.draft_pick
	, b.height
	, b.weight
	, a.season
 	, c.gp
	, (receptions::float / NULLIF(targets,0))::DECIMAL(5,2) AS completions
	, targets
	, (receiving_yards::float / NULLIF(targets,0))::DECIMAL(5,2) AS receiving_yards_yards
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
WHERE b.position = 'TE') t1
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
	, b.draft_round
	, b.draft_pick
	, b.height
	, b.weight
	, a.season
 	, c.gp
	, (receptions::float / NULLIF(targets,0))::DECIMAL(5,2) AS completions
	, targets
	, (receiving_yards::float / NULLIF(targets,0))::DECIMAL(5,2) AS receiving_yards_yards
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
WHERE b.position = 'TE') t2 
ON (t1.player_id = t2.player_id
AND t1.season = t2.season - 1);

COPY te_breakout_data TO 'C:/Users/Ryan/Documents/nfl_models/breakout_players/data/te_breakout_data.csv' csv header;