require "sinatra"
require "json"
require "pony"

get "/" do
  if params["secret"] == _secret
    @checkouts = Dir.glob("*.json").map do |file|
      JSON.parse(File.read(file))
    end

    erb :index
  else
    status 401
  end
end

post "/create" do
  email = params["email"]
  data = _build_blob(params)

  File.open("./#{email}-#{Time.now}.json", "w+") do |f|
    f.write(data)
  end

  Pony.mail(
    to: "jason@felloeyewear.com",
    cc: "jonathan@felloeyewear.com",
    from: "checkouts@felloeyewear.com",
    subject: "New Checkout Started",
    body: data.inspect
  )

  status 201
end

def _build_blob(params)
  {
    email: params["email"],
    device: params["device"],
    item: params["item"],
    time: Time.now
  }.to_json
end

def _secret
  "somecrazysecretpeoplewonthave"
end
