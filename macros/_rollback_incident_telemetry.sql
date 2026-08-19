{% macro rollback_incident_telemetry_relations() %}

    {% set relation_specs = [
        {
            'database': 'ENS_SANDBOX',
            'schema': 'DBT_DEMO_DEV_INTERMEDIATE',
            'identifier': 'INT_INCIDENT_TELEMETRY__RESOLVED_INCIDENTS'
        },
        {
            'database': 'ENS_SANDBOX',
            'schema': 'DBT_DEMO_DEV_INTERMEDIATE',
            'identifier': 'INT_INCIDENT_TELEMETRY__INTERFACE_METRICS_1H'
        },
        {
            'database': 'ENS_SANDBOX',
            'schema': 'DBT_DEMO_DEV_MARTS',
            'identifier': 'FCT_INCIDENT_TELEMETRY'
        }
    ] %}

    {% for relation_spec in relation_specs %}
        {% set relation = adapter.get_relation(
            database=relation_spec['database'],
            schema=relation_spec['schema'],
            identifier=relation_spec['identifier']
        ) %}

        {% if relation is not none %}
            {% do adapter.drop_relation(relation) %}
            {% do log('Dropped ' ~ relation, info=true) %}
        {% endif %}
    {% endfor %}

{% endmacro %}
