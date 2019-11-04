# Tupile

## Approach / Result

- Elixir
- GenServer with a simple generic Supervisor

### Result with anonymization

- `min`:     150
- `max`:     150
- `average`: 150
- `median`:  150

## Instructions via docker

```
$ docker build -t tupile
$ docker run -v $(pwd)/test/fixtures/purchases:/data tupile
```

## Instructions via local setup

```
$ mix do deps.get, escript.build
$ ./tupile --dir <data_dir>
```
