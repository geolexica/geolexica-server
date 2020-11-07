# (c) Copyright 2020 Ribose Inc.
#

namespace :geolexica do

  desc "Deploy site to S3"
  task :s3_deploy do
    s3sync_patterns_and_options = {
      "*.html" => ["--content-type", "text/html; charset=utf-8"],
      "*.json" => ["--content-type", "application/json; charset=utf-8"],
      "*.jsonld" => ["--content-type", "application/ld+json; charset=utf-8"],
      "*.tbx.xml" => ["--content-type", "application/xml; charset=utf-8"],
      "*.ttl" => ["--content-type", "text/turtle; charset=utf-8"],
      "*.yaml" => ["--content-type", "text/yaml; charset=utf-8"],
    }

    s3sync_patterns_and_options.each_pair do |pattern, options|
      s3_sync "--exclude", "*", "--include", pattern, *options
    end

    # Remaining files
    remaining_patterns = s3sync_patterns_and_options.keys
    s3_sync "--include", "*", *remaining_patterns.flat_map { |k| ["--exclude", k] }

    aws "configure", "set", "preview.cloudfront", "true"

    aws "cloudfront", "create-invalidation",
      "--distribution-id", ENV["CLOUDFRONT_DISTRIBUTION_ID"],
      "--paths", "/*"
  end

  def s3_sync(*args)
    source = "_site"
    target = "s3://#{ENV["S3_BUCKET_NAME"]}"
    common_options = ["--region", ENV["AWS_REGION"], "--delete", "--no-progress"]

    aws "s3", "sync", source, target, *common_options, *args
  end

  def aws(*args)
    system "aws", *args, exception: true
  end

end
