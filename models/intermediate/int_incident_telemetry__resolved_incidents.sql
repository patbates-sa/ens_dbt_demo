with incidents as (

    select * from {{ ref('stg_ens__incident') }}

),

devices as (

    select * from {{ ref('stg_ens__device') }}

),

resolved_incidents as (

    select
        incidents.incident_number,
        incidents.opened_ts,
        incidents.resolved_ts,
        incidents.incident_severity as severity,
        incidents.assignment_group,
        devices.device_id,
        devices.site_code,
        incidents.minutes_to_resolve

    from incidents
    inner join devices
        on incidents.cmdb_ci_clean = devices.hostname

    where incidents.incident_severity in ('S1', 'S2')

)

select * from resolved_incidents
