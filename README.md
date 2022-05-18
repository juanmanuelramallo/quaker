# Quaker

[![CI](https://github.com/juanmanuelramallo/quaker/actions/workflows/ci.yml/badge.svg)](https://github.com/juanmanuelramallo/quaker/actions/workflows/ci.yml)

Solves [this test](./TEST.md).

## Running

To run the script that outputs the report:

```bash
./main
```

[Output](./OUTPUT.json)

To generate the report of kills by means:

```bash
./main --by-means
```

[Output](./OUTPUT_BY_MEANS.json)

## API Documentation

[https://rubydoc.info/github/juanmanuelramallo/quaker/master/](https://rubydoc.info/github/juanmanuelramallo/quaker/master/)

## Testing

```bash
bundle exec rspec
```

## Notes for the reader

When the killer kills themself, the report counts the kill towards the total kills of the player. This is a decision I made considering that there was no rule defined for this scenario as there is when the world kills a player. In the end, making this decision simplifies things.

I'm using a UUID to name the matches, just so that matches are independent among each other, no need to pass an index integer when constructing a match.

Enjoy ?)
