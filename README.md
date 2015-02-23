# Microstatic

The microstatic gem turns generating your static site and deploying it to S3 into a one-liner. There's [a blog post](http://blog.thepete.net/blog/2014/01/17/microstatic-radically-simple-static-microsites/) with more details on the what and the why.

Microstatic does two things. Firstly it provides a command-line tool that makes it ridiculously simple to create a new microsite. Secondly it provides a rake task that makes it ridiculously simple to push new content to the microsite.

## Creating a new microsite

`microstatic setup` and you’re done. This will create a new S3 bucket to hold your microsite, and then add a Route 53 entry to wire that S3 bucket up to a subdomain.

## Deploying content to your microsite

`rake deploy` and you’re done. Microstatic ships with a rake task that will sync your local contents with the S3 bucket hosting your site.

## Demo time!

<iframe src="//player.vimeo.com/video/84530116" width="500" height="375" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="http://vimeo.com/84530116">Microstatic: setup a static subdomain microsite in < 30 seconds</a> from <a href="http://vimeo.com/user5163505">Pete Hodgson</a> on <a href="https://vimeo.com">Vimeo</a>.</p>



## Credits

The s3 deployment code was originally written by [Giles Alexander](http://twitter.com/gga)

## TODO
* specify MICROSTATIC_SITE_NAME and cloud creds using dot file
