module Microstatic

class Route53Dns
  include UsesFog

  def initialize( aws_creds )
    check_and_store_aws_creds(aws_creds)
  end

  def add_s3_record_for_bucket( bucket_name, zone_name = false )
    subdomain = bucket_name
    zone = lookup_zone(zone_name || guess_zone_from_subdomain(subdomain) )

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

  def lookup_zone( zone_name )
    zone_name << "." unless zone_name.end_with?(".")
    dns.zones.find{ |x| x.domain == zone_name }
  end

  def guess_zone_from_subdomain( subdomain )
    subdomain.split(".")[1..-1].join(".")
  end

end

end
