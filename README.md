# Pollynesia
Test task for simple voting rails app

## Setup

* [`rbenv`](https://github.com/sstephenson/rbenv#basic-github-checkout).

* Proper ruby version (pick it in `.ruby-version` file): ```rbenv install <version>```.
  If `rbenv` complains that version wasn't found update with ```rbenv update``` and repeat.

* `bundler`: ```gem install bundler``` if you haven't `rbenv` or proper ruby version installed .

* [`PostgreSQL`](https://wiki.postgresql.org/wiki/Detailed_installation_guides).

* Clone this repo `git clone https://github.com/chornodid/pollynesia.git && cd pollynesia`.

* ```bundle install```.

* Create development and testing databases for app: ```createdb pollynesia_dev``` and
  ```createdb pollynesia_test```.

* `cp .rbenv-vars.example .rbenv-vars` and write down user and password for
development and testing databases.

* Migrate database `rake db:migrate`.
