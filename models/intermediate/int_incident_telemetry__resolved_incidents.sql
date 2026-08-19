with incidents as (

    select
        incident_number,
        opened_ts,
        resolved_ts,
        minutes_to_resolve,
        incident_severity,
        assignment_group,
        cmdb_ci_clean

    from {{ ref('stg_ens__incident') }}

    where incident_severity in ('S1', 'S2')

),

devices as (

    select
        device_id,
        hostname,
        site_code

    from {{ ref('stg_ens__device') }}

),

resolved_incidents as (

    select
        incidents.incident_number,
        incidents.opened_ts,
        incidents.resolved_ts,
        incidents.minutes_to_resolve,
        incidents.incident_severity,
        incidents.assignment_group,
        devices.device_id,
        devices.site_code

    from incidents

    inner join devices
        on incidents.cmdb_ci_clean = devices.hostname

)

select * from resolved_incidents
