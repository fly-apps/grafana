FROM grafana/grafana:8.2.2

USER root 

ENTRYPOINT ["/run.sh"]