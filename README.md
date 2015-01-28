# Association

## Installing

First do : `bundle install`

## Running

### Development

Do: `bundle exec shotgun app.rb`

### Staging

The staging in hosted on our *private pimp cloud* [simated.com](http://simated.com).
For now some gimnastics are required for non-rails applications.

To deploy new code do:

* `ssh deployer@178.62.143.175`
* `cd association`
* `bundle install`
* `git pull origin master`
* `touch tmp/restart.txt`

NOTE: If you are setting up a vanilla *private pimp cloud's* image you need to make a change in `/etc/nginx/sites-enabled/app` file.
The `root` has to be set to `/home/deployer/association/public`.

## Testing

Do: `bundle exec rspec`
