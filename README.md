```
➜ flyctl apps create grafana-example

Selected App Name: grafana-example

? Select organization: Demo Sandbox (demo-sandbox)

? Select builder: Image
    (Use a public Docker image)
? Select Image: grafana/grafana

? Select Internal Port: 3000

New app created
  Name         = grafana-example
  Organization = demo-sandbox
  Version      = 0
  Status       =
  Hostname     = <empty>

Wrote config file fly.toml
➜  grafana code .
```

```
➜ flyctl volumes create grafana_storage --region ord
      Name: grafana_storage
    Region: ord
   Size GB: 10
Created at: 02 Nov 20 19:55 UTC
```

Edit `fly.toml` to add mount information. Grafana defaults to `/var/lib/grafana` for persistence, so we can just mount it directly.
```toml
[mount]
source = "grafana_storage"
destination = "/var/lib/grafana"
```

#### Deploy

This is all you need, just run `flyctl deploy` and watch what happens.

Once that's done, run `flyctl open` to launch the Grafana UI in your browser. Grafana defaults to `admin` for both username and password, enter those, change the password, and you're set.

#### Plugins

Grafana has a number of interesting plugins, like the [Worldmap Panel](https://grafana.com/grafana/plugins/grafana-worldmap-panel). The Grafana Docker image will install plugins from an environment variable. You can configure environment variables in `fly.toml` like so:

```toml
[env]
GF_INSTALL_PLUGINS = "grafana-worldmap-panel,grafana-clock-panel"
```

Run a quick `flyctl deploy`, check the logs, and you'll see messages like this:

```
2020-11-04T22:41:08.458Z ecb06e0a ord [info] installing grafana-worldmap-panel @ 0.3.2
2020-11-04T22:41:08.460Z ecb06e0a ord [info] from: https://grafana.com/api/plugins/grafana-worldmap-panel/versions/0.3.2/download
2020-11-04T22:41:08.461Z ecb06e0a ord [info] into: /var/lib/grafana/plugins
2020-11-04T22:41:08.928Z ecb06e0a ord [info] ✔ Installed grafana-worldmap-panel successfully
2020-11-04T22:41:08.930Z ecb06e0a ord [info] Restart grafana after installing plugins . <service grafana-server restart>
2020-11-04T22:41:09.011Z ecb06e0a ord [info] installing grafana-clock-panel @ 1.1.1
2020-11-04T22:41:09.012Z ecb06e0a ord [info] from: https://grafana.com/api/plugins/grafana-clock-panel/versions/1.1.1/download
2020-11-04T22:41:09.013Z ecb06e0a ord [info] into: /var/lib/grafana/plugins
2020-11-04T22:41:09.302Z ecb06e0a ord [info] ✔ Installed grafana-clock-panel successfully
2020-11-04T22:41:09.303Z ecb06e0a ord [info] Restart grafana after installing plugins . <service grafana-server restart>
```