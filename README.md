
# Ruby on Rails tutorial sample app!

[This sample application is live!](http://rails-sample-production.mnmsgae6r4.us-east-1.elasticbeanstalk.com)

Once postgres is setup, before this can be run in production:
* Run `/usr/local/Cellar/postgresql/11.3//bin/createuser -s postgres` to create a user called `postgres`
  * Only need to do this once per computer, and the username can be whatever you want
* Change `username` in `config/database.yml` to the username that you created in the above step
* Create a `.env` file with your `HELLO_APP_DATABASE_PASSWORD`. In order to create a random password, you can run `rails secret`.
* Run `bundle exec rake db:create:all` to create the databases locally.
* Don't forget to run `heroku run rails db:migrate` for migrating a new database on heroku!

For testing:
* Run `rails test` to run all tests
* Run `bundle exec guard` in a seperate terminal window to run the tests whenever an affected file is edited

To reset the database in Heroku:
* Run `heroku pg:reset DATABASE` and then `heroku run rails db:migrate`

To seed the test data from `db/seeds,rb`, run `run rails db:seed`

To work with Rails in AWS EB, you need to SSH into the Elasic Beanstalk instance and cd to `/var/app/current/`. Then, you can run any command you'd run locally (you may need to run `sudo su` or chmod some files if you're having permissions issues).
