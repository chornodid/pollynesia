# Pollynesia
Test task for simple voting rails app

## Usage

There are 4 models:
* User

  User model have 2 roles - 'admin' and 'regular'. 'Regular' users sign up through frontend.
  'Admin' user can be created through `rake db:create_admin_user' task.

* Poll

  Has following attributes: title, author, status (draft, open and closed). Default
  status is draft. After poll is ready (added more then one option) then poll can
  be opened. Poll edit and open event is allowed only to author. Close event is
  allowed to author or admin. To create poll one need to sign in/up.

* Option

  Has following attributes: title and position (ordinal number in options list). Belongs to Poll.

* Vote

  Has following attributes: ip address. Belongs to User and Option. Voting limits: 1 vote per user,
  2 votes per ip address.

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

## Tests and code style check

* `bundle exec rspec`
* `rubocop`
