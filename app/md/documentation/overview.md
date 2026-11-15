Directory keeps the ASF's LDAP groups, the names and member status that it writes
into LDAP, the LDAP audit log and the people API that the other services read.
It is one of the services that replace Whimsy; the plan is in
`apache/tooling-migration`.

This page grows with the tool. Each section below describes one role's work;
the ones marked *yours* are the roles you hold.

## Who can see what

The directory holds personal data. For now only the Secretary can see it, and ASF
members at large have no access. Who else may read or change it is still to be
decided.
