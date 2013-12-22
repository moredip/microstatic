module Microstatic

class S3BucketCreator
  include UsesFog

  def initialize( aws_creds )
    check_and_store_aws_creds(aws_creds)
  end

  def create( bucket_name )
    # TODO: can we create a new directory without eagerly fetch the list of all dirs?
    directory = connection.directories.create( :key => bucket_name, :public => true )
    # TODO: can I do this by calling a method on directory? 
    connection.put_bucket_website( directory.key, 'index.html', :key => '404.html' )

    directory
  end
end

end
