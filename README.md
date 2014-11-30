Schemaless
==========

** On ActiveRecord/PostgreSQL **


```ruby
class Bike < ActiveRecord::Base

  #     DB's field, DB type
  field :name               # omit for String
  field :cylinders, Integer # or Float, :decimal, :currency
  field :bought_at, Date    # :date, Time, :time

  # Adds 'default: to AR
  field :three_wheeler, :boolean, default: false

  # Adds Array/Hash in PG
  field :tags, Hash  # hstore
  field :tags, Array # hstore

  index :name
  index :name, :cylinders

  ...

end

```

Why?
---

* Schema is **defined in code**, not in the DB.
(Plus no need for annotate models)

* It's easier and **less time** consuming.
Honestly, you never forgot that field and had to re-run a migration?

* There's no footprint in production mode.
No code executed in production mode.


How?
---


# DEVELOPMENT | Live mode

This mode runs only in development mode.

It's when you are working, happy, without worry about schema!
And also now DB fields are nicely described in the model.rb.

It's like NoSQL: fun!


# COMMIT

To commit your changes you have two options:


## Safe mode

You'll find a migration waiting for you in git.
You simply review it, and actually there no need to even test,
as your test suite is actually using it.


## Wild mode

Schemaphobia? Very dangerous idea?

Here we don't use any migration **as files**.
On the production servers a rake task ensures everything is up to date.


## PRODUCTION

Schemaless only stubs the #fields and #index methods in production.
There's nothing running/using resources in production.


Have fun!
