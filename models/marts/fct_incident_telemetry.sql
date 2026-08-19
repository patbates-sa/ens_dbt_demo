with resolved_incidents as (

    select * from {{ ref('int_incident_telemetry__resolved_incidents') }}

),

interface_metrics as (

    select * from {{ ref('int_incident_telemetry__interface_metrics_1h') }}

),

incident_telemetry as (

    select
        resolved_incidents.incident_number,
        resolved_incidents.opened_ts,
        resolved_incidents.resolved_ts,
        resolved_incidents.incident_severity as severity,
        resolved_incidents.assignment_group,
        resolved_incidents.device_id,
        resolved_incidents.site_code,
        interface_metrics.avg_util_out,
        interface_metrics.peak_util_out,
        interface_metrics.errors,
        interface_metrics.peak_latency_p95,
        interface_metrics.peak_loss,
        interface_metrics.failed_polls,
        resolved_incidents.minutes_to_resolve

    from resolved_incidents

    left join interface_metrics
        on resolved_incidents.incident_number = interface_metrics.incident_number

)

select * from incident_telemetry
