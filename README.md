# A docker container for developing and testing custom Home Assistant plugins and integrations

## Usage

```
docker run --rm -it \
    -p 5000:8123 \
    -v $(pwd):/workspaces/test \
    -v $(pwd):/config/www/workspace \
    -e LOVELACE_LOCAL_FILES="myplugin.js"
    -e LOVELACE_PLUGINS="thomasloven/lovelace-card-mod thomasloven/lovelace-auto-entities custom-cards/button-card" \
    thomasloven/hass-custom-devcontainer
```

The default action of the image is to run `container`, which will
- Make sure there's a basic Home Assistant configuration in `/config`
- Add a default admin user to Home Assistant
- Skip the onboarding procedure
- Download and install [HACS](https://hacs.xyz)
- Download lovelace plugins from github
- Add plugins to lovelace configuration
- Start Home Assistant with `-v`


### Environment Variables

| Name | Description | Default |
|---|---|---|
| `HASS_USERNAME` | The username of the default user | `dev` |
| `HASS_PASSWORD` | The password of the default user | `dev` |
| `LOVELACE_PLUGINS` | List of lovelac plugins to download from github | Empty |
| `LOVELACE_LOCAL_FILES` | List of filenames in `/config/www/workspace` to add as lovelace resources | Emtpy |

### About Lovelace Plugins
The dowload and install of plugins is *very* basic. This is not HACS.

`LOVELACE_PLUGINS` should be a space separated list of author/repo pairs, e.g. `"thomasloven/lovelace-card-mod  kalkih/mini-media-player"`

`LOVELACE_LOCAL_FILES` is for the currently worked on plugins and should be a list of file names which are mounted in `/config/www/workspace`.

### Container Script

```bash
container
```
Set up and launch Home Assistant

```bash
container setup
```
Perform download and setup parts but do not launch Home Assistant

```bash
container launch
```
Launch Home Assistant with `hass -c /config -v`

## devcontainer.json example

```json
{
  "image": "thomasloven/hass-custom-devcontainer",
  "postCreateCommand": "container setup && npm add",
  "forwardPorts": [8123],
  "mounts": [
    "source=${localWorkspaceFolder},target=/config/www/workspace,type=bind",
    "source=${localWorkspaceFolder}/test,target=/config/test,type=bind",
    "source=${localWorkspaceFolder}/test/configuration.yaml,target=/config/configuration.yaml,type=bind"
  ],
  "runArgs": ["--env-file", "${localWorkspaceFolder}/test/.env"]
}
```