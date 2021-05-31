select distinct p.url
--, swift_version, b.status
from packages p
join versions v on v.package_id = p.id
join builds b on b.version_id = v.id
where v.latest is not null
and 
	(swift_version->>'major' = '5' and swift_version->>'minor' = '2'
	or swift_version->>'major' = '5' and swift_version->>'minor' = '3'
	or swift_version->>'major' = '5' and swift_version->>'minor' = '4'
	)
and b.status = 'ok'
;


select distinct p.url
--, swift_version, b.status
from packages p
join versions v on v.package_id = p.id
join builds b on b.version_id = v.id
where v.latest is not null
and swift_version->>'major' = '5' and swift_version->>'minor' = '0'
and b.status = 'ok'
;