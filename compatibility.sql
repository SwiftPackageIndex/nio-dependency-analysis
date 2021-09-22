-- 5.2+
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

-- 5.4
select distinct p.url
from packages p
join versions v on v.package_id = p.id
join builds b on b.version_id = v.id
where v.latest is not null
and swift_version->>'major' = '5' and swift_version->>'minor' = '4'
and b.status = 'ok'
;

-- 5.3
select distinct p.url
from packages p
join versions v on v.package_id = p.id
join builds b on b.version_id = v.id
where v.latest is not null
and swift_version->>'major' = '5' and swift_version->>'minor' = '3'
and b.status = 'ok'
;

-- 5.2
select distinct p.url
from packages p
join versions v on v.package_id = p.id
join builds b on b.version_id = v.id
where v.latest is not null
and swift_version->>'major' = '5' and swift_version->>'minor' = '2'
and b.status = 'ok'
;

-- 5.1
select distinct p.url
from packages p
join versions v on v.package_id = p.id
join builds b on b.version_id = v.id
where v.latest is not null
and swift_version->>'major' = '5' and swift_version->>'minor' = '1'
and b.status = 'ok'
;

-- 5.0
select distinct p.url
from packages p
join versions v on v.package_id = p.id
join builds b on b.version_id = v.id
where v.latest is not null
and swift_version->>'major' = '5' and swift_version->>'minor' = '0'
and b.status = 'ok'
;
