with resolved_incidents as (

    select * from {{ ref('int_incident_telemetry__resolved_incidents') }}

),

monitored_interfaces as (

    select
        interface_id,
        device_id

    from {{ ref('stg_ens__interface') }}

    where is_monitored

),

interface_metrics as (

    select
        interface_id,
        metric_ts,
        utilization_pct_out,
        in_errors,
        out_errors,
        latency_ms_p95,
        packet_loss_pct,
        is_successful_poll

    from {{ ref('stg_ens__interface_metric_5m') }}

),

incident_metrics as (

    select
        resolved_incidents.incident_number,
        avg(interface_metrics.utilization_pct_out) as avg_util_out,
        max(interface_metrics.utilization_pct_out) as peak_util_out,
        sum(interface_metrics.in_errors + interface_metrics.out_errors) as errors,
        max(interface_metrics.latency_ms_p95) as peak_latency_p95,
        max(interface_metrics.packet_loss_pct) as peak_loss,
        count_if(not interface_metrics.is_successful_poll) as failed_polls

    from resolved_incidents

    inner join monitored_interfaces
        on resolved_incidents.device_id = monitored_interfaces.device_id

    inner join interface_metrics
        on monitored_interfaces.interface_id = interface_metrics.interface_id
        and interface_metrics.metric_ts >= dateadd('hour', -1, resolved_incidents.opened_ts)
        and interface_metrics.metric_ts < resolved_incidents.opened_ts

    group by 1

)

select * from incident_metrics
