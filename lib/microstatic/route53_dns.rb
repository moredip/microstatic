module Microstatic

class Route53Dns
  include UsesFog

  def initialize( aws_creds )
    check_and_store_aws_creds(aws_creds)
  end

  def add_s3_record_for_bucket( bucket_name, hostname = false )
    subdomain ||= bucket_name

    zone = parent_zone_for_subdomain( subdomain )
    cname_value = website_endpoint_for_bucket_named( bucket_name )

    record = zone.records.create(
      :name => subdomain,
      :value => cname_value,
      :type => 'CNAME',
      :ttl => 86400
    )
    record
  end

  private

  def website_endpoint_for_bucket_named( bucket_name )
    bucket = connection.directories.get(bucket_name)

    # per http://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteEndpoints.html
    #TODO: get endpoint from API, or get this logic merged into fog
    bucket_website_endpoint = "#{bucket.key}.s3-website-#{bucket.location}.amazonaws.com"
  end

  def parent_zone_for_subdomain( subdomain )
    zone_name = subdomain.split(".")[1..-1].push("").join(".")
    dns.zones.find{ |x| x.domain == zone_name }
  end

end

end
