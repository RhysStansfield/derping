require 'net/http'

results = ARGV.each.with_object({}) do |path, obj|
  obj[path] = Hash.new([])

  File.read(path).split("\n").each do |link|
    uri = URI(link)

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)

      response = http.request(request)
      obj[path]["#{response.code}: #{response.message}"] += Array(link)
    end
  end
end

File.open('./results.txt', 'w') do |file|
  results.each_pair do |path, statuses|
    file.puts path
    file.puts

    statuses.each_pair do |status, links|
      file.puts status
      file.puts links.join("\n")
      file.puts
    end
  end
end
