require "sinatra"
require "json"

post "/create" do
  email = params["email"]

  File.open("#{email}-#{Time.now}.json", "w+") do |f|
    f.write(build_blob(params))
  end
end


def build_blob(params)
  {
    email: params["email"],
    device: params["device"],
    item: params["item"],
    time: Time.now
  }.to_json
end
