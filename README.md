Schemaless
==========

**On ActiveRecord | PostgreSQL**

**Experimental, bugged code**, please use to submit bugs/requests.
Needs more test code and scenarios also.


```ruby
class Bike < ActiveRecord::Base

  # field column name, column type, null: limit: precision: scale:
  field :name               # omit for String
  field :cylinders, Integer # or Float, :decimal, :currency
  field :bought_at, Date    # Time, :date, :time, :timestamp

  # Adds 'default: to AR
  field :three_wheeler, :boolean, default: false

  # Adds Array/Hash in PG
  field :tags, Hash  # hstore
  field :tags, Array # hstore

  # index columns, name: unique: orders: also supported.
  index :name
  index [:name, :cylinders]
  ...
end

```

# Why?

* Schema is **defined in code**, not in the DB.
(Plus no need for annotate models)

* It's easier and **less time** consuming.
Honestly, you never forgot that field and had to re-run a migration?

* There's **no footprint** in production mode.
No code executed in production mode.


# How?

Just include the gem and run:

    rails g schemaless:setup


## DEVELOPMENT | Realtime mode

This mode runs only in development mode.

It's when you are working, happy, without worry about schemas!
And also now DB fields are nicely described in the model.rb.
Logic is all in the ruby file now. It's like NoSQL: fun!


## PRODUCTION | Migrate servers

Schemaless only stubs the #fields and #index methods in production.
There's nothing running/using resources in production.

To commit your changes you have two options:

## Safe mode

In safe mode there's no change in the production perspective:

    rails g schemaless:migrations

You'll find a migration per changed table waiting for you in git.
You simply review'em, and actually, there's no need to test them,
as your test suite is using them.


## Wild mode

Schemaphobia? Very dangerous idea?

    rake schemaless:run

Here we don't use any migration **as files**.
On the production servers a rake task ensures everything is up to date.
Tests also use the schema on the models.



---

Have fun!
