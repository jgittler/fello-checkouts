require "sinatra"
require "json"

get "/" do
  @checkouts = Dir.glob("*.json").map do |file|
    JSON.parse(File.read(file))
  end

  erb :index
end

post "/create" do
  email = params["email"]

  File.open("#{email}-#{Time.now}.json", "w+") do |f|
    f.write(build_blob(params))
  end

  status 201
end


def build_blob(params)
  {
    email: params["email"],
    device: params["device"],
    item: params["item"],
    time: Time.now
  }.to_json
end
