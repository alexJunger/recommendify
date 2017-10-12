class Recommendify::CoconcurrentInputMatrix < Recommendify::InputMatrix

  include Recommendify::CCMatrix

  def initialize(opts={})
    check_native if opts[:native]
    super(opts)
  end

  def similarities_for(item1)
    return run_native(item1) if @opts[:native]
  end

private

  def run_native(item_id)
    res = %x{#{native_path} --coconcurrent "#{redis_key}" "#{item_id}" "#{redis_url}"}
    raise "error: dirty exit (#{$?})" if $? != 0
    res.split("\n").map do |line|
      sim = line.match(/OUT: \(([^\)]*)\) \(([^\)]*)\)/)
      unless sim
        raise "error: #{res}" unless (res||"").include?('exit:')
      else
        [sim[1], sim[2].to_f]
      end
    end.compact
  end

  def check_native
    return true if ::File.exists?(native_path)
    raise "recommendify_native not found - you need to run rake build_native first"
  end

  def native_path
    ::File.expand_path('../../../bin/recommendify', __FILE__)
  end

  def redis_url
    Recommendify.redis.client.location
  end

end
