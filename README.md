# Directory

The directory service: the LDAP groups, the names and member status that the ASF writes into LDAP, the
LDAP audit log, and the people API that the other services read. It will hold the only LDAP write bind. It is
one of the services that replace [Whimsy](https://github.com/apache/whimsy) and split up the monolithic
Board Agenda Tool. The plan, the services and what each one owns are in
[apache/tooling-migration](https://github.com/apache/tooling-migration).

It takes the same shape as the Board Agenda Tool
([apache/tooling-agenda](https://github.com/apache/tooling-agenda)) and as
[apache/tooling-secretary-records](https://github.com/apache/tooling-secretary-records) and
[apache/tooling-roster](https://github.com/apache/tooling-roster): Python and
Quart through `asfquart`, Svelte, SQLite, ASF OAuth.

- [CONTRIBUTING.md](CONTRIBUTING.md) gets a development environment running.
- [AGENTS.md](AGENTS.md) is the contract for changing it, for people and agents alike.
- How the tool is used, role by role, is the in-app Documentation page, written
  as markdown in [app/md/documentation/](app/md/documentation/).

The Tooling team is responsible for its development.

## License

This project is licensed under the [Apache License 2.0](LICENSE).
